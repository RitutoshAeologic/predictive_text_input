import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:predictive_text_input/presentation/screens/prediction_screen.dart';
import 'core/constant/app_strings.dart';
import 'core/services/hive_services.dart';
import 'data/data_source/local_data_sources.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await HiveService.init();
  await LocalDictionary.load();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(430, 932),
      minTextAdapt: true,
      splitScreenMode: true,
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: AppStrings.appName,
        theme: ThemeData(
          useMaterial3: true,
          colorSchemeSeed: Colors.indigo,
        ),
        home: const PredictiveScreen(),
      ),
    );
  }
}