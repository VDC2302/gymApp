import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gymApp/src/features/onboarding/presentation/view_models/onboarding_viewmodel.dart';
import 'package:gymApp/src/shared/shared.dart';

import '../widgets/top_container.dart';

class FirstView extends ConsumerWidget {
  final int currentPage;
  final PageController pageController;

  const FirstView({
    super.key,
    required this.currentPage,
    required this.pageController,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
          onChanged: (value) {
            ref
                .read(onboardingProvider.notifier)
                .userWeight = value;
          },
        ),
        YBox(30.dy),
        _buildInputField(
          controller: heightController,
          label: 'Height (cm)',
          onChanged: (value) {
            ref
                .read(onboardingProvider.notifier)
                .userHeight = value;
          },
        ),
      ],
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required Function(String) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        YBox(10.dy),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.dx),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(11),
            border: Border.all(color: appColors.grey),
          ),
          child: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            onChanged: onChanged,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'Enter your $label',
              hintStyle: TextStyle(color: appColors.grey),
              fillColor: Colors.white,
              filled: true,
            ),
          ),
        ),
      ],
    );
  }
}