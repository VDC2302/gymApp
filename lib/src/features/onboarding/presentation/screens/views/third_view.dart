import 'package:fitness_tracker_app/src/features/onboarding/presentation/screens/widgets/custom_tile.dart';
import 'package:fitness_tracker_app/src/features/onboarding/presentation/screens/widgets/top_container.dart';
import 'package:fitness_tracker_app/src/features/onboarding/presentation/view_models/onboarding_viewmodel.dart';
import 'package:fitness_tracker_app/src/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ThirdView extends ConsumerWidget {
  final int currentPage;
  final PageController pageController;
  const ThirdView({
    super.key,
    required this.currentPage,
    required this.pageController,
  });

  @override
  Widget build(BuildContext context, ref) {
    final weightRanges = ref.watch(onboardingProvider).weightRanges;
    final weightRange = ref.watch(onboardingProvider).weightRange;

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
            weightRanges.length,
            (index) => CustomTile(
              text: weightRanges[index],
              isSelected: weightRange == weightRanges[index],
              onTap: () {
                ref
                    .read(onboardingProvider.notifier)
                    .selectWeightRange(weightRanges[index]);
              },
            ),
          ),
        ),
      ],
    );
  }
}
