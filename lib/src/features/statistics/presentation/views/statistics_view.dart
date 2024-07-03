import 'package:fitness_tracker_app/src/features/statistics/presentation/views/logs.dart';
import 'package:fitness_tracker_app/src/features/statistics/presentation/views/progress_report.dart';
import 'package:fitness_tracker_app/src/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_fonts/google_fonts.dart';

class StatisticsView extends HookWidget {
  const StatisticsView({super.key});

  @override
  Widget build(BuildContext context) {
    final pageController = usePageController();
    final isFirstPage = useState<bool>(true);

    return Scaffold(
      backgroundColor: appColors.lightGrey,
      body: Column(
        children: [
          _buildAppBar(
            isFirstPage: isFirstPage.value,
            onTapBack: () {
              if (!isFirstPage.value) {
                pageController.previousPage(
                  duration: const Duration(milliseconds: 600),
                  curve: Curves.linear,
                );
              }
            },
            onTapForward: () {
              if (isFirstPage.value) {
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
              },
              children: const [
                ProgressReport(),
                Logs(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar({
    required bool isFirstPage,
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
                  isFirstPage ? 'Progress report' : '   Log   ',
                  style: GoogleFonts.inter(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                GestureDetector(
                  onTap: onTapForward,
                  child: SvgAsset(
                    assetName: arrowRight,
                    color: isFirstPage ? null : appColors.lightGrey,
                  ),
                ),
                SvgAsset(assetName: calendarIcon),
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
