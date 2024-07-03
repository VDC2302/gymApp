import 'package:fitness_tracker_app/src/shared/shared.dart';
import 'package:flutter/material.dart';

class DateWidget extends StatelessWidget {
  final String day, dayNumber;
  final bool selected;
  const DateWidget({
    super.key,
    required this.day,
    required this.dayNumber,
    required this.selected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 61.97.dy,
      width: 48.68.dx,
      margin: EdgeInsets.only(right: 8.dx),
      decoration: BoxDecoration(
        color: selected ? appColors.yellow : null,
        borderRadius: BorderRadius.circular(15.dy),
        border: Border.all(
          color: appColors.grey80.withOpacity(0.3),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            dayNumber,
            style: TextStyle(
              color: selected ? appColors.white : appColors.black,
              fontWeight: FontWeight.w600,
              fontSize: 18.39.sp,
            ),
          ),
          Text(
            day,
            style: TextStyle(
              color: selected ? appColors.white : appColors.grey80,
              fontWeight: FontWeight.w500,
              fontSize: 17.39.sp,
            ),
          ),
        ],
      ),
    );
  }
}
