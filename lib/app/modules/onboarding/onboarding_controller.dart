import 'package:get/get.dart';

import '../../routes/app_routes.dart';

class OnboardingController extends GetxController {
  final RxInt currentPage = 0.obs;

  final List<OnboardingItem> items = [
    OnboardingItem(
      title: 'Restez sur la bonne voie',
      description:
          'Ne manquez jamais une consultation prénatale ou postnatale avec nos rappels intelligents',
      icon: '🗓️',
    ),
    OnboardingItem(
      title: 'Connaissez les signes de danger',
      description:
          'Déclarez vos symptômes et recevez des conseils médicaux personnalisés en temps réel',
      icon: '🚨',
    ),
    OnboardingItem(
      title: 'Trouvez le centre le plus proche',
      description:
          'Localisez rapidement les centres de santé autour de vous avec leurs services disponibles',
      icon: '📍',
    ),
  ];

  void skipOnboarding() {
    completeOnboarding();
  }

  void completeOnboarding() {
    // TODO: Save to SharedPreferences that onboarding is completed
    Get.offAllNamed(AppRoutes.login);
  }

  void goToPage(int index) {
    currentPage.value = index;
  }
}

class OnboardingItem {
  final String title;
  final String description;
  final String icon;

  OnboardingItem({required this.title, required this.description, required this.icon});
}
