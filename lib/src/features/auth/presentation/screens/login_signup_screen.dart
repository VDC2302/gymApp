import 'package:gymApp/src/features/auth/presentation/widgets/widgets.dart';
import 'package:gymApp/src/features/navigation/nav.dart';
import 'package:gymApp/src/features/navigation/routes.dart';
import 'package:gymApp/src/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginSignUpScreen extends StatelessWidget {
  const LoginSignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            height: Dims.deviceSize.height,
            width: Dims.deviceSize.width,
            splashImage,
            fit: BoxFit.fitHeight,
          ),

          AppColumn(
            height: Dims.deviceSize.height,
            width: Dims.deviceSize.width,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            padding: EdgeInsets.symmetric(horizontal: 40.dx)
                .copyWith(top: 155.dy, bottom: 20.dy),
            children: [
              Text(
                'GetGo App',
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
              // YBox(20.dy),
              // Text(
              //   'Tailored for you.',
              //   style: TextStyle(
              //     fontSize: 16.sp,
              //     fontWeight: FontWeight.w600,
              //     color: appColors.white,
              //   ),
              // ),
              YBox(170.dy),
              AppOutlinedButton(
                text: 'Login',
                onTap: () {
                  AppNavigator.pushNamed(AuthRoutes.login);
                },
              ),
              YBox(25.dy),
              AppButton(
                title: 'Sign Up',
                onTap: () {
                  AppNavigator.pushNamed(AuthRoutes.signUp);
                },
              ),
              YBox(10.dy),
              const OtherLoginOptionsWidget()
            ],
          ),
        ],
      ),
    );
  }
}
