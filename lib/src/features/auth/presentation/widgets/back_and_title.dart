import 'package:fitness_tracker_app/src/features/navigation/nav.dart';
import 'package:fitness_tracker_app/src/shared/shared.dart';
import 'package:flutter/material.dart';

Widget backAndTitle({required String title}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      AppInkWell(
        onTap: () {
          AppNavigator.popRoute();
        },
        child: Icon(
          Icons.arrow_back_ios_new,
          size: 22.dy,
          color: appColors.white,
        ),
      ),
      const Spacer(flex: 4),
      Text(
        title,
        style: TextStyle(
          color: appColors.white,
          fontSize: 20.sp,
          fontWeight: FontWeight.w800,
        ),
      ),
      const Spacer(flex: 6),
    ],
  );
}
