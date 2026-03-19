import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:predictive_text_input/data/data_source/local_data_sources.dart';
import 'package:predictive_text_input/data/repositories_impl/prediction_repositery_impl.dart';
import 'package:predictive_text_input/domain/entities/word_suggestions.dart';
import 'package:predictive_text_input/domain/usecases/get_suggestion_usecases.dart';


class PredictionController extends GetxController {
  final suggestions = <WordSuggestion>[].obs;

  final repository =
  PredictionRepositoryImpl(LocalDictionary());

  late final GetSuggestionsUseCase getSuggestions;

  final inlineSuggestion = ''.obs;

  @override
  void onInit() {
    getSuggestions = GetSuggestionsUseCase(repository);
    super.onInit();
  }
  void applySuggestion(
      String suggestion,
      TextEditingController textController,
      ) {

    final text = textController.text;

    final words = text.split(" ");

    if (words.isNotEmpty) {
      words.removeLast();
    }

    words.add(suggestion);

    final newText = "${words.join(" ")} ";

    textController.text = newText;

    textController.selection = TextSelection.fromPosition(
      TextPosition(offset: newText.length),
    );

    /// learn word
    repository.updateFrequency(suggestion);

    /// reset suggestions
    suggestions.clear();
    inlineSuggestion.value = '';

    /// trigger prediction again
    onTextChanged(newText);
  }
  void onTextChanged(String text) {
    if (text.isEmpty) {
      suggestions.clear();
      inlineSuggestion.value = '';
      return;
    }

    /// Detect space → user finished a word
    if (text.endsWith(" ")) {

      /// SAVE WORD
      processInput(text);

      final words = text.trim().split(" ");

      final last = words.last;

      final nextSuggestions = repository.getNextWords(last);

      suggestions.value = nextSuggestions
          .map((e) => WordSuggestion(word: e, score: 100))
          .toList();

      return;
    }    final currentWord = text.split(" ").last;

    final result = getSuggestions(currentWord);

    suggestions.value = result;

    /// Inline suggestion
    if (result.isNotEmpty) {
      final top = result.first.word;

      if (top.startsWith(currentWord) && top != currentWord) {
        inlineSuggestion.value = top.substring(currentWord.length);
      } else {
        inlineSuggestion.value = '';
      }
    }
  }
  void selectWord(String word) {
    repository.updateFrequency(word);
    suggestions.clear();
    inlineSuggestion.value = '';
  }
  void processInput(String text) {

    final words = text.trim().split(" ");

    if (words.length < 2) {
      learnNewWord(words.last);
      return;
    }

    final previous = words[words.length - 2];
    final current = words.last;

    repository.saveOrUpdateWord(current);

    repository.updateBigram(previous, current);
  }  /// NEW FEATURE
  void learnNewWord(String word) {
    repository.saveOrUpdateWord(word);
  }
}