import 'package:get/get.dart';

import '../pages/call/bindings/call_binding.dart';
import '../pages/call/views/call_page.dart';
import '../pages/details/bindings/details.binding.dart';
import '../pages/details/views/details_page.dart';
import '../pages/home/bindings/home_binding.dart';
import '../pages/home/views/home_page.dart';
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
    GetPage(
      name: Routes.HOME,
      page: HomeView.new,
      binding: HomeBinding(),
    ),
    GetPage(
      name: Routes.DETAILS,
      page: DetailsView.new,
      binding: DetailsBinding(),
    ),
    GetPage(
      name: Routes.CALL,
      page: CallView.new,
      binding: CallBinding(),
    ),
  ];
}
