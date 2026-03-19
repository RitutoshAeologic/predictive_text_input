
import 'dart:convert';
import 'package:flutter/services.dart';

class LocalDictionary {

  static final Map<String, int> baseWords = {};

  /// load dictionary from json
  static Future<void> load() async {

    final jsonString =
    await rootBundle.loadString('assets/dictionaries/base_words.json');

    final Map<String, dynamic> jsonMap = json.decode(jsonString);

    jsonMap.forEach((key, value) {
      baseWords[key] = value;
    });
  }

  /// next word prediction map
  final Map<String, List<String>> nextWordMap = {
    "how are": ["you", "they"],
    "i am": ["fine", "happy", "good"],
    "thank": ["you", "god"],
    "good": ["morning", "afternoon", "evening"],
  };
}