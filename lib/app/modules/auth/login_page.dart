import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../routes/app_routes.dart';
import 'auth_controller.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late final AuthController controller;
  bool _isPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    controller = Get.find<AuthController>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.offWhite,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isSmallScreen = constraints.maxHeight < 650;
            final animationSize = isSmallScreen ? 120.0 : 160.0;

            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: isSmallScreen ? 12 : 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: isSmallScreen ? 10 : 20),

                  // Lottie Animation - Responsive
                  FadeInDown(
                    child: Center(
                      child: Lottie.asset(
                        'assets/animations/login.json',
                        width: animationSize,
                        height: animationSize,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),

                  SizedBox(height: isSmallScreen ? 16 : 24),

                  // Header
                  FadeInDown(
                    duration: const Duration(milliseconds: 600),
                    delay: const Duration(milliseconds: 200),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Bienvenue ! 👋',
                          style: AppTextStyles.display.copyWith(
                            fontSize: isSmallScreen ? 24 : 30,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                        SizedBox(height: isSmallScreen ? 4 : 8),
                        Text(
                          'Connectez-vous à votre compte',
                          style: AppTextStyles.body.copyWith(
                            color: AppColors.textGray,
                            fontSize: isSmallScreen ? 13 : 15,
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: isSmallScreen ? 24 : 32),

                  // Email Field
                  FadeInUp(
                    duration: const Duration(milliseconds: 600),
                    delay: const Duration(milliseconds: 250),
                    child: TextField(
                      controller: controller.loginEmailController,
                      keyboardType: TextInputType.emailAddress,
                      style: TextStyle(fontSize: isSmallScreen ? 13 : 15),
                      decoration: InputDecoration(
                        labelText: 'Email ou Téléphone',
                        labelStyle: TextStyle(fontSize: isSmallScreen ? 12 : 13),
                        prefixIcon: Icon(Icons.email_outlined, size: isSmallScreen ? 18 : 22),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: isSmallScreen ? 12 : 16,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: isSmallScreen ? 14 : 18),

                  // Password Field - Utilise setState
                  FadeInUp(
                    duration: const Duration(milliseconds: 600),
                    delay: const Duration(milliseconds: 300),
                    child: TextField(
                      controller: controller.loginPasswordController,
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
                          vertical: isSmallScreen ? 12 : 16,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: isSmallScreen ? 8 : 12),

                  // Forgot Password
                  FadeInUp(
                    duration: const Duration(milliseconds: 600),
                    delay: const Duration(milliseconds: 350),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          // TODO: Forgot password
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text(
                          'Mot de passe oublié ?',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                            fontSize: isSmallScreen ? 12 : 13,
                          ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: isSmallScreen ? 20 : 28),

                  // Login Button
                  FadeInUp(
                    duration: const Duration(milliseconds: 600),
                    delay: const Duration(milliseconds: 400),
                    child: SizedBox(
                      height: isSmallScreen ? 46 : 54,
                      child: ElevatedButton(
                        onPressed: () => controller.login(),
                        child: Text(
                          'Se connecter',
                          style: AppTextStyles.button.copyWith(fontSize: isSmallScreen ? 14 : 16),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: isSmallScreen ? 16 : 24),

                  // Divider
                  FadeInUp(
                    duration: const Duration(milliseconds: 600),
                    delay: const Duration(milliseconds: 450),
                    child: Row(
                      children: [
                        const Expanded(child: Divider(color: AppColors.lightGray)),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            'OU',
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.textGray,
                              fontSize: isSmallScreen ? 11 : 12,
                            ),
                          ),
                        ),
                        const Expanded(child: Divider(color: AppColors.lightGray)),
                      ],
                    ),
                  ),

                  SizedBox(height: isSmallScreen ? 16 : 24),

                  // Social Buttons
                  FadeInUp(
                    duration: const Duration(milliseconds: 600),
                    delay: const Duration(milliseconds: 500),
                    child: Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {},
                            style: OutlinedButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: isSmallScreen ? 10 : 14),
                              side: const BorderSide(color: AppColors.lightGray),
                            ),
                            icon: Icon(
                              Icons.g_mobiledata,
                              size: isSmallScreen ? 22 : 28,
                              color: AppColors.primary,
                            ),
                            label: Text(
                              'Google',
                              style: TextStyle(
                                color: AppColors.textGray,
                                fontSize: isSmallScreen ? 12 : 13,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {},
                            style: OutlinedButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: isSmallScreen ? 10 : 14),
                              side: const BorderSide(color: AppColors.lightGray),
                            ),
                            icon: Icon(
                              Icons.facebook,
                              size: isSmallScreen ? 20 : 24,
                              color: AppColors.primary,
                            ),
                            label: Text(
                              'Facebook',
                              style: TextStyle(
                                color: AppColors.textGray,
                                fontSize: isSmallScreen ? 12 : 13,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: isSmallScreen ? 20 : 28),

                  // Signup Link
                  FadeInUp(
                    duration: const Duration(milliseconds: 600),
                    delay: const Duration(milliseconds: 550),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Pas de compte ? ',
                            style: AppTextStyles.body.copyWith(fontSize: isSmallScreen ? 12 : 13),
                          ),
                          TextButton(
                            onPressed: () => Get.toNamed(AppRoutes.signup),
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: Text(
                              'Créer un compte',
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

                  SizedBox(height: isSmallScreen ? 12 : 20),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
