import 'package:fitness_tracker_app/src/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class AppTextField extends HookWidget {
  final TextEditingController? controller;
  final String labelText;
  final String? hintText;
  final bool isPasswordField, obscureText;
  const AppTextField({
    super.key,
    this.controller,
    required this.labelText,
    this.hintText,
    this.isPasswordField = false,
    this.obscureText = true,
  });

  @override
  Widget build(BuildContext context) {
    final isObscure = useState<bool>(obscureText);
    return Container(
      margin: EdgeInsets.only(bottom: 27.dy),
      decoration: BoxDecoration(
        border: BorderDirectional(
          bottom: BorderSide(
            color: appColors.white,
            width: 2,
          ),
        ),
      ),
      child: TextFormField(
        controller: controller,
        style: TextStyle(color: appColors.white),
        obscureText: isPasswordField ? obscureText : false,
        decoration: InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.always,
          labelText: labelText,
          fillColor: appColors.grey.withOpacity(0.3),
          suffixIcon: isPasswordField
              ? IconButton(
                  onPressed: () {
                    isObscure.value = !isObscure.value;
                  },
                  icon: Icon(
                    isObscure.value ? Icons.visibility : Icons.visibility_off,
                    color: appColors.white,
                  ),
                )
              : null,
        ),
      ),
    );
  }
}
