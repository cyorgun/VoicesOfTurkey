import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:voices_of_turkey/colors/app_colors.dart';
import 'package:voices_of_turkey/shared/custom_widgets/circular_image.dart';

import '../../../dimens/dimens.dart';
import '../controllers/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    controller.initSplash();
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: AppColors.splashGradient,
        ),
        child: Center(
            child: CircularImage(
          imageAddress: 'assets/images/logo.png',
          height: Dimens.splashLogoSize,
          width: Dimens.splashLogoSize,
        )),
      ),
    );
  }
}
