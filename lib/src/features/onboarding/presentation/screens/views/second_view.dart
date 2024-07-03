import 'package:fitness_tracker_app/src/features/onboarding/presentation/screens/widgets/custom_tile.dart';
import 'package:fitness_tracker_app/src/features/onboarding/presentation/screens/widgets/top_container.dart';
import 'package:fitness_tracker_app/src/features/onboarding/presentation/view_models/onboarding_viewmodel.dart';
import 'package:fitness_tracker_app/src/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SecondView extends ConsumerWidget {
  final int currentPage;
  final PageController pageController;
  const SecondView({
    super.key,
    required this.currentPage,
    required this.pageController,
  });

  @override
  Widget build(BuildContext context, ref) {
    final ageRanges = ref.watch(onboardingProvider).ageRanges;
    final ageRange = ref.watch(onboardingProvider).ageRange;

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
            ageRanges.length,
            (index) => CustomTile(
              text: ageRanges[index],
              isSelected: ageRange == ageRanges[index],
              onTap: () {
                ref
                    .read(onboardingProvider.notifier)
                    .selectAgeRange(ageRanges[index]);
              },
            ),
          ),
        ),
      ],
    );
  }
}
