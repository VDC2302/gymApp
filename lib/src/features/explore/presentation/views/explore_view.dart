import 'package:fitness_tracker_app/src/features/explore/presentation/views/explore_workouts.dart';
import 'package:fitness_tracker_app/src/features/explore/presentation/views/my_workout.dart';
import 'package:fitness_tracker_app/src/features/explore/presentation/views/nutrition.dart';
import 'package:fitness_tracker_app/src/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_fonts/google_fonts.dart';

class ExploreView extends HookWidget {
  const ExploreView({super.key});

  @override
  Widget build(BuildContext context) {
    final pageController = usePageController();
    final isFirstPage = useState<bool>(true);
    final isLastPage = useState<bool>(false);

    return Scaffold(
      backgroundColor: appColors.lightGrey,
      body: Column(
        children: [
          _buildAppBar(
            isFirstPage: isFirstPage.value,
            isLastPage: isLastPage.value,
            onTapBack: () {
              if (!isFirstPage.value) {
                pageController.previousPage(
                  duration: const Duration(milliseconds: 600),
                  curve: Curves.linear,
                );
              }
            },
            onTapForward: () {
              if (isFirstPage.value || !isLastPage.value) {
                pageController.nextPage(
                  duration: const Duration(milliseconds: 600),
                  curve: Curves.linear,
                );
              }
            },
          ),
          YBox(30.dy),
          Expanded(
            child: PageView(
              controller: pageController,
              onPageChanged: (value) {
                isFirstPage.value = (value == 0);
                isLastPage.value = (value == 2);
              },
              children: const [
                ExploreWorkouts(),
                MyWorkout(),
                Nutrition(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar({
    required bool isFirstPage,
    required bool isLastPage,
    required VoidCallback onTapBack,
    required VoidCallback onTapForward,
  }) {
    return Container(
      height: 122.dy,
      width: double.infinity,
      color: appColors.white,
      padding: EdgeInsets.symmetric(horizontal: 20.dx),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            YBox(35.dy),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SvgAsset(assetName: drawerIcon),
                GestureDetector(
                  onTap: onTapBack,
                  child: SvgAsset(
                    assetName: arrowLeft,
                    color: isFirstPage ? appColors.lightGrey : null,
                  ),
                ),
                Text(
                  isFirstPage
                      ? 'Explore Workouts'
                      : isLastPage
                          ? '  Nutrition  '
                          : ' My Workout ',
                  style: GoogleFonts.inter(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                GestureDetector(
                  onTap: onTapForward,
                  child: SvgAsset(
                    assetName: arrowRight,
                    color: isFirstPage
                        ? null
                        : !isLastPage
                            ? null
                            : appColors.lightGrey,
                  ),
                ),
                SvgAsset(assetName: timerIcon),
              ],
            ),
            YBox(5.dy),
            SvgAsset(assetName: selector),
          ],
        ),
      ),
    );
  }
}
