import 'package:fitness_tracker_app/src/shared/shared.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';

class SparkleContainer extends StatelessWidget {
  final double? height, width;
  final Decoration? decoration;
  final EdgeInsetsGeometry? padding, margin;
  final BoxFit fit;
  final bool isBgWhite;
  final Widget? child;
  const SparkleContainer({
    super.key,
    this.height,
    this.width,
    this.decoration,
    this.padding,
    this.margin,
    this.fit = BoxFit.fitWidth,
    this.isBgWhite = false,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width ?? double.infinity,
      decoration: decoration,
      margin: margin,
      child: Stack(
        children: [
          SizedBox(
            height: height,
            width: width ?? double.infinity,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 6.dy),
              child: SvgPicture.asset(
                sparkleEffect,
                fit: fit,
                colorFilter: isBgWhite
                    ? ColorFilter.mode(
                        appColors.grey,
                        BlendMode.srcIn,
                      )
                    : null,
              ),
            ),
          ),
          Padding(
            padding: padding ?? const EdgeInsets.all(0),
            child: child ?? const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
