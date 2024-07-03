import 'package:fitness_tracker_app/src/features/navigation/nav.dart';
import 'package:fitness_tracker_app/src/features/navigation/routes.dart';
import 'package:fitness_tracker_app/src/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    Future.delayed(const Duration(seconds: 3), () {
      AppNavigator.replaceNamed(AuthRoutes.loginOrSignUp);
    });
  }

  // @override
  // void dispose() {
  //   SystemChrome.setEnabledSystemUIMode(
  //     SystemUiMode.manual,
  //     overlays: SystemUiOverlay.values,
  //   );
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appColors.black,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.fitHeight,
            image: AssetImage(splashImage),
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Wemove!',
                style: TextStyle(
                  color: appColors.white,
                  fontSize: 32.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                'Fitness',
                style: TextStyle(
                  color: appColors.white,
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SvgPicture.asset(shoeIcon),
              YBox(160.dy),
            ],
          ),
        ),
      ),
    );
  }
}
