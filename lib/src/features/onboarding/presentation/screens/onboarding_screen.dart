import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_connect/http/src/exceptions/exceptions.dart';
import 'package:gymApp/src/features/navigation/routes.dart';
import 'package:gymApp/src/shared/shared.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:gymApp/src/shared/api/api_service.dart';

import '../view_models/onboarding_viewmodel.dart';
import 'views/views.dart';

class OnboardingScreen extends HookConsumerWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final currentPage = useState<int>(0);
    final pageController = usePageController(initialPage: currentPage.value);

    return Scaffold(
      backgroundColor: appColors.lightGrey,
      body: Stack(
        children: [
          Container(
            color: appColors.white,
            height: 100.dy,
          ),
          AppColumn(
            height: Dims.deviceSize.height,
            padding: EdgeInsets.only(top: 55.dy),
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.dx),
                child: SizedBox(
                  width: double.infinity,
                  child: Row(
                    children: [
                      Expanded(
                        child: SmoothPageIndicator(
                          controller: pageController,
                          count: 2,
                          effect: JumpingDotEffect(
                            dotHeight: 3,
                            dotWidth: 150.dx,
                            activeDotColor: theme.colorScheme.primary,
                            dotColor: theme.colorScheme.secondary,
                          ),
                        ),
                      ),
                      SvgPicture.asset(trophyIcon),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: PageView(
                  controller: pageController,
                  allowImplicitScrolling: false,
                  onPageChanged: (int index) {
                    currentPage.value = index;
                  },
                  children: [
                    FirstView(
                      currentPage: currentPage.value,
                      pageController: pageController,
                    ),
                    SecondView(
                      currentPage: currentPage.value,
                      pageController: pageController,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.dx)
                    .copyWith(bottom: 35.dy),
                child: AppButton(
                  title: 'Continue',
                  onTap: () async {
                    if (currentPage.value == 1) {

                      final onboardingViewModel = ref.read(onboardingProvider);


                      if (onboardingViewModel.userHeight.isEmpty || onboardingViewModel.userWeight.isEmpty) {

                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Incomplete Information'),
                            content: const Text('Please enter both your height and weight to proceed.'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: const Text('OK'),
                              ),
                            ],
                          ),
                        );
                      } else {

                        ApiService apiService = ApiService();

                        try {
                          await apiService.postUserTarget(
                            height: double.tryParse(onboardingViewModel.userHeight) ?? 0.0,
                            weight: double.tryParse(onboardingViewModel.userWeight) ?? 0.0,
                            activityFrequency: onboardingViewModel.activityFrequency,
                          );

                          Navigator.pushNamedAndRemoveUntil(context, HomeRoutes.main, (Route<dynamic> route) => false);
                        } catch (e) {
                          if (e is UnauthorizedException) {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Access Denied'),
                                content: const Text('You are not authorized to proceed. Please check your inputs.'),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.of(context).pop(),
                                    child: const Text('OK'),
                                  ),
                                ],
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Please check your information again.')),
                            );
                          }
                        }
                      }
                    } else {
                      pageController.nextPage(
                        duration: const Duration(milliseconds: 600),
                        curve: Curves.linear,
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}