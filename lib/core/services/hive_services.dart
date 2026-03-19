import 'package:hive_flutter/hive_flutter.dart';
import 'package:predictive_text_input/domain/entities/word_model.dart';

class HiveService {

  static const String wordBox = "words_box";

  static Future<void> init() async {
    await Hive.initFlutter();

    /// register adapter
    Hive.registerAdapter(WordModelAdapter());

    /// open typed box
    await Hive.openBox<WordModel>(wordBox);
  }

  static Box<WordModel> get wordsBox =>
      Hive.box<WordModel>(wordBox);
}