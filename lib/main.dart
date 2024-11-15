import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:voices_of_turkey/lang/translation_service.dart';
import 'package:voices_of_turkey/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: (theme, darkTheme) {
        return GetMaterialApp(
          key: const Key('GetMaterialApp'),
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
            useMaterial3: true,
          ),
          title: 'appName'.tr,
          enableLog: true,
          translations: Messages(),
          locale: Get.deviceLocale,
          fallbackLocale: const Locale('en', 'US'),
          initialRoute: AppPages.initial,
          getPages: AppPages.routes,
        );
      },
    );
  }
}
