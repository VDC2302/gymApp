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
}