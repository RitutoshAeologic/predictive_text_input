import 'package:hive/hive.dart';

part 'word_model.g.dart';

@HiveType(typeId: 1)
class WordModel extends HiveObject {

  @HiveField(0)
  String word;

  @HiveField(1)
  int frequency;

  WordModel({
    required this.word,
    this.frequency = 1,
  });
}