import 'package:gymApp/src/features/auth/presentation/widgets/widgets.dart';
import 'package:gymApp/src/features/navigation/nav.dart';
import 'package:gymApp/src/features/navigation/routes.dart';
import 'package:gymApp/src/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gymApp/src/shared/api/api_service.dart';



class LoginScreen extends StatefulWidget {
  static String? jwtToken;
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  ApiService apiService = ApiService();

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
              backAndTitle(title: 'Login'),
              YBox(80.dy),
              AppTextField(
                  controller: usernameController,
                  labelText: 'Username'
              ),

              AppTextField(
                controller: passwordController,
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
                  apiService.login(usernameController.text.toString(), passwordController.text.toString());
                },
              ),
              YBox(74.dy),
              // StartAlignedText(
              //   text: 'Username or Password not correct!',
              //   style: TextStyle(
              //   color: appColors.error,
              //   fontSize: 15.sp,
              //   fontWeight: FontWeight.w800,
              //   ),
              // ),
              YBox(74.dy),
              const OtherLoginOptionsWidget(),
            ],
          ),
        ],
      ),
    );
  }
}
