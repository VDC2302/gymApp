import 'package:fitness_tracker_app/src/shared/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final onboardingProvider = ChangeNotifierProvider((ref) {
  return OnboardingViewModel();
});

class OnboardingViewModel extends ChangeNotifier {
  Gender gender = Gender.male;
  List<String> ageRanges = ['18 - 22', '23 - 29', '30 - 35', '36 - 40'];
  List<String> weightRanges = [
    '50 - 59 kg',
    '60 - 69 kg',
    '70 - 79 kg',
    '80 - 90 kg',
  ];

  List<String> heightRanges = [
    '150 - 159 cm',
    '160 - 169 cm',
    '170 - 179 cm',
    '180 - 190 cm',
  ];
  List<String> workoutGoals = [
    'Get fit',
    'Gain weight',
    'Lose weight',
    'Muscle gain',
    'Build endurance',
  ];

  List<String> fitnessLevels = [
    'Beginner',
    'Intermediate',
    'Advanced',
  ];
//?----------------------------------------------------------------
  String ageRange = '';
  String weightRange = '';
  String heightRange = '';
  String fitnessLevel = '';
  List<String> selectedWorkoutGoals = [];

  void selectGender(bool isMale) {
    if (isMale) {
      gender = Gender.male;
    } else {
      gender = Gender.female;
    }
    notifyListeners();
  }

  void selectAgeRange(String selectedAgeRange) {
    ageRange = selectedAgeRange;
    notifyListeners();
  }

  void selectWeightRange(String selectedWeightRange) {
    weightRange = selectedWeightRange;
    notifyListeners();
  }

  void selectHeightRange(String selectedHeightRange) {
    heightRange = selectedHeightRange;
    notifyListeners();
  }

  void selectFitnessLevel(String selectedFitnessLevel) {
    fitnessLevel = selectedFitnessLevel;
    notifyListeners();
  }

  void selectWorkoutGoal(String selectedGoal) {
    if (selectedWorkoutGoals.contains(selectedGoal)) {
      selectedWorkoutGoals.remove(selectedGoal);
    } else {
      selectedWorkoutGoals.add(selectedGoal);
    }
    notifyListeners();
  }
}
