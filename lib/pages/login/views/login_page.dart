import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../../../colors/app_colors.dart';
import '../../../dimens/dimens.dart';
import '../../../shared/custom_widgets/blur_container.dart';
import '../../../shared/custom_widgets/circular_image.dart';
import '../../../shared/custom_widgets/curved_header.dart';
import '../../../shared/custom_widgets/forms/reactive_custom_text_field.dart';
import '../../../shared/custom_widgets/gradient_button.dart';
import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final curvedBoxHeight = MediaQuery.of(context).size.height * .34;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.light,
          child: Stack(
            children: [
              CurvedHeader(height: curvedBoxHeight),
              ListView(
                physics: const ClampingScrollPhysics(),
                padding: const EdgeInsets.only(top: kToolbarHeight),
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      left: 16.0,
                      right: 16.0,
                      top: (curvedBoxHeight / 2) -
                          (Dimens.logoHeight / 2) -
                          kToolbarHeight,
                    ),
                    child: CircularImage(
                      imageAddress: 'assets/images/logo.png',
                      width: Dimens.logoSize,
                      height: Dimens.logoSize,
                    ),
                  ),
                  _userInfoBox(context),
                  Align(
                    child: TextButton(
                      onPressed: () {
                        //Get.toNamed(Routes.REGISTRATION);
                      },
                      child: Column(
                        children: [
                          Text(
                            'noMember'.tr,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            'register'.tr,
                            style: TextStyle(
                              fontSize: Dimens.medium2FontSize,
                              color: AppColors.textButtonColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  //_socialNetwork(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _userInfoBox(context) {
    return Stack(
      children: [
        BlurContainer(
          child: ReactiveForm(
            formGroup: controller.formGroup,
            child: Column(
              children: [
                ReactiveCustomTextField<String>(
                  key: const Key('username'),
                  formControlName: 'username',
                  labelText: 'username'.tr,
                  prefixIcon: Icons.account_circle,
                ),
                const SizedBox(height: 20),
                Obx(() {
                  return ReactiveCustomTextField<String>(
                    key: const Key('password'),
                    formControlName: 'password',
                    labelText: 'password'.tr,
                    prefixIcon: Icons.lock,
                    obscureText: controller.isPasswordObscure.value,
                    suffixIcon: IconButton(
                      onPressed: () {
                        controller.isPasswordObscure.value
                            ? controller.isPasswordObscure.value = false
                            : controller.isPasswordObscure.value = true;
                      },
                      icon: controller.isPasswordObscure.value
                          ? Icon(
                              Icons.visibility,
                              color: AppColors.inputIconColor,
                            )
                          : Icon(
                              Icons.visibility_off,
                              color: AppColors.inputIconColor,
                            ),
                    ),
                  );
                }),
                SizedBox(
                  height: 38,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        //Get.to(ForgotPasswordView.new, binding: ForgotPasswordBinding());
                      },
                      child: Text(
                        'forgotPass'.tr,
                        style: TextStyle(
                          fontSize: Dimens.smallFontSize,
                          color: AppColors.textButtonColor,
                        ),
                      ),
                    ),
                  ),
                ),
                Obx(
                  () => TextButton(
                    onPressed: () {
                      controller.changeRememberMe();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          height: 35,
                          width: 35,
                          child: Checkbox(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(7.0)),
                            value: controller.rememberMe.value,
                            onChanged: (value) {
                              controller.changeRememberMe();
                            },
                            checkColor: AppColors.textColor,
                            activeColor: AppColors.textButtonColor,
                          ),
                        ),
                        Text(
                          'rememberMe'.tr,
                          style: TextStyle(
                            fontSize: Dimens.smallFontSize,
                            color: AppColors.textButtonColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          left: 60,
          right: 60,
          bottom: Dimens.buttonHeight / 2,
          child: GradientButton(
            key: const Key('login_button'),
            text: 'login'.tr.toUpperCase(),
            onPressed: () {
              FocusScope.of(context).unfocus();
              controller.login(context);
            },
          ),
        ),
      ],
    );
  }
}
