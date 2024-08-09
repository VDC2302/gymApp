import 'package:gymApp/src/features/onboarding/presentation/screens/widgets/top_container.dart';
import 'package:gymApp/src/features/onboarding/presentation/view_models/onboarding_viewmodel.dart';
import 'package:gymApp/src/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FirstView extends ConsumerWidget {
  final int currentPage;
  final PageController pageController;
  const FirstView({
    super.key,
    required this.currentPage,
    required this.pageController,
  });

  @override
  Widget build(BuildContext context, ref) {
    final weightController = TextEditingController();
    final heightController = TextEditingController();

    return Column(
      children: [
        TopContainer(
          currentPage: currentPage,
          pageController: pageController,
        ),
        YBox(70.dy),
        _buildInputField(
          controller: weightController,
          label: 'Weight (kg)',
        ),
        YBox(30.dy),
        _buildInputField(
          controller: heightController,
          label: 'Height (cm)',
        ),
      ],
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start, // Align label to the left
      children: [
        Text(
          label, // Display the label text
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: Colors.black, // Set label color to black
          ),
        ),
        YBox(10.dy), // Add some space between the label and the input field
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.dx),
          decoration: BoxDecoration(
            color: appColors.white, // White background color
            borderRadius: BorderRadius.circular(11),
            border: Border.all(color: appColors.grey),
          ),
          child: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'Enter your $label',
              hintStyle: TextStyle(color: appColors.grey), // Hint text style
            ),
          ),
        ),
      ],
    );
  }
}