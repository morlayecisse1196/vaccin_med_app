import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../routes/app_routes.dart';

class AuthController extends GetxController {
  // Login Form
  final loginEmailController = TextEditingController();
  final loginPasswordController = TextEditingController();
  final RxBool isLoginPasswordVisible = false.obs;
  final RxBool isLoginLoading = false.obs;

  // Signup Form
  final signupNameController = TextEditingController();
  final signupPhoneController = TextEditingController();
  final signupEmailController = TextEditingController();
  final signupPasswordController = TextEditingController();
  final signupDueDateController = TextEditingController();
  final RxString selectedLanguage = 'Français'.obs;
  final RxBool isSignupPasswordVisible = false.obs;
  final RxBool isSignupLoading = false.obs;

  final List<String> languages = ['Français', 'English', 'Wolof', 'Pulaar'];

  @override
  void onClose() {
    loginEmailController.dispose();
    loginPasswordController.dispose();
    signupNameController.dispose();
    signupPhoneController.dispose();
    signupEmailController.dispose();
    signupPasswordController.dispose();
    signupDueDateController.dispose();
    super.onClose();
  }

  // === Login ===
  Future<void> login() async {
    if (loginEmailController.text.isEmpty || loginPasswordController.text.isEmpty) {
      Get.snackbar(
        'Erreur',
        'Veuillez remplir tous les champs',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    isLoginLoading.value = true;

    // TODO: Implement API call to Spring Boot backend
    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    isLoginLoading.value = false;

    // Navigate to main page (with bottom nav)
    Get.offAllNamed(AppRoutes.main);

    Get.snackbar(
      'Succès',
      'Connexion réussie !',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  // === Signup ===
  Future<void> signup() async {
    if (signupNameController.text.isEmpty ||
        signupPhoneController.text.isEmpty ||
        signupEmailController.text.isEmpty ||
        signupPasswordController.text.isEmpty) {
      Get.snackbar(
        'Erreur',
        'Veuillez remplir tous les champs',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    isSignupLoading.value = true;

    // TODO: Implement API call to Spring Boot backend
    // POST /api/auth/register
    await Future.delayed(const Duration(seconds: 2));

    isSignupLoading.value = false;

    // Navigate to main page (with bottom nav)
    Get.offAllNamed(AppRoutes.main);

    Get.snackbar(
      'Succès',
      'Compte créé avec succès !',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  void toggleLoginPasswordVisibility() {
    isLoginPasswordVisible.value = !isLoginPasswordVisible.value;
  }

  void toggleSignupPasswordVisibility() {
    isSignupPasswordVisible.value = !isSignupPasswordVisible.value;
  }

  void selectLanguage(String language) {
    selectedLanguage.value = language;
  }

  Future<void> selectDueDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 180)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (picked != null) {
      signupDueDateController.text = '${picked.day}/${picked.month}/${picked.year}';
    }
  }
}
