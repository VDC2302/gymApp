import 'package:fitness_tracker_app/src/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppDialog {
  static void dialog(Widget content) {
    Get.dialog(
      Dialog(
        insetPadding: EdgeInsets.symmetric(horizontal: 20.dx),
        backgroundColor: appColors.white,
        shadowColor: appColors.white,
        child: content,
      ),
      barrierDismissible: false,
    );
  }
}
