import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:predictive_text_input/core/constant/app_colors.dart';
import 'package:predictive_text_input/core/constant/app_strings.dart';
import 'package:predictive_text_input/core/constant/dimensions_constant.dart';

import 'accept_button.dart';
import 'ghost_text_painter.dart';

/// A text field that shows a ghost-text inline suggestion
/// (greyed completion that the user can accept with → or space-tap).
class InlineSuggestionField extends StatelessWidget {
  final TextEditingController controller;
  final String suggestion;       // suffix to show after current word
  final ValueChanged<String> onChanged;
  final VoidCallback? onSubmit;  // called when user taps ✓ FAB

  const InlineSuggestionField({
    super.key,
    required this.controller,
    required this.suggestion,
    required this.onChanged,
    this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(AppDimensions.px16),
        border: Border.all(color: AppColors.border, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: AppDimensions.px12.r,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          // ── Ghost-text layer ────────────────────
          // Rendered behind the real field so the suggestion
          // appears in exactly the same position as the typed text.
          if (suggestion.isNotEmpty)
            Positioned.fill(
              child: Padding(
                padding:  EdgeInsets.all(AppDimensions.px16.r),
                child: GhostTextPainter(
                  typedText: controller.text,
                  ghostSuffix: suggestion,
                ),
              ),
            ),

          // ── Real text field ──────────────────────
          TextField(
            controller: controller,
            onChanged: onChanged,
            maxLines: 5,
            minLines: 3,
            style:  TextStyle(
              fontSize: AppDimensions.px16.sp,
              height: 1.6,
              color: AppColors.textPrimary,
              fontFamily: 'Georgia', // editorial serif feel
              letterSpacing: 0.1,
            ),
            decoration: InputDecoration(
              hintText: AppStrings.startTyping,
              hintStyle: TextStyle(
                fontSize: AppDimensions.px16.sp,
                height: 1.6,
                color: AppColors.textHint,
                fontFamily: 'Georgia',
              ),
              contentPadding:  EdgeInsets.all(AppDimensions.px16.r),
              border: InputBorder.none,
              // Suffix accept-button — only visible when there's a suggestion
              suffixIcon: suggestion.isNotEmpty
                  ? AcceptButton(
                onTap: () {
                  // Accept inline suggestion
                  final newText = controller.text + suggestion;
                  controller.text = newText;
                  controller.selection = TextSelection.fromPosition(
                    TextPosition(offset: newText.length),
                  );
                  onChanged(newText);
                },
              )
                  : null,
            ),
            cursorColor: AppColors.accent,
            cursorWidth: 2,
          ),
        ],
      ),
    );
  }
}



