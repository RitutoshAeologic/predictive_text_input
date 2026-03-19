import 'package:flutter/material.dart';
import 'package:predictive_text_input/core/constant/dimensions_constant.dart';


class KeyboardSuggestionBar extends StatelessWidget {

  final List<String> suggestions;
  final Function(String) onTap;

  const KeyboardSuggestionBar({
    super.key,
    required this.suggestions,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {

    if (suggestions.isEmpty) return const SizedBox();

    return Container(
      height: AppDimensions.px56,
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.px8),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        border: const Border(
          top: BorderSide(color: Colors.black12),
        ),
      ),
      child: Row(
        children: suggestions.map((word) {

          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppDimensions.px4),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black87,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppDimensions.px10),
                  ),
                ),
                onPressed: () => onTap(word),
                child: Text(
                  word,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          );

        }).toList(),
      ),
    );
  }
}