import 'package:fitness_tracker_app/src/features/onboarding/presentation/screens/widgets/custom_tile.dart';
import 'package:fitness_tracker_app/src/features/onboarding/presentation/screens/widgets/top_container.dart';
import 'package:fitness_tracker_app/src/features/onboarding/presentation/view_models/onboarding_viewmodel.dart';
import 'package:fitness_tracker_app/src/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FourthView extends ConsumerWidget {
  final int currentPage;
  final PageController pageController;
  const FourthView({
    super.key,
    required this.currentPage,
    required this.pageController,
  });

  @override
  Widget build(BuildContext context, ref) {
    final heightRanges = ref.watch(onboardingProvider).heightRanges;
    final heightRange = ref.watch(onboardingProvider).heightRange;

    return Column(
      children: [
        TopContainer(
          currentPage: currentPage,
          pageController: pageController,
        ),
        YBox(70.dy),
        AppColumn(
          padding: EdgeInsets.symmetric(horizontal: 30.dx),
          children: List.generate(
            heightRanges.length,
            (index) => CustomTile(
              text: heightRanges[index],
              isSelected: heightRange == heightRanges[index],
              onTap: () {
                ref
                    .read(onboardingProvider.notifier)
                    .selectHeightRange(heightRanges[index]);
              },
            ),
          ),
        ),
      ],
    );
  }
}
