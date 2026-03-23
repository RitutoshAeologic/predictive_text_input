
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:predictive_text_input/core/constant/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:predictive_text_input/core/constant/dimensions_constant.dart';
class StatPill extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;
  const StatPill({super.key, required this.icon, required this.label, this.active = false});
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      padding:  EdgeInsets.symmetric(horizontal: AppDimensions.px10.w, vertical: AppDimensions.px5.h),
      decoration: BoxDecoration(
        color: active ? AppColors.accentSoft : AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.px20.r),
        border: Border.all(
            color: active ? AppColors.accent.withOpacity(0.3) : AppColors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon,
              size: AppDimensions.px12.r,
              color: active ? AppColors.accentDeep : AppColors.textHint),
           SizedBox(width: AppDimensions.px5.w),
          Text(label,
              style: TextStyle(
                fontSize: AppDimensions.px11.sp,
                fontWeight: FontWeight.w500,
                color: active ? AppColors.accentDeep : AppColors.textHint,
              )),
        ],
      ),
    );
  }
}
