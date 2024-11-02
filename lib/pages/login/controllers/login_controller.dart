import 'package:get/get.dart';
import 'package:reactive_forms/reactive_forms.dart';

class LoginController extends GetxController {
  var rememberMe = true.obs;
  final isPasswordObscure = true.obs;
  final storedEmail = ''.obs;

  final formGroup = FormGroup({
    'username': FormControl<String>(validators: []),
    'password': FormControl<String>(validators: []),
  });

  void login(context) {
    //Get.offAndToNamed(Routes.ARTIFACTS);
  }

  void changeRememberMe() {
    rememberMe.value = !rememberMe.value;
  }
}