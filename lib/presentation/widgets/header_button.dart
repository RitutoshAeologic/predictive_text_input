
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:predictive_text_input/core/constant/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:predictive_text_input/core/constant/dimensions_constant.dart';

class HeaderButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isPrimary;
  const HeaderButton({super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.isPrimary = false,
  });
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding:  EdgeInsets.symmetric(horizontal: AppDimensions.px12.w, vertical: AppDimensions.px7.h),
        decoration: BoxDecoration(
          color: isPrimary ? AppColors.accent : AppColors.surface,
          borderRadius: BorderRadius.circular(AppDimensions.px10),
          border: Border.all(
              color: isPrimary ? Colors.transparent : AppColors.border),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon,
                size: AppDimensions.px14.sp,
                color: isPrimary ? Colors.white : AppColors.textSecondary),
            const SizedBox(width: AppDimensions.px5),
            Text(label,
                style: TextStyle(
                  fontSize: AppDimensions.px12.sp,
                  fontWeight: FontWeight.w600,
                  color: isPrimary ? Colors.white : AppColors.textSecondary,
                )),
          ],
        ),
      ),
    );
  }
}
