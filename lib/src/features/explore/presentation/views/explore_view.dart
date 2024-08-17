import 'package:flutter/cupertino.dart';
import 'package:gymApp/src/features/explore/presentation/views/explore_workouts.dart';
import 'package:gymApp/src/features/explore/presentation/views/my_workout.dart';
import 'package:gymApp/src/features/explore/presentation/views/nutrition.dart';
import 'package:gymApp/src/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gymApp/src/features/explore/presentation/views/nutrition_form.dart';

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
            context,
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
              children: [
                const ExploreWorkouts(),
                const MyWorkout(),
                Nutrition(
                  key: const PageStorageKey('Nutrition'),
                  onFetchData: () {
                    final state = pageController.page == 2
                        ? const Nutrition(key: PageStorageKey('Nutrition')).createState()
                        : null;
                    state?.fetchData();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(
      BuildContext context,
      {
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
                GestureDetector(
                  onTap: () async {
                    if (isLastPage) {
                      // Show the NutritionForm as a dialog
                      await showDialog(
                        context: context,
                        builder: (context) => Dialog(
                          child: Container(
                            padding: const EdgeInsets.all(16.0),
                            constraints: BoxConstraints(
                              maxWidth: 500, // Adjust the width as needed
                              maxHeight: MediaQuery.of(context).size.height * 0.5, // Adjust the height as needed
                            ),
                            child: const NutritionForm(),
                          ),
                        ),
                      );
                    }
                  },
                  child: isLastPage
                      ? SvgAsset(assetName: addIcon, color: Colors.black)
                      : const Icon(CupertinoIcons.bell),
                ),
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