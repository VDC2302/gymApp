import 'package:gymApp/src/features/auth/presentation/widgets/widgets.dart';
import 'package:gymApp/src/features/navigation/routes.dart';
import 'package:gymApp/src/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:gymApp/src/shared/api/api_service.dart';



class LoginScreen extends StatefulWidget {
  static String? jwtToken;
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _login() async{
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    ApiService apiService = ApiService();
    final result = await apiService.login(_usernameController.text, _passwordController.text);
    setState(() {
      _isLoading = false;
    });

    if (result != null && result['success'] == true) {
      Navigator.pushReplacementNamed(context, HomeRoutes.main);
    }else{
      print(result);
      setState(() {
        if (result != null && result['message'] != null && result['message'].isNotEmpty) {
          _errorMessage = result['message'];
        }else{
          _errorMessage = result?['message'];
        }
      });
    }
}

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
          // Padding(
          //   padding: const EdgeInsets.all(4.0),
          //   child: SvgPicture.asset(
          //     sparkleEffect,
          //     fit: BoxFit.fitHeight,
          //   ),
          // ),
          AppColumn(
            height: Dims.deviceSize.height,
            width: Dims.deviceSize.width,
            padding:
                EdgeInsets.symmetric(horizontal: 15.dx).copyWith(top: 55.dy),
            children: [
              backAndTitle(title: 'Login'),
              YBox(80.dy),
              AppTextField(
                  controller: _usernameController,
                  labelText: 'Username'
              ),

              AppTextField(
                controller: _passwordController,
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

              if (_errorMessage != null)
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    _errorMessage!,
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              AppButton(
                title: 'Continue',
                onTap: _login,
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
              // const OtherLoginOptionsWidget(),
            ],
          ),
        ],
      ),
    );
  }
}
