import 'package:flutter/material.dart';
import 'package:predictive_text_input/core/constant/app_strings.dart';
import 'package:predictive_text_input/core/constant/dimensions_constant.dart';



class InlineSuggestionField extends StatelessWidget {
  final TextEditingController controller;
  final String suggestion;
  final Function(String) onChanged;

  const InlineSuggestionField({
    super.key,
    required this.controller,
    required this.suggestion,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.centerLeft,
      children: [
        /// suggestion overlay
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppDimensions.px12, vertical: AppDimensions.px14),
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: controller.text,
                  style: const TextStyle(color: Colors.transparent),
                ),
                TextSpan(
                  text: suggestion,
                  style: TextStyle(color: Colors.grey.shade400),
                ),
              ],
            ),
          ),
        ),

        /// real input
        TextField(
          controller: controller,
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: AppStrings.typeSomething,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
      ],
    );
  }
}
