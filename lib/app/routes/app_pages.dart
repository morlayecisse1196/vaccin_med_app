import 'package:get/get.dart';

import '../modules/auth/auth_binding.dart';
import '../modules/auth/login_page.dart';
import '../modules/auth/signup_page.dart';
import '../modules/calendar/calendar_binding.dart';
import '../modules/calendar/calendar_page.dart';
import '../modules/chat/chat_binding.dart';
import '../modules/chat/chat_page.dart';
import '../modules/home/home_binding.dart';
import '../modules/home/home_page.dart';
import '../modules/journal/journal_binding.dart';
import '../modules/journal/journal_page.dart';
import '../modules/main/main_binding.dart';
import '../modules/main/main_page.dart';
import '../modules/map/map_binding.dart';
import '../modules/map/map_page.dart';
import '../modules/onboarding/onboarding_binding.dart';
import '../modules/onboarding/onboarding_page.dart';
import '../modules/splash/splash_binding.dart';
import '../modules/splash/splash_page.dart';
import '../modules/vaccination_book/vaccination_book_binding.dart';
import '../modules/vaccination_book/vaccination_book_page.dart';
import 'app_routes.dart';

/// VACCI-MED Page Routes Configuration
class AppPages {
  AppPages._();

  static const initial = AppRoutes.splash;

  static final routes = [
    // === Splash ===
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashPage(),
      binding: SplashBinding(),
      transition: Transition.fade,
      transitionDuration: const Duration(milliseconds: 300),
    ),

    // === Onboarding ===
    GetPage(
      name: AppRoutes.onboarding,
      page: () => const OnboardingPage(),
      binding: OnboardingBinding(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 400),
    ),

    // === Auth ===
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginPage(),
      binding: AuthBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 280),
    ),

    GetPage(
      name: AppRoutes.signup,
      page: () => const SignupPage(),
      binding: AuthBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 280),
    ),

    // === Main (avec BottomNavigationBar) ===
    GetPage(
      name: AppRoutes.main,
      page: () => const MainPage(),
      bindings: [
        MainBinding(),
        HomeBinding(),
        CalendarBinding(),
        JournalBinding(),
        ChatBinding(),
        MapBinding(),
      ],
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
    ),

    // === Home ===
    GetPage(
      name: AppRoutes.home,
      page: () => const HomePage(),
      binding: HomeBinding(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
    ),

    // === Calendar ===
    GetPage(
      name: AppRoutes.calendar,
      page: () => const CalendarPage(),
      binding: CalendarBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 280),
    ),

    // === Journal ===
    GetPage(
      name: AppRoutes.journal,
      page: () => const JournalPage(),
      binding: JournalBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 280),
    ),

    // === Chat ===
    GetPage(
      name: AppRoutes.chat,
      page: () => const ChatPage(),
      binding: ChatBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 280),
    ),

    // === Map ===
    GetPage(
      name: AppRoutes.map,
      page: () => const MapPage(),
      binding: MapBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 280),
    ),

    // === Vaccination Book ===
    GetPage(
      name: AppRoutes.vaccinationBook,
      page: () => const VaccinationBookPage(),
      binding: VaccinationBookBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
    ),
  ];
}
