import 'package:fitness_tracker_app/src/shared/shared.dart';
import 'package:flutter/material.dart';

class CustomCheckBox extends StatelessWidget {
  const CustomCheckBox({
    super.key,
    required this.title,
    required this.isSelected,
    this.isCircle = true,
    this.topPadding = false,
    this.onTap,
  });
  final bool isSelected;
  final String title;
  final bool isCircle;
  final bool topPadding;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 15.dx, top: topPadding ? 15.dx : 0),
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 16..dy,
                  width: 16..dy,
                  padding: EdgeInsets.all(1.4..dy),
                  margin: EdgeInsets.only(top: 2..dy),
                  decoration: BoxDecoration(
                      color: appColors.white,
                      shape: BoxShape.rectangle,
                      borderRadius: isCircle
                          ? BorderRadius.circular(12)
                          : BorderRadius.circular(4),
                      border: Border.all(
                        color: isSelected ? appColors.yellow : appColors.grey,
                        width: 0.8,
                      )),
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelected ? appColors.yellow : appColors.white,
                      shape: BoxShape.rectangle,
                      borderRadius: isCircle
                          ? BorderRadius.circular(12)
                          : BorderRadius.circular(2),
                    ),
                  ),
                ),
                XBox(15.55..dx),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: appColors.black,
                        fontWeight: FontWeight.w400,
                        fontSize: 14..sp,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
