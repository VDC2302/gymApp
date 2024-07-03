import 'package:fitness_tracker_app/src/features/onboarding/presentation/screens/widgets/custom_tile.dart';
import 'package:fitness_tracker_app/src/features/onboarding/presentation/screens/widgets/top_container.dart';
import 'package:fitness_tracker_app/src/features/onboarding/presentation/view_models/onboarding_viewmodel.dart';
import 'package:fitness_tracker_app/src/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FifthView extends ConsumerWidget {
  final int currentPage;
  final PageController pageController;
  const FifthView({
    super.key,
    required this.currentPage,
    required this.pageController,
  });

  @override
  Widget build(BuildContext context, ref) {
    final workoutGoals = ref.watch(onboardingProvider).workoutGoals;
    final selectedWorkoutGoals =
        ref.watch(onboardingProvider).selectedWorkoutGoals;

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
            workoutGoals.length,
            (index) => CustomTile(
              text: workoutGoals[index],
              isSelected: selectedWorkoutGoals.contains(workoutGoals[index]),
              onTap: () {
                ref
                    .read(onboardingProvider.notifier)
                    .selectWorkoutGoal(workoutGoals[index]);
              },
            ),
          ),
        ),
      ],
    );
  }
}
