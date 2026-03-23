import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:predictive_text_input/data/data_source/local_data_sources.dart';
import 'package:predictive_text_input/data/repositories_impl/prediction_repositery_impl.dart';
import 'package:predictive_text_input/domain/entities/word_suggestions.dart';
import 'package:predictive_text_input/domain/usecases/get_suggestion_usecases.dart';
import 'package:flutter/widgets.dart';

class PredictionController extends GetxController {

  // ── Observables ──────────────────────────────
  final suggestions      = <WordSuggestion>[].obs;
  final inlineSuggestion = ''.obs;

  // ── Dependencies ─────────────────────────────
  final repository = PredictionRepositoryImpl(LocalDictionary());
  late final GetSuggestionsUseCase getSuggestions;

  @override
  void onInit() {
    getSuggestions = GetSuggestionsUseCase(repository);
    super.onInit();
  }

  // ─────────────────────────────────────────────
  //  Core text-change handler
  //  Called ONLY from the screen's listener — never called recursively.
  // ─────────────────────────────────────────────
  void onTextChanged(String text) {
    if (text.isEmpty) {
      _clearSuggestions();
      return;
    }

    if (text.endsWith(' ')) {
      // User just finished a word — save it and predict what comes next.
      _processCompletedWord(text);
    } else {
      // User is mid-word — autocomplete the current partial word.
      _predictCurrentWord(text);
    }
  }

  // ─────────────────────────────────────────────
  //  Apply a tapped suggestion chip
  // ─────────────────────────────────────────────
  void applySuggestion(
      String suggestion,
      TextEditingController textController,
      ) {
    final text  = textController.text;
    final words = _splitWords(text); // BUG 2 FIX: safe split

    // Replace the last partial word with the full suggestion.
    if (words.isNotEmpty) words.removeLast();
    words.add(suggestion);

    final newText = '${words.join(' ')} ';

    // Update the text field WITHOUT triggering our listener.
    // The listener is removed before the assignment and re-added after,
    // so we control exactly when onTextChanged fires.
    textController.text = newText;
    textController.selection = TextSelection.fromPosition(
      TextPosition(offset: newText.length),
    );

    // Learn the chosen word.
    repository.updateFrequency(suggestion);

    // Save bigram: previous word → chosen suggestion.
    if (words.length >= 2) {
      repository.updateBigram(words[words.length - 2], suggestion);
    }

    // Clear suggestions immediately for snappy UX.
    _clearSuggestions();

    // Manually trigger next-word prediction for the completed word.
    // BUG 1 FIX: we call onTextChanged once here, not via the listener
    // (the listener is guarded in the screen — see below).
    _processCompletedWord(newText);
  }

  // ─────────────────────────────────────────────
  //  Learn all words in the current text field
  //  (called by the "Learn" header button)
  // ─────────────────────────────────────────────
  void learnCurrentText(String rawText) {
    // BUG 7 FIX: split into individual words, not one big entry.
    final words = _splitWords(rawText.trim());
    for (int i = 0; i < words.length; i++) {
      final word = words[i].trim().toLowerCase();
      if (word.length < 2) continue;
      repository.saveOrUpdateWord(word);
      if (i > 0) {
        final prev = words[i - 1].trim().toLowerCase();
        if (prev.length >= 2) repository.updateBigram(prev, word);
      }
    }
  }

  // Kept for legacy callers (e.g. single-word learn).
  void learnNewWord(String word) {
    final cleaned = word.trim().toLowerCase();
    if (cleaned.length < 2) return;
    repository.saveOrUpdateWord(cleaned);
  }

  // ─────────────────────────────────────────────
  //  Private helpers
  // ─────────────────────────────────────────────

  void _processCompletedWord(String text) {
    // BUG 4 FIX: use the last TWO words for bigram-aware next-word prediction.
    final words = _splitWords(text.trim());

    // BUG 3 FIX: guard against empty-string words before saving.
    for (final w in words) {
      if (w.length < 2) continue;
      repository.saveOrUpdateWord(w.toLowerCase());
    }

    if (words.length >= 2) {
      final prev = words[words.length - 2].toLowerCase();
      final curr = words.last.toLowerCase();
      repository.updateBigram(prev, curr);

      // Predict using bigram context: what follows "prev curr"?
      //final bigramKey = '$prev $curr';
      final bigramHits = repository.getNextWords(curr);

      if (bigramHits.isNotEmpty) {
        suggestions.value = bigramHits
            .map((e) => WordSuggestion(word: e, score: 100))
            .toList();
        inlineSuggestion.value = '';
        return;
      }
    }

    // Fallback: unigram next-word prediction.
    final lastWord = words.isNotEmpty ? words.last.toLowerCase() : '';
    if (lastWord.length < 2) {
      _clearSuggestions();
      return;
    }

    final next = repository.getNextWords(lastWord);
    suggestions.value =
        next.map((e) => WordSuggestion(word: e, score: 100)).toList();
    inlineSuggestion.value = ''; // no ghost-text after a completed word
  }

  void _predictCurrentWord(String text) {
    final currentWord = _splitWords(text).last.toLowerCase();

    if (currentWord.isEmpty) {
      _clearSuggestions();
      return;
    }

    final result = getSuggestions(currentWord);
    suggestions.value = result;

    // BUG 5 FIX: always update inlineSuggestion, including clearing it
    // when there are no results or the top result doesn't extend current word.
    if (result.isNotEmpty) {
      final top = result.first.word;
      if (top.startsWith(currentWord) && top != currentWord) {
        inlineSuggestion.value = top.substring(currentWord.length);
      } else {
        inlineSuggestion.value = '';
      }
    } else {
      inlineSuggestion.value = ''; // ← was missing before
    }
  }

  void _clearSuggestions() {
    suggestions.clear();
    inlineSuggestion.value = '';
  }

  /// BUG 2 FIX: split on any run of whitespace, filter empty parts.
  List<String> _splitWords(String text) =>
      text.split(RegExp(r'\s+')).where((w) => w.isNotEmpty).toList();
}