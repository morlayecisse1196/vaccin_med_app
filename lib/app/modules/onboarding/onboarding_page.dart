import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import 'onboarding_controller.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  late final PageController _pageController;
  late final OnboardingController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.find<OnboardingController>();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Skip Button
            Padding(
              padding: const EdgeInsets.all(16),
              child: Align(
                alignment: Alignment.topRight,
                child: TextButton(
                  onPressed: controller.skipOnboarding,
                  child: Text(
                    'Passer',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textGray.withAlpha(153),
                    ),
                  ),
                ),
              ),
            ),

            // PageView
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) => controller.goToPage(index),
                itemCount: controller.items.length,
                itemBuilder: (context, index) {
                  final item = controller.items[index];
                  return _buildOnboardingSlide(item, index);
                },
              ),
            ),

            // Indicators & Button
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  // Page Indicator
                  SmoothPageIndicator(
                    controller: _pageController,
                    count: controller.items.length,
                    effect: const ExpandingDotsEffect(
                      activeDotColor: AppColors.primary,
                      dotColor: AppColors.lightGray,
                      dotHeight: 8,
                      dotWidth: 8,
                      expansionFactor: 4,
                      spacing: 6,
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Next/Get Started Button
                  Obx(() {
                    final isLastPage = controller.currentPage.value == controller.items.length - 1;
                    return FadeInUp(
                      duration: const Duration(milliseconds: 400),
                      child: SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: () {
                            if (isLastPage) {
                              controller.completeOnboarding();
                            } else {
                              _pageController.nextPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          ),
                          child: Text(
                            isLastPage ? 'Commencer' : 'Suivant',
                            style: AppTextStyles.button,
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOnboardingSlide(OnboardingItem item, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon/Illustration
          FadeInDown(
            duration: const Duration(milliseconds: 600),
            delay: Duration(milliseconds: 100 * index),
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: AppColors.offWhite,
                borderRadius: BorderRadius.circular(100),
              ),
              child: Center(child: Text(item.icon, style: const TextStyle(fontSize: 100))),
            ),
          ),

          const SizedBox(height: 48),

          // Title
          FadeInUp(
            duration: const Duration(milliseconds: 600),
            delay: Duration(milliseconds: 200 + 100 * index),
            child: Text(
              item.title,
              textAlign: TextAlign.center,
              style: AppTextStyles.h1.copyWith(fontSize: 26, fontWeight: FontWeight.bold),
            ),
          ),

          const SizedBox(height: 16),

          // Description
          FadeInUp(
            duration: const Duration(milliseconds: 600),
            delay: Duration(milliseconds: 400 + 100 * index),
            child: Text(
              item.description,
              textAlign: TextAlign.center,
              style: AppTextStyles.body.copyWith(
                fontSize: 16,
                color: AppColors.textGray.withAlpha(179),
                height: 1.6,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
