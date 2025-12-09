import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import 'splash_controller.dart';

class SplashPage extends GetView<SplashController> {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Lottie Animation
              FadeInDown(
                duration: const Duration(milliseconds: 1000),
                child: Lottie.asset(
                  'assets/animations/medicine.json',
                  width: 250,
                  height: 250,
                  fit: BoxFit.contain,
                ),
              ),

              const SizedBox(height: 32),

              // Brand Name
              FadeInUp(
                delay: const Duration(milliseconds: 400),
                child: Text(
                  'VACCI-MED',
                  style: AppTextStyles.display.copyWith(
                    color: AppColors.white,
                    fontSize: 42,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Tagline
              FadeInUp(
                delay: const Duration(milliseconds: 600),
                child: Text(
                  'Votre compagne de grossesse sécurisée',
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.white.withAlpha(230),
                    fontSize: 16,
                    letterSpacing: 0.5,
                  ),
                ),
              ),

              const SizedBox(height: 60),

              // Loading Indicator with Lottie
              FadeIn(
                duration: const Duration(milliseconds: 800),
                delay: const Duration(milliseconds: 1000),
                child: Lottie.asset(
                  'assets/animations/loading.json',
                  width: 80,
                  height: 80,
                  fit: BoxFit.contain,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
