import 'package:gymApp/src/features/onboarding/presentation/screens/widgets/top_container.dart';
import 'package:gymApp/src/shared/shared.dart';
import 'package:flutter/material.dart';

class SeventhView extends StatelessWidget {
  final int currentPage;
  final PageController pageController;
  const SeventhView({
    super.key,
    required this.currentPage,
    required this.pageController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TopContainer(
          currentPage: currentPage,
          pageController: pageController,
        ),
        YBox(70.dy),
      ],
    );
  }
}
