import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:predictive_text_input/core/constant/app_colors.dart';
import 'package:predictive_text_input/core/constant/app_strings.dart';
import 'package:predictive_text_input/core/constant/dimensions_constant.dart';

class AcceptButton extends StatelessWidget {
  final VoidCallback onTap;
  const AcceptButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.all(AppDimensions.px10.r),
        padding: EdgeInsets.symmetric(
          horizontal: AppDimensions.px10.w,
          vertical: AppDimensions.px4.h,
        ),
        decoration: BoxDecoration(
          color: AppColors.accentSoft,
          borderRadius: BorderRadius.circular(AppDimensions.px8.r),
          border: Border.all(color: AppColors.accent.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              AppStrings.tab,
              style: TextStyle(
                fontSize: AppDimensions.px11.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.accentDeep,
                letterSpacing: 0.5,
              ),
            ),
             SizedBox(width: AppDimensions.px3.w),
            Icon(
              Icons.arrow_forward_rounded,
              size: AppDimensions.px12.r,
              color: AppColors.accentDeep,
            ),
          ],
        ),
      ),
    );
  }
}
