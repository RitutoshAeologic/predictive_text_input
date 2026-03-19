import 'package:predictive_text_input/core/services/hive_services.dart';
import 'package:predictive_text_input/data/data_source/local_data_sources.dart';
import 'package:predictive_text_input/domain/entities/word_model.dart';
import 'package:predictive_text_input/domain/entities/word_suggestions.dart';
import 'package:predictive_text_input/domain/repositories/prediction_repositery.dart';

class PredictionRepositoryImpl implements PredictionRepository {
  final LocalDictionary dataSource;

  PredictionRepositoryImpl(this.dataSource);

  @override
  @override
  List<WordSuggestion> getSuggestions(String input) {

    final box = HiveService.wordsBox;

    final combined = {...LocalDictionary.baseWords};

    /// merge hive stored words
    for (var item in box.values) {

      /// Ignore bigram keys
      if (item.word.contains("_")) continue;

      combined[item.word] =
          (combined[item.word] ?? 0) + item.frequency * 3;
    }

    final results = combined.entries
        .where((e) => e.key.startsWith(input.toLowerCase()))
        .map((e) => WordSuggestion(word: e.key, score: e.value))
        .toList();

    results.sort((a, b) => b.score.compareTo(a.score));

    return results.take(6).toList();
  }
  @override
  @override
  void updateFrequency(String word) {

    final box = HiveService.wordsBox;

    final existing = box.values
        .where((e) => e.word == word)
        .toList();

    if (existing.isNotEmpty) {

      final item = existing.first;
      item.frequency += 1;
      item.save();

    } else {

      box.add(
        WordModel(word: word, frequency: 1),
      );

    }
  }
  /// NEW FEATURE
  void saveOrUpdateWord(String word) {
    updateFrequency(word);
  }

  void updateBigram(String previous, String next) {
    final box = HiveService.wordsBox;

    final key = "${previous}_$next";

    final existing = box.values.where((e) => e.word == key).toList();

    if (existing.isNotEmpty) {
      final item = existing.first;
      item.frequency += 1;
      item.save();
    } else {
      box.add(
        WordModel(word: key, frequency: 1),
      );
    }
  }
  List<String> getNextWords(String word) {
    final box = HiveService.wordsBox;

    final entries = box.values
        .where((e) => e.word.startsWith("${word}_"))
        .toList();

    entries.sort((a, b) => b.frequency.compareTo(a.frequency));

    return entries
        .map((e) => e.word.split("_").last)
        .take(5)
        .toList();
  }
  @override
  List<String> getNextWordSuggestions(String input) {
    return dataSource.nextWordMap[input.toLowerCase()] ?? [];
  }

}