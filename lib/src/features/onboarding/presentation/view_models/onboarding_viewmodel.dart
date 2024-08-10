import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gymApp/src/shared/api/api_service.dart';

final onboardingProvider = ChangeNotifierProvider((ref) {
  return OnboardingViewModel();
});

class OnboardingViewModel extends ChangeNotifier {
  List<String> activityFrequencies = [
    'SEDENTARY',
    'LIGHTLY',
    'MODERATELY',
    'VERY',
    'SUPER',
  ];
  String activityFrequency = '';
  String userWeight = '';
  String userHeight = '';

  final ApiService _apiService = ApiService();

  void selectActivityFreq(String selectedActivityFreq) {
    activityFrequency = selectedActivityFreq;
    notifyListeners();
  }

  // Future<void> submitOnboardingData() async {
  //   final weight = double.parse(userWeight) ?? 0.0; // Ensure weight is valid
  //   final height = double.parse(userHeight) ?? 0.0; // Ensure height is valid
  //   print('height: $height\nweight: $weight\nactivity: $activityFrequency');
  //
  //   try {
  //     await _apiService.postUserTarget(
  //       weight: weight,
  //       height: height,
  //       activityFrequency: activityFrequency,
  //     );
  //   } catch (e) {
  //     print('Error submitting onboarding data: $e');
  //   }
  // }
}