import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:voices_of_turkey/routes/app_pages.dart';

void main() {
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
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          title: 'appName'.tr,
          enableLog: true,
          initialRoute: AppPages.initial,
          getPages: AppPages.routes,
        );
      },
    );
  }
}
