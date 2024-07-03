import 'package:fitness_tracker_app/src/features/explore/presentation/views/my_workout.dart';
import 'package:fitness_tracker_app/src/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ExploreWorkouts extends StatelessWidget {
  const ExploreWorkouts({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.dx),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildLevelWidget('Beginner', isSelected: true),
                _buildLevelWidget('Intermediate', isSelected: false),
                _buildLevelWidget('Advanced', isSelected: false),
              ],
            ),
            YBox(20.dy),
            _buildText('Cardio'),
            SparkleContainer(
              height: 148.dy,
              decoration: BoxDecoration(
                color: appColors.black,
                borderRadius: BorderRadius.circular(10),
              ),
              child: workoutContContent(
                topText: 'CARDIO\n',
                bottomText: 'EXCERCISES',
              ),
            ),
            _buildText('Strength Training'),
            SparkleContainer(
              height: 148.dy,
              isBgWhite: true,
              decoration: BoxDecoration(
                color: appColors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: workoutContContent(
                isBgWhite: true,
                topText: 'STRENGTH\n',
                bottomText: 'TRAINING',
              ),
            ),
            _buildText('HIIT'),
            SparkleContainer(
              height: 148.dy,
              decoration: BoxDecoration(
                color: appColors.green,
                borderRadius: BorderRadius.circular(10),
              ),
              child: workoutContContent(
                topText: 'HIIT\n',
                bottomText: 'EXCERCISES',
              ),
            ),
            YBox(30.dy),
          ],
        ),
      ),
    );
  }

  Widget _buildLevelWidget(String text, {required bool isSelected}) {
    return Container(
      padding: EdgeInsets.all(10.dx),
      decoration: BoxDecoration(
        color: isSelected ? appColors.black : appColors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: GoogleFonts.inter(
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
          color: isSelected ? appColors.white : null,
        ),
      ),
    );
  }

  Widget _buildText(String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20.dy),
      child: AppText(
        isStartAligned: true,
        text: text,
        fontSize: 14.sp,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
