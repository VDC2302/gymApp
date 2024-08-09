import 'package:gymApp/src/shared/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final onboardingProvider = ChangeNotifierProvider((ref) {
  return OnboardingViewModel();
});

class OnboardingViewModel extends ChangeNotifier {
  Gender gender = Gender.male;
  List<String> activityFrequencies = [
    'SEDENTARY',
    'LIGHTLY',
    'MODERATELY',
    'VERY',
    'SUPER'];
//?----------------------------------------------------------------
  String activityFrequency = '';
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

  void selectActivityFreq(String selectedActivityFreq) {
    activityFrequency = selectedActivityFreq;
    notifyListeners();
  }
}
