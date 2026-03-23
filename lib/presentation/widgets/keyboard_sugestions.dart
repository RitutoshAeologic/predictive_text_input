import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:predictive_text_input/core/constant/app_colors.dart';
import 'package:predictive_text_input/core/constant/app_strings.dart';
import 'package:predictive_text_input/core/constant/dimensions_constant.dart';
import 'package:predictive_text_input/presentation/widgets/suggestion_chip.dart';

class KeyboardSuggestionBar extends StatelessWidget {
  final List<String> suggestions;
  final ValueChanged<String> onTap;

  const KeyboardSuggestionBar({
    super.key,
    required this.suggestions,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOut,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.keyBar,
          border: Border(
            top: BorderSide(color: AppColors.divider, width: AppDimensions.px1.w),
          ),
        ),
        child: suggestions.isEmpty
            ? _buildEmptyState()
            : _buildChipRail(),
      ),
    );
  }

  Widget _buildEmptyState() {
    return SizedBox(
      height: AppDimensions.px48,
      child: Center(
        child: Text(
         AppStrings.startTypingSuggestions,
          style: TextStyle(
            fontSize: AppDimensions.px12.sp,
            color: AppColors.textHint,
            letterSpacing: 0.2,
          ),
        ),
      ),
    );
  }

  Widget _buildChipRail() {
    return SizedBox(
      height: AppDimensions.px52.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding:  EdgeInsets.symmetric(horizontal: AppDimensions.px12.w, vertical: AppDimensions.px8.h),
        itemCount: suggestions.length,
        separatorBuilder: (_, i) => _buildDivider(i),
        itemBuilder: (_, i) => SuggestionChip(
          word: suggestions[i],
          isPrimary: i == 0,
          onTap: () {
            HapticFeedback.selectionClick();
            onTap(suggestions[i]);
          },
        ),
      ),
    );
  }

  /// Thin vertical divider between chips — mimics native iOS keyboard bar.
  Widget _buildDivider(int index) {
    return Container(
      width: 1,
      margin:  EdgeInsets.symmetric(vertical: AppDimensions.px6.h),
      color: AppColors.divider,
    );
  }
}


