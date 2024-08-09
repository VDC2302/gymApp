import 'package:gymApp/src/features/onboarding/presentation/screens/widgets/custom_tile.dart';
import 'package:gymApp/src/features/onboarding/presentation/screens/widgets/top_container.dart';
import 'package:gymApp/src/features/onboarding/presentation/view_models/onboarding_viewmodel.dart';
import 'package:gymApp/src/shared/shared.dart';
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
    final activityFrequencies = ref.watch(onboardingProvider).activityFrequencies;
    final activityFrequency = ref.watch(onboardingProvider).activityFrequency;

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
            activityFrequencies.length,
            (index) => CustomTile(
              text: activityFrequencies[index],
              isSelected: activityFrequency == activityFrequencies[index],
              onTap: () {
                ref
                    .read(onboardingProvider.notifier)
                    .selectActivityFreq(activityFrequencies[index]);
              },
            ),
          ),
        ),
      ],
    );
  }
}
