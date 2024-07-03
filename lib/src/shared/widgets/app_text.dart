import 'package:gymApp/src/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppText extends StatelessWidget {
  final TextStyle? textStyle;
  final double? fontSize;
  final FontWeight? fontWeight;
  final String text;
  final Color? color;
  final bool isDecorated, isStartAligned;
  const AppText({
    super.key,
    required this.text,
    this.textStyle,
    this.fontWeight,
    this.fontSize,
    this.color,
    this.isDecorated = false,
    this.isStartAligned = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
          isStartAligned ? MainAxisAlignment.start : MainAxisAlignment.center,
      children: [
        Text(
          text,
          style: textStyle ??
              GoogleFonts.inter(
                fontSize: fontSize ?? 18.sp,
                fontWeight: fontWeight ?? FontWeight.normal,
                color: color,
                decoration: isDecorated ? TextDecoration.underline : null,
                decorationColor: isDecorated ? appColors.yellow : null,
              ),
        ),
      ],
    );
  }
}

class AppSafeText extends StatelessWidget {
  final TextStyle? textStyle;
  final double? fontSize;
  final FontWeight? fontWeight;
  final String text;
  final Color? color;
  const AppSafeText({
    super.key,
    required this.text,
    this.textStyle,
    this.fontWeight,
    this.fontSize,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: textStyle ??
          TextStyle(
            fontSize: fontSize ?? 18.sp,
            fontWeight: fontWeight ?? FontWeight.normal,
            color: color,
            overflow: TextOverflow.ellipsis,
          ),
    );
  }
}
