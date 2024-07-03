import 'package:fitness_tracker_app/src/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppSnackBar {
  static void showSnackbar({
    required String message,
    Widget? icon,
    String? title,
    Color? textColor,
    Color? bgColor,
    Color? leftBarColor,
    Duration? duration,
  }) {
    Get.showSnackbar(
      GetSnackBar(
        snackPosition: SnackPosition.TOP,
        icon: icon ??
            Icon(
              Icons.warning,
              color: textColor ?? const Color(0xffEB0000),
            ),
        leftBarIndicatorColor: leftBarColor ?? appColors.yellow,
        titleText: Text(
          title ?? 'Error',
          style: TextStyle(
            color: textColor ?? const Color(0xffEB0000),
            fontSize: 18.sp,
          ),
        ),
        messageText: Text(
          message,
          style: TextStyle(
            color: textColor ?? const Color(0xffEB0000),
            fontWeight: FontWeight.w400,
            fontSize: 18.sp,
          ),
        ),
        isDismissible: true,
        shouldIconPulse: false,
        duration: duration ?? const Duration(seconds: 3),
        dismissDirection: DismissDirection.horizontal,
        maxWidth: Dims.deviceSize.width * 0.9,
        backgroundColor: bgColor ?? const Color(0xFFFEF2F2),
      ),
    );
  }

  static showTips(String message) {
    Get.snackbar(
      "Tips",
      message,
      duration: const Duration(seconds: 4),
      dismissDirection: DismissDirection.horizontal,
    );
  }
}
