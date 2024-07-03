import 'package:fitness_tracker_app/src/shared/shared.dart';
import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  final String title;
  final VoidCallback? onTap;
  final Color? buttonColor;
  final Size? buttonSize;
  final bool isLoading;
  final TextStyle? textStyle;
  final BorderRadius? borderRadius;
  const AppButton({
    super.key,
    required this.title,
    required this.onTap,
    this.buttonColor,
    this.buttonSize,
    this.isLoading = false,
    this.borderRadius,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    return BounceInAnimation(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 56.72.dy,
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 10.dy),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            color: buttonColor ?? theme.primary,
            image: DecorationImage(
              image: AssetImage(sparkleEffectSmall),
            ),
          ),
          child: Center(
            child: isLoading
                ? CircularProgressIndicator.adaptive(
                    backgroundColor: appColors.white,
                  )
                : Text(
                    title,
                    style: textStyle ?? Theme.of(context).textTheme.bodyMedium,
                  ),
          ),
        ),
      ),
    );
  }
}

class AppOutlinedButton extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;
  final Color? overlayColor;
  final Color? borderSideColor, textColor;
  final double? height;
  final BorderRadius? borderRadius;
  const AppOutlinedButton({
    super.key,
    required this.text,
    this.onTap,
    this.overlayColor,
    this.borderSideColor,
    this.height,
    this.borderRadius,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    return ClipRRect(
      borderRadius: BorderRadius.circular(25),
      child: SizedBox(
        width: Dims.deviceSize.width,
        height: height ?? 56.72.dy,
        child: OutlinedButton(
          style: ButtonStyle(
            padding: MaterialStatePropertyAll(
                EdgeInsets.symmetric(vertical: 12..dy)),
            overlayColor: MaterialStatePropertyAll(
                overlayColor ?? theme.primary.withOpacity(0.4)),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: borderRadius ??
                    BorderRadius.circular(25), // Adjust the radius as needed
              ),
            ),
            side: MaterialStatePropertyAll(
              BorderSide(
                color: borderSideColor ?? theme.primary,
              ),
            ),
          ),
          onPressed: onTap,
          child: Text(
            text,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w400,
              color: textColor ?? appColors.white,
            ),
          ),
        ),
      ),
    );
  }
}
