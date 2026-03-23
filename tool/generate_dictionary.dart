import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';

void main() async {
  final file = File('google-10000-english.txt');

  final lines = await file.readAsLines();

  final Map<String, int> dictionary = {};

  int score = 100;

  for (var word in lines) {
    word = word.trim().toLowerCase();

    if (word.isEmpty) continue;

    dictionary[word] = score;

    if (score > 1) score--;
  }

  final jsonFile = File('base_words.json');

  await jsonFile.writeAsString(
    const JsonEncoder.withIndent('  ').convert(dictionary),
  );

  debugPrint("Dictionary generated with ${dictionary.length} words");
}