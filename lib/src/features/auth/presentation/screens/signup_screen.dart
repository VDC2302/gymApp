import 'package:gymApp/src/features/auth/presentation/widgets/widgets.dart';
import 'package:gymApp/src/features/navigation/nav.dart';
import 'package:gymApp/src/features/navigation/routes.dart';
import 'package:gymApp/src/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Image.asset(
            height: Dims.deviceSize.height,
            width: Dims.deviceSize.width,
            splashImage,
            fit: BoxFit.fitHeight,
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: SvgPicture.asset(
              sparkleEffect,
              fit: BoxFit.fitHeight,
            ),
          ),
          AppColumn(
            height: Dims.deviceSize.height,
            width: Dims.deviceSize.width,
            padding:
                EdgeInsets.symmetric(horizontal: 15.dx).copyWith(top: 55.dy),
            children: [
              backAndTitle(title: 'Sign up'),
              YBox(80.dy),
              const AppTextField(labelText: 'Username'),
              const AppTextField(labelText: 'Email'),
              const AppTextField(
                labelText: 'Password',
                isPasswordField: true,
              ),
              StartAlignedText(
                text: 'Forgot password?',
                style: TextStyle(
                  color: appColors.white,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w800,
                ),
              ),
              YBox(74.dy),
              AppButton(
                title: 'Continue',
                onTap: () {
                  AppNavigator.pushNamed(AuthRoutes.onboarding);
                },
              ),
              YBox(74.dy),
              const OtherLoginOptionsWidget()
            ],
          ),
        ],
      ),
    );
  }
}
