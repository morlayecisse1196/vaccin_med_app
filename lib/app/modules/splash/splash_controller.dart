import 'package:get/get.dart';

import '../../routes/app_routes.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    _navigateToNext();
  }

  void _navigateToNext() async {
    // Simulate splash delay
    await Future.delayed(const Duration(seconds: 3));

    // Check if user has seen onboarding
    // TODO: Check SharedPreferences for first launch
    final bool isFirstLaunch = await _checkFirstLaunch();

    if (isFirstLaunch) {
      Get.offAllNamed(AppRoutes.onboarding);
    } else {
      // TODO: Check authentication status
      Get.offAllNamed(AppRoutes.login);
    }
  }

  Future<bool> _checkFirstLaunch() async {
    // TODO: Implement SharedPreferences check
    // For now, always return true to show onboarding
    return true;
  }
}
