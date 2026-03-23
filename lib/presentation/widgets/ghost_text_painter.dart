import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:predictive_text_input/core/constant/app_colors.dart';
import 'package:predictive_text_input/core/constant/dimensions_constant.dart';

/// Paints the typed text in transparent (invisible) and
/// appends the ghost suffix in a muted colour — aligning
/// perfectly with the TextField's rendered characters.
class GhostTextPainter extends StatelessWidget {
  final String typedText;
  final String ghostSuffix;

  const GhostTextPainter({super.key,
    required this.typedText,
    required this.ghostSuffix,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          // Transparent copy of typed text — occupies same space
          TextSpan(
            text: typedText,
            style:  TextStyle(
              fontSize: AppDimensions.px16.sp,
              height: 1.6,
              color: Colors.transparent,
              fontFamily: 'Georgia',
              letterSpacing: 0.1,
            ),
          ),
          // Ghost suffix
          TextSpan(
            text: ghostSuffix,
            style: TextStyle(
              fontSize: AppDimensions.px16.sp,
              height: 1.6,
              color: AppColors.textHint.withOpacity(0.7),
              fontFamily: 'Georgia',
              letterSpacing: 0.1,
            ),
          ),
        ],
      ),
    );
  }
}