import 'package:gymApp/src/features/auth/presentation/widgets/widgets.dart';
import 'package:gymApp/src/features/navigation/nav.dart';
import 'package:gymApp/src/features/navigation/routes.dart';
import 'package:gymApp/src/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart';

final usernameController = TextEditingController();
final passwordController = TextEditingController();
final firstNameController = TextEditingController();
final lastNameController = TextEditingController();

void register(String username, password, firstName, lastName) async{
  try{
    Response response = await post(Uri.parse('http://localhost:8080/api/v1/common/registration'),
        body: {
          'firstName': firstName,
          'lastName': lastName,
          'username' : username,
          'password' : password,
        });
    if(response.statusCode == 200){
      print('Register Successful');
      AppNavigator.pushNamed(AuthRoutes.loginOrSignUp);

    }else{
      print('login failed');
      int scode = response.statusCode;
    }
  }catch(e){
    print(e.toString());
  }
}

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
              AppTextField(
                  controller: firstNameController,
                  labelText: 'First Name'
              ),

              AppTextField(
                  controller: lastNameController,
                  labelText: 'Last Name'
              ),

              AppTextField(
                  controller: usernameController,
                  labelText: 'Username'
              ),

              AppTextField(
                controller: passwordController,
                labelText: 'Password',
                isPasswordField: true,
              ),

              // StartAlignedText(
              //   text: 'Forgot password?',
              //   style: TextStyle(
              //     color: appColors.white,
              //     fontSize: 13.sp,
              //     fontWeight: FontWeight.w800,
              //   ),
              // ),

              YBox(74.dy),
              AppButton(
                title: 'Create Account',
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
