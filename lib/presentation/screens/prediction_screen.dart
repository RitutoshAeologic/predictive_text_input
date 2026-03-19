import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:predictive_text_input/core/constant/app_strings.dart';
import 'package:predictive_text_input/core/constant/dimensions_constant.dart';
import 'package:predictive_text_input/presentation/controllers/prediction_controller.dart';
import 'package:flutter/material.dart';
import 'package:predictive_text_input/presentation/widgets/inline_suggestion.dart';
import 'package:predictive_text_input/presentation/widgets/keyboard_sugestions.dart';

class PredictiveScreen extends StatefulWidget {
  const PredictiveScreen({super.key});

  @override
  State<PredictiveScreen> createState() => _PredictiveScreenState();
}

class _PredictiveScreenState extends State<PredictiveScreen> {
  final controller = Get.put(PredictionController());

  final textController = TextEditingController();

  void submitWord() {
    final word = textController.text.trim();

    if (word.isEmpty) return;

    controller.learnNewWord(word);
  }

  @override
  void initState() {
    super.initState();

    textController.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.appDemoTitle)),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 24),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppDimensions.px16),
              child: Obx(
                () => InlineSuggestionField(
                  controller: textController,
                  suggestion: controller.inlineSuggestion.value,
                  onChanged: controller.onTextChanged,
                ),
              ),
            ),

            const Spacer(),

            Obx(
              () => KeyboardSuggestionBar(
                suggestions: controller.suggestions.map((e) => e.word).toList(),
                onTap: (word) {
                  controller.applySuggestion(word, textController);
                },
              ),
            ),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: submitWord,
        child: const Icon(Icons.check),
      ),
    );
  }
}
