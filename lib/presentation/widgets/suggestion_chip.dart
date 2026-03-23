import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:predictive_text_input/core/constant/app_colors.dart';
import 'package:predictive_text_input/core/constant/dimensions_constant.dart';

class SuggestionChip extends StatefulWidget {
  final String word;
  final bool isPrimary;
  final VoidCallback onTap;

  const SuggestionChip({super.key,
    required this.word,
    required this.isPrimary,
    required this.onTap,
  });

  @override
  State<SuggestionChip> createState() => _SuggestionChipState();
}

class _SuggestionChipState extends State<SuggestionChip> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        padding:  EdgeInsets.symmetric(horizontal: AppDimensions.px16.w),
        decoration: BoxDecoration(
          color: _pressed
              ? AppColors.accent.withOpacity(0.12)
              : widget.isPrimary
              ? AppColors.accentSoft
              : Colors.transparent,
          borderRadius: BorderRadius.circular(AppDimensions.px8.r),
        ),
        alignment: Alignment.center,
        child: Text(
          widget.word,
          style: TextStyle(
            fontSize: AppDimensions.px15.sp,
            fontWeight:
            widget.isPrimary ? FontWeight.w600 : FontWeight.w400,
            color: widget.isPrimary
                ? AppColors.accentDeep
                : AppColors.textPrimary,
            letterSpacing: widget.isPrimary ? 0.1 : 0,
          ),
        ),
      ),
    );
  }
}