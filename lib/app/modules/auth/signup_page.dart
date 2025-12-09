import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import 'auth_controller.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  late final AuthController controller;
  bool _isPasswordVisible = false;
  final List<String> _languages = ['Français', 'English', 'Wolof', 'Pulaar'];

  @override
  void initState() {
    super.initState();
    controller = Get.find<AuthController>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.offWhite,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isSmallScreen = constraints.maxHeight < 650;
            final animationSize = isSmallScreen ? 100.0 : 130.0;

            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: isSmallScreen ? 8 : 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Lottie Animation - Responsive
                  FadeInDown(
                    duration: const Duration(milliseconds: 600),
                    child: Center(
                      child: Lottie.asset(
                        'assets/animations/register.json',
                        width: animationSize,
                        height: animationSize,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),

                  SizedBox(height: isSmallScreen ? 8 : 16),

                  // Header
                  FadeInDown(
                    duration: const Duration(milliseconds: 600),
                    delay: const Duration(milliseconds: 100),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Créer un compte',
                          style: AppTextStyles.display.copyWith(
                            fontSize: isSmallScreen ? 22 : 26,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                        SizedBox(height: isSmallScreen ? 4 : 6),
                        Text(
                          'Rejoignez VACCI-MED',
                          style: AppTextStyles.body.copyWith(
                            color: AppColors.textGray,
                            fontSize: isSmallScreen ? 13 : 14,
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: isSmallScreen ? 16 : 20),

                  // Nom
                  FadeInUp(
                    duration: const Duration(milliseconds: 500),
                    delay: const Duration(milliseconds: 150),
                    child: _buildTextField(
                      controller: controller.signupNameController,
                      label: 'Nom complet',
                      icon: Icons.person_outline,
                      isSmall: isSmallScreen,
                    ),
                  ),

                  SizedBox(height: isSmallScreen ? 10 : 14),

                  // Téléphone
                  FadeInUp(
                    duration: const Duration(milliseconds: 500),
                    delay: const Duration(milliseconds: 200),
                    child: _buildTextField(
                      controller: controller.signupPhoneController,
                      label: 'Téléphone',
                      icon: Icons.phone_outlined,
                      keyboardType: TextInputType.phone,
                      isSmall: isSmallScreen,
                    ),
                  ),

                  SizedBox(height: isSmallScreen ? 10 : 14),

                  // Email
                  FadeInUp(
                    duration: const Duration(milliseconds: 500),
                    delay: const Duration(milliseconds: 250),
                    child: _buildTextField(
                      controller: controller.signupEmailController,
                      label: 'Email (optionnel)',
                      icon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                      isSmall: isSmallScreen,
                    ),
                  ),

                  SizedBox(height: isSmallScreen ? 10 : 14),

                  // Password - Utilise setState au lieu d'Obx
                  FadeInUp(
                    duration: const Duration(milliseconds: 500),
                    delay: const Duration(milliseconds: 300),
                    child: TextField(
                      controller: controller.signupPasswordController,
                      obscureText: !_isPasswordVisible,
                      style: TextStyle(fontSize: isSmallScreen ? 13 : 15),
                      decoration: InputDecoration(
                        labelText: 'Mot de passe',
                        labelStyle: TextStyle(fontSize: isSmallScreen ? 12 : 13),
                        prefixIcon: Icon(Icons.lock_outline, size: isSmallScreen ? 18 : 22),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            size: isSmallScreen ? 18 : 22,
                          ),
                          onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: isSmallScreen ? 10 : 14,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: isSmallScreen ? 10 : 14),

                  // Date d'accouchement
                  FadeInUp(
                    duration: const Duration(milliseconds: 500),
                    delay: const Duration(milliseconds: 350),
                    child: TextField(
                      controller: controller.signupDueDateController,
                      readOnly: true,
                      onTap: () => controller.selectDueDate(context),
                      style: TextStyle(fontSize: isSmallScreen ? 13 : 15),
                      decoration: InputDecoration(
                        labelText: 'Date d\'accouchement',
                        labelStyle: TextStyle(fontSize: isSmallScreen ? 12 : 13),
                        prefixIcon: Icon(
                          Icons.calendar_today_outlined,
                          size: isSmallScreen ? 18 : 22,
                        ),
                        suffixIcon: Icon(Icons.arrow_drop_down, size: isSmallScreen ? 18 : 22),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: isSmallScreen ? 10 : 14,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: isSmallScreen ? 10 : 14),

                  // Langue - Utilise setState au lieu d'Obx
                  FadeInUp(
                    duration: const Duration(milliseconds: 500),
                    delay: const Duration(milliseconds: 400),
                    child: DropdownButtonFormField<String>(
                      style: TextStyle(
                        fontSize: isSmallScreen ? 13 : 15,
                        color: AppColors.textGray,
                      ),
                      decoration: InputDecoration(
                        labelText: 'Langue',
                        labelStyle: TextStyle(fontSize: isSmallScreen ? 12 : 13),
                        prefixIcon: Icon(Icons.language_outlined, size: isSmallScreen ? 18 : 22),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: isSmallScreen ? 10 : 14,
                        ),
                      ),
                      items: _languages.map((String language) {
                        return DropdownMenuItem<String>(
                          value: language,
                          child: Text(
                            language,
                            style: TextStyle(fontSize: isSmallScreen ? 13 : 15),
                          ),
                        );
                      }).toList(),
                      onChanged: (String? value) {
                        if (value != null) {
                          controller.selectLanguage(value);
                        }
                      },
                    ),
                  ),

                  SizedBox(height: isSmallScreen ? 16 : 24),

                  // Bouton
                  FadeInUp(
                    duration: const Duration(milliseconds: 500),
                    delay: const Duration(milliseconds: 450),
                    child: SizedBox(
                      height: isSmallScreen ? 44 : 52,
                      child: ElevatedButton(
                        onPressed: () => controller.signup(),
                        child: Text(
                          'Créer mon compte',
                          style: AppTextStyles.button.copyWith(fontSize: isSmallScreen ? 14 : 16),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: isSmallScreen ? 10 : 16),

                  // Lien de connexion
                  FadeInUp(
                    duration: const Duration(milliseconds: 500),
                    delay: const Duration(milliseconds: 500),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Déjà un compte ? ',
                            style: AppTextStyles.body.copyWith(fontSize: isSmallScreen ? 12 : 13),
                          ),
                          TextButton(
                            onPressed: () => Get.back(),
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: Text(
                              'Se connecter',
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                                fontSize: isSmallScreen ? 12 : 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: isSmallScreen ? 8 : 12),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    required bool isSmall,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: TextStyle(fontSize: isSmall ? 13 : 15),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(fontSize: isSmall ? 12 : 13),
        prefixIcon: Icon(icon, size: isSmall ? 18 : 22),
        contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: isSmall ? 10 : 14),
      ),
    );
  }
}
