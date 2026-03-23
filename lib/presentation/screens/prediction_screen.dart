import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:predictive_text_input/core/constant/app_colors.dart';
import 'package:predictive_text_input/core/constant/app_strings.dart';
import 'package:predictive_text_input/core/constant/dimensions_constant.dart';
import 'package:predictive_text_input/presentation/controllers/prediction_controller.dart';
import 'package:flutter/material.dart';
import 'package:predictive_text_input/presentation/widgets/header_button.dart';
import 'package:predictive_text_input/presentation/widgets/inline_suggestion.dart';
import 'package:predictive_text_input/presentation/widgets/keyboard_sugestions.dart';
import 'package:flutter/services.dart';
import 'package:predictive_text_input/presentation/widgets/start_pill.dart';


class PredictiveScreen extends StatefulWidget {
  const PredictiveScreen({super.key});

  @override
  State<PredictiveScreen> createState() => _PredictiveScreenState();
}

class _PredictiveScreenState extends State<PredictiveScreen>
    with SingleTickerProviderStateMixin {

  final controller     = Get.put(PredictionController());
  final textController = TextEditingController();
  late final AnimationController _fadeCtrl;
  late final Animation<double>   _fadeAnim;

  int _sessionWordCount = 0;
  final Set<String> _sessionWords = {};

  bool _suppressListener = false;

  @override
  void initState() {
    super.initState();
    _fadeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..forward();
    _fadeAnim = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeOut);
    textController.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    if (_suppressListener) return; // guard against double-fire
    final text = textController.text;
    controller.onTextChanged(text);
    _updateSessionStats(text);
  }

  void _updateSessionStats(String text) {
    final words = text.trim().split(RegExp(r'\s+'));
    for (final w in words) {
      if (w.length > 1) _sessionWords.add(w.toLowerCase());
    }
    if (mounted) setState(() => _sessionWordCount = _sessionWords.length);
  }

  void _applySuggestion(String word) {
    _suppressListener = true;
    controller.applySuggestion(word, textController);
    _updateSessionStats(textController.text);
    _suppressListener = false;
  }

  void _submitWord() {
    final text = textController.text.trim();
    if (text.isEmpty) return;
    HapticFeedback.mediumImpact();
    controller.learnCurrentText(text);
    _showLearnedSnackbar(text);
  }

  void _clearText() {
    _suppressListener = true;
    textController.clear();
    _suppressListener = false;
    controller.onTextChanged('');
    _sessionWords.clear();
    setState(() => _sessionWordCount = 0);
  }

  void _showLearnedSnackbar(String text) {
    final words = text.trim().split(RegExp(r'\s+')).where((w) => w.length > 1).toList();
    final label = words.length == 1 ? '"${words.first}"' : '${words.length} words';
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.textPrimary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimensions.px12.r)),
        margin: const EdgeInsets.fromLTRB(AppDimensions.px16, AppDimensions.px0, AppDimensions.px16, AppDimensions.px12),
        duration: const Duration(seconds: 2),
        content: Row(
          children: [
            Container(
              width: AppDimensions.px28.w,
              height: AppDimensions.px28.h,
              decoration: BoxDecoration(
                color: AppColors.accent,
                borderRadius: BorderRadius.circular(AppDimensions.px6.r),
              ),
              child:  Icon(Icons.check_rounded, color: Colors.white, size: AppDimensions.px16.r),
            ),
            const SizedBox(width: AppDimensions.px10),
            Text('$label ${AppStrings.learned}',
                style:  TextStyle(
                    color: Colors.white, fontSize: AppDimensions.px14.sp, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    textController.removeListener(_onTextChanged);
    textController.dispose();
    _fadeCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: _buildTheme(),
      child: Scaffold(
        backgroundColor: AppColors.bg,
        body: FadeTransition(
          opacity: _fadeAnim,
          child: SafeArea(
            child: Column(
              children: [
                _buildHeader(),
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: AppDimensions.px16.w),
                    keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                         SizedBox(height: AppDimensions.px12.h),
                        _buildStatsRow(),
                         SizedBox(height: AppDimensions.px14.h),
                        _buildTextField(),
                         SizedBox(height: AppDimensions.px10.h),
                        _buildActionRow(),
                         SizedBox(height: AppDimensions.px24.h),
                        _buildTipsCard(),
                         SizedBox(height: AppDimensions.px16.h),
                      ],
                    ),
                  ),
                ),
                _buildSuggestionBar(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ThemeData _buildTheme() => ThemeData.light().copyWith(
    scaffoldBackgroundColor: AppColors.bg,
    colorScheme: const ColorScheme.light(
      primary: AppColors.accent,
      surface: AppColors.surface,
    ),
  );

  Widget _buildHeader() {
    return Container(
      padding:  EdgeInsets.fromLTRB(AppDimensions.px20.w, AppDimensions.px16.h, AppDimensions.px16.w, AppDimensions.px12.h),
      decoration: BoxDecoration(
        color: AppColors.bg,
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          Container(
            width: AppDimensions.px34,
            height: AppDimensions.px34,
            decoration: BoxDecoration(
              color: AppColors.accentSoft,
              borderRadius: BorderRadius.circular(AppDimensions.px9.r),
              border: Border.all(color: AppColors.accent.withOpacity(0.3)),
            ),
            child:  Icon(Icons.auto_stories_rounded,
                color: AppColors.accent, size: AppDimensions.px17.sp),
          ),
           SizedBox(width: AppDimensions.px10.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text( AppStrings.wordSense,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                    fontFamily: 'Georgia',
                    letterSpacing: -0.3,
                  )),
              Text( AppStrings.predictiveTyping,
                  style: TextStyle(
                      fontSize: AppDimensions.px11.sp,
                      color: AppColors.textSecondary,
                      letterSpacing: 0.2)),
            ],
          ),
          const Spacer(),
          ValueListenableBuilder(
            valueListenable: textController,
            builder: (_, value, __) => AnimatedOpacity(
              opacity: value.text.isNotEmpty ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 200),
              child: HeaderButton(
                icon: Icons.close_rounded,
                label:  AppStrings.clear,
                onTap: _clearText,
              ),
            ),
          ),
           SizedBox(width: AppDimensions.px8.w),
          HeaderButton(
            icon: Icons.check_rounded,
            label: AppStrings.learn,
            onTap: _submitWord,
            isPrimary: true,
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow() {
    return Obx(() {
      final count = controller.suggestions.length;
      return Row(
        children: [
          StatPill(
            icon: Icons.lightbulb_outline_rounded,
            label: '$count ${AppStrings.suggestion}${count == 1 ? '' : 's'}',
            active: count > 0,
          ),
          const SizedBox(width: AppDimensions.px8),
          StatPill(
            icon: Icons.history_edu_rounded,
            label: '$_sessionWordCount ${AppStrings.word}${_sessionWordCount == 1 ? '' : 's'} typed',
            active: _sessionWordCount > 0,
          ),
        ],
      );
    });
  }

  Widget _buildTextField() {
    return Obx(() => InlineSuggestionField(
      controller: textController,
      suggestion: controller.inlineSuggestion.value,
      // No-op: the addListener handles all text changes.
      // Passing a callback here would create a second firing path.
      onChanged: (_) {},
    ));
  }

  Widget _buildActionRow() {
    return Obx(() {
      if (controller.suggestions.isEmpty) return const SizedBox.shrink();
      return Row(
        children: [
          Icon(Icons.keyboard_tab_rounded,
              size: AppDimensions.px14.r, color: AppColors.textSecondary),
           SizedBox(width: AppDimensions.px5.w),
          Text( AppStrings.tapASuggestions,
              style: TextStyle(fontSize: AppDimensions.px12.sp, color: AppColors.textSecondary)),
        ],
      );
    });
  }

  Widget _buildTipsCard() {
    return Container(
      padding: EdgeInsets.all(AppDimensions.px14.r),
      decoration: BoxDecoration(
        color: AppColors.accentSoft,
        borderRadius: BorderRadius.circular(AppDimensions.px14.r),
        border: Border.all(color: AppColors.accent.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
               Icon(Icons.tips_and_updates_outlined,
                  size: AppDimensions.px14.r, color: AppColors.accentDeep),
               SizedBox(width: AppDimensions.px6.w),
              Text( AppStrings.howItWorks,
                  style: TextStyle(
                    fontSize: AppDimensions.px12.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.accentDeep,
                    letterSpacing: 0.3,
                  )),
            ],
          ),
          const SizedBox(height: AppDimensions.px8),
          ..._tips.map((tip) => Padding(
            padding:  EdgeInsets.only(bottom: AppDimensions.px5.w),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: AppDimensions.px4.w,
                  height: AppDimensions.px4.h,
                  margin:  EdgeInsets.only(top: AppDimensions.px6.h, right: AppDimensions.px8.w),
                  decoration: const BoxDecoration(
                      color: AppColors.accent, shape: BoxShape.circle),
                ),
                Expanded(
                  child: Text(tip,
                      style: TextStyle(
                          fontSize: AppDimensions.px12.sp,
                          color: AppColors.accentDeep,
                          height: 1.5)),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }

  static const _tips = [
    AppStrings.tipOne,
    AppStrings.tipTwo,
    AppStrings.tipThree,
    AppStrings.tipFour,
  ];

  Widget _buildSuggestionBar() {
    return Obx(() => KeyboardSuggestionBar(
      suggestions: controller.suggestions.map((e) => e.word).toList(),
      onTap: _applySuggestion,
    ));
  }
}


