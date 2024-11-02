import 'package:get/get.dart';

import '../pages/login/bindings/login_binding.dart';
import '../pages/login/views/login_page.dart';
import '../pages/splash/bindings/bindings.dart';
import '../pages/splash/views/splash_page.dart';
import 'app_routes.dart';

class AppPages {
  static const initial = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: Routes.SPLASH,
      page: SplashView.new,
      binding: SplashBinding(),
    ),
    GetPage(
      name: Routes.LOGIN,
      page: LoginView.new,
      binding: LoginBinding(),
    ),
  ];
}
