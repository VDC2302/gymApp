import 'package:fitness_tracker_app/src/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OtherLoginOptionsWidget extends StatelessWidget {
  const OtherLoginOptionsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return AppColumn(
      height: 94.dy,
      width: 133.dx,
      children: [
        Padding(
          padding: EdgeInsets.all(10.dx),
          child: Text(
            'Or',
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w600,
              color: appColors.white,
            ),
          ),
        ),
        YBox(20.dy),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SvgPicture.asset(appleIcon),
            SvgPicture.asset(googleIcon),
            SvgPicture.asset(facebookIcon),
          ],
        ),
      ],
    );
  }
}
