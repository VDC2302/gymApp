import 'package:fitness_tracker_app/src/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class MyWorkout extends StatelessWidget {
  const MyWorkout({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.dx),
        child: Column(
          children: [
            _buildText('Custom workouts'),
            SparkleContainer(
              height: 148.dy,
              decoration: BoxDecoration(
                color: appColors.black,
                borderRadius: BorderRadius.circular(10),
              ),
              child: workoutContContent(isBurst: true),
            ),
            _buildText(
              'Today\'s workouts',
              padding:
                  EdgeInsets.symmetric(vertical: 30.dy).copyWith(left: 6.dx),
            ),
            SparkleContainer(
              height: 148.dy,
              isBgWhite: true,
              decoration: BoxDecoration(
                color: appColors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: workoutContContent(
                isBgWhite: true,
                topText: 'DAWN\n',
                bottomText: 'EXCERCISES',
              ),
            ),
            YBox(15.dy),
            SparkleContainer(
              height: 148.dy,
              decoration: BoxDecoration(
                color: appColors.green,
                borderRadius: BorderRadius.circular(10),
              ),
              child: workoutContContent(
                topText: 'NOON\n',
                bottomText: 'EXCERCISES',
              ),
            ),
            YBox(15.dy),
            SparkleContainer(
              height: 148.dy,
              decoration: BoxDecoration(
                color: appColors.black,
                borderRadius: BorderRadius.circular(10),
              ),
              child: workoutContContent(
                topText: 'DUSK\n',
                bottomText: 'EXCERCISES',
              ),
            ),
            YBox(30.dy),
          ],
        ),
      ),
    );
  }

  Widget _buildText(String text, {EdgeInsetsGeometry? padding}) {
    return Padding(
      padding: padding ?? EdgeInsets.only(left: 6.dx, bottom: 12.dy),
      child: AppText(
        isStartAligned: true,
        text: text,
        fontSize: 14.sp,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}

Widget workoutContContent(
    {bool isBurst = false,
    bool isBgWhite = false,
    String? topText,
    String? bottomText}) {
  return Padding(
    padding: EdgeInsets.all(10.dx).copyWith(bottom: 30.dy),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text.rich(
              TextSpan(
                text: topText ?? 'QUICK\n',
                style: GoogleFonts.inter(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w600,
                  color: !isBgWhite ? appColors.white : null,
                ),
                children: [
                  TextSpan(
                    text: bottomText ?? 'BURST',
                    style: GoogleFonts.inter(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                      color: !isBgWhite ? appColors.white : null,
                    ),
                  ),
                ],
              ),
            ),
            AppText(
              text:
                  'Create milestones\nEarn collectibles as you \ntrain your body',
              fontSize: 10.sp,
              fontWeight: FontWeight.w500,
              color: !isBgWhite ? const Color(0xffD9D9D9) : null,
            ),
          ],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                SvgAsset(
                  assetName: trophyIcon,
                  height: 13.5.dy,
                ),
                AppText(
                  text: ' Collectables',
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                  color: !isBgWhite ? appColors.white : null,
                )
              ],
            ),
            SvgPicture.asset(isBurst ? quickBurst : excersiceSet),
          ],
        ),
      ],
    ),
  );
}
