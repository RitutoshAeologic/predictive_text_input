import 'package:predictive_text_input/domain/entities/word_suggestions.dart';
import 'package:predictive_text_input/domain/repositories/prediction_repositery.dart';


class GetSuggestionsUseCase {
  final PredictionRepository repository;

  GetSuggestionsUseCase(this.repository);

  List<WordSuggestion> call(String input) {
    return repository.getSuggestions(input);
  }
}