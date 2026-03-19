import 'package:predictive_text_input/domain/entities/word_suggestions.dart';

abstract class PredictionRepository {
  List<WordSuggestion> getSuggestions(String input);
  List<String> getNextWordSuggestions(String input);
  void updateFrequency(String word);
  }
