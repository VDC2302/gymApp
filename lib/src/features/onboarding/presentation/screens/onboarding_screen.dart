import 'package:fitness_tracker_app/src/features/navigation/app_navigator.dart';
import 'package:fitness_tracker_app/src/features/navigation/routes.dart';
import 'package:fitness_tracker_app/src/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'views/views.dart';

class OnboardingScreen extends HookWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                          count: 7,
                          effect: JumpingDotEffect(
                            dotHeight: 3,
                            dotWidth: 38.dx,
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
                    ThirdView(
                      currentPage: currentPage.value,
                      pageController: pageController,
                    ),
                    FourthView(
                      currentPage: currentPage.value,
                      pageController: pageController,
                    ),
                    FifthView(
                      currentPage: currentPage.value,
                      pageController: pageController,
                    ),
                    SixthView(
                      currentPage: currentPage.value,
                      pageController: pageController,
                    ),
                    SeventhView(
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
                  onTap: () {
                    if (currentPage.value == 6) {
                      AppNavigator.pushNamed(HomeRoutes.main);
                    } else {
                      pageController.nextPage(
                          duration: const Duration(milliseconds: 600),
                          curve: Curves.linear);
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
