import 'package:gymApp/src/features/auth/presentation/widgets/widgets.dart';
import 'package:gymApp/src/features/navigation/routes.dart';
import 'package:gymApp/src/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:gymApp/src/shared/api/api_service.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? _selectedGender;
  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _register() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    ApiService apiService = ApiService();
    final result = await apiService.register(
      _firstNameController.text,
      _lastNameController.text,
      _usernameController.text,
      _passwordController.text,
      _selectedGender,
    );

    setState(() {
      _isLoading = false;
    });

    if (result != null && result['success'] == true) {
      Navigator.pushReplacementNamed(context, AuthRoutes.loginOrSignUp);
    } else {
      setState(() {
        if (result != null && result['errors'] != null && result['errors'].isNotEmpty) {
          _errorMessage = result['errors'];
        } else {
          _errorMessage = result?['errors'];
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
              backAndTitle(title: 'Sign up'),
              AppTextField(
                  controller: _firstNameController,
                  labelText: 'First Name'
              ),

              AppTextField(
                  controller: _lastNameController,
                  labelText: 'Last Name'
              ),

              AppTextField(
                  controller: _usernameController,
                  labelText: 'Username'
              ),

              AppTextField(
                controller: _passwordController,
                labelText: 'Password',
                isPasswordField: true,
              ),

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: DropdownButtonFormField<String>(
                  value: _selectedGender,
                  hint: const Text(
                      'Select Gender',
                      style: TextStyle(color: Colors.white),
                  ),
                  items: ['Male', 'Female', 'Other'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedGender = newValue;
                    });
                  },
                ),
              ),

              if (_errorMessage != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    _errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),

              YBox(74.dy),
              AppButton(
                title: 'Create Account',
                onTap: _register,
              ),
            ],
          ),
        ],
      ),
    );
  }
  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
