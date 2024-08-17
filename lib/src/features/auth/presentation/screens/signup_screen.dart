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
  final TextEditingController _birthYearController = TextEditingController();
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

    // Check if birth year is empty
    int? birthYear;
    if (_birthYearController.text.isNotEmpty) {
      try {
        birthYear = int.parse(_birthYearController.text);
      } catch (e) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Please check your information again';
        });
        return;
      }
    } else {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Please check your information again';
      });
      return;
    }

    ApiService apiService = ApiService();
    final result = await apiService.register(
      _firstNameController.text,
      _lastNameController.text,
      birthYear,
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
                  controller: _birthYearController,
                  labelText: 'Birth Year'
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
                  dropdownColor: Colors.white, // Sets the background color of the dropdown menu
                  items: ['Male', 'Female', 'Other'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: const TextStyle(color: Colors.black), // Sets the text color in the dropdown menu
                      ),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedGender = newValue;
                    });
                  },
                  selectedItemBuilder: (BuildContext context) {
                    return ['Male', 'Female', 'Other'].map<Widget>((String value) {
                      return Text(
                        value,
                        style: const TextStyle(color: Colors.white), // Sets the text color of the selected item
                      );
                    }).toList();
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

              YBox(50.dy),
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
