import 'package:fitness_tracker_app/src/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// base theme
final baseTheme = ThemeData.light();

// app theme
final ThemeData appTheme = baseTheme.copyWith(
  scaffoldBackgroundColor: appColors.scaffoldColor,
  primaryColor: appColors.yellow,
  dividerColor: appColors.yellow.withOpacity(.5),
  brightness: Brightness.light,
  inputDecorationTheme: baseTheme.inputDecorationTheme.copyWith(
    contentPadding: EdgeInsets.zero,
    floatingLabelBehavior: FloatingLabelBehavior.auto,
    labelStyle: TextStyle(
      color: appColors.white,
      fontSize: 18.sp,
      fontWeight: FontWeight.w800,
    ),
    filled: true,
    fillColor: appColors.grey.withOpacity(0.3),
    errorStyle:
        TextStyle(height: 0, fontWeight: FontWeight.normal, fontSize: 15.sp),
    hintStyle: TextStyle(
        color: appColors.inputFieldTextColor,
        fontSize: 16.sp,
        fontWeight: FontWeight.w400),
  ),
  textTheme: baseTheme.textTheme
      .copyWith(
        headlineMedium: GoogleFonts.inter(
          fontSize: 25.sp,
          fontWeight: FontWeight.w700,
        ),
        bodyMedium: GoogleFonts.inter(
          fontWeight: FontWeight.w600,
          fontSize: 16.sp,
          color: appColors.black,
        ),
      )
      .apply(
        bodyColor: appColors.black,
      ),
  colorScheme: baseTheme.colorScheme
      .copyWith(
        primary: appColors.yellow,
        secondary: appColors.green,
        error: appColors.error,
        onError: appColors.error.withOpacity(0.42),
        background: appColors.white,
      )
      .copyWith(background: appColors.scaffoldColor),
);

var appColors = AppColors();

class AppColors {
  Color yellow = const Color(0xFFFCC21B);
  Color green = const Color(0xFF0D6464);
  Color grey = const Color(0xff606060);
  Color grey33 = const Color(0xff333333);
  Color backGroundColor = const Color(0xffE5E5E5);
  Color inputFieldBorderColor = const Color(0xFF898989);
  Color inputFieldTextColor = const Color(0xFF898989);
  Color black = const Color(0xFF1B2124);
  Color white = const Color(0xFFFFFFFF);
  Color scaffoldColor = const Color(0xFFFCFCFC);
  Color error = const Color(0xFFC11717);
  Color success = const Color(0xFF09A160);
  Color grey80 = const Color(0xFF808080);
  Color lightGrey = Colors.grey.shade300;
}
