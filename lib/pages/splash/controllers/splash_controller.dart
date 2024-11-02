import 'dart:developer';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../routes/app_routes.dart';


class SplashController extends GetxController {
  @override
  Future<void> onInit() async {
    super.onInit();

    await Future.delayed(const Duration(seconds: 2), goInitialPage);
  }

  Future<void> _logOutUser() async {
/*    if ((await GetAuthInfoUseCase()()).isSignedIn) {
      logout();
    }*/
  }

  Future<void> logout() async {
/*    try {
      await Amplify.Auth.signOut();
    } on AuthException catch (e) {
      log(e.message);
    }*/
  }

  void initSplash() {
    log('Splash Appeared');
  }

  void goInitialPage() async {
/*    try {
      final launchedBefore = await _checkLaunchBeforeFromSharedPref();
      if (!launchedBefore) {
        _setLaunchedBefore();
        //_logOutUser();
        Get.offAndToNamed(Routes.ON_BOARDING);
        return;
      }

      final res = await GetAuthInfoUseCase()();
      if (res.isSignedIn) {
        /// Open websocket
        WebSocketManager.instance.openConnection();

        /// Check if there are active sessions and what kind of session it is
        final _activeSession = await GetActiveSessionUseCase()();
        switch (_activeSession.visibilityType) {
          case CPVisibilityType.CORPORATE:
            Get.offAndToNamed(CorporateRoutes.ENTRY_POINT,
                arguments: _activeSession.activeSessionType);
            break;
          case CPVisibilityType.PRIVATE:
            Get.offAndToNamed(PrivateRoutes.ENTRY_POINT,
                arguments: _activeSession.activeSessionType);
            break;
          case CPVisibilityType.EXTERNAL:
          case CPVisibilityType.PUBLIC:
          case CPVisibilityType.ROAMING:
          default:
            Get.offAndToNamed(PublicRoutes.ENTRY_POINT,
                arguments: _activeSession.activeSessionType);
        }
      } else {
        Get.offAndToNamed(Routes.LOGIN);
      }
    } catch (e) {
      log('Previous session is expired or no active session');
      Get.offAndToNamed(Routes.LOGIN);
    }*/
    Get.offAndToNamed(Routes.LOGIN);
  }

  // #region First Launch
  Future<void> _setLaunchedBefore() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(("launchedBefore"), true);
  }

  Future<bool> _checkLaunchBeforeFromSharedPref() async {
    final prefs = await SharedPreferences.getInstance();
    final launchedBefore = prefs.getBool("launchedBefore");

    if (launchedBefore != null) {
      return launchedBefore;
    }
    return false;
  }
// #endregion
}
