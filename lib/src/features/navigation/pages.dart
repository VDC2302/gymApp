import 'package:fitness_tracker_app/src/features/auth/presentation/screens/login_screen.dart';
import 'package:fitness_tracker_app/src/features/auth/presentation/screens/login_signup_screen.dart';
import 'package:fitness_tracker_app/src/features/auth/presentation/screens/signup_screen.dart';
import 'package:fitness_tracker_app/src/features/home/presentation/views/main_view.dart';
import 'package:fitness_tracker_app/src/features/navigation/routes.dart';
import 'package:fitness_tracker_app/src/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:fitness_tracker_app/src/features/splash/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'nav.dart';

class AppPages {
  static const initial = SplashRoute.splash;
  static final RouteObserver<Route> observer = RouteObservers();
  static List<String> history = [];

  static final List<GetPage> routes = [
    GetPage(
      name: SplashRoute.splash,
      page: () => const SplashScreen(),
      transition: Transition.fade,
      transitionDuration: const Duration(milliseconds: 500),
    ),
    ...authPages,
    ...homePages,
    ...trackPages,
    ...statisticsPages,
    ...settingsPages
  ];
}

//*-------------------------------Auth Routes---------------------------------------------
List<GetPage> authPages = [
  GetPage(
    name: AuthRoutes.loginOrSignUp,
    page: () => const LoginSignUpScreen(),
    transition: Transition.native,
    transitionDuration: const Duration(milliseconds: 500),
  ),
  GetPage(
    name: AuthRoutes.login,
    page: () => const LoginScreen(),
    transition: Transition.leftToRightWithFade,
    transitionDuration: const Duration(milliseconds: 500),
  ),
  GetPage(
    name: AuthRoutes.signUp,
    page: () => const SignUpScreen(),
    transition: Transition.leftToRightWithFade,
    transitionDuration: const Duration(milliseconds: 500),
  ),
  GetPage(
    name: AuthRoutes.onboarding,
    page: () => const OnboardingScreen(),
    transition: Transition.rightToLeft,
    transitionDuration: const Duration(milliseconds: 500),
  ),
];

//*-------------------------------Home Routes---------------------------------------------
List<GetPage> homePages = [
  GetPage(
    name: HomeRoutes.main,
    page: () => const MainView(),
    transition: Transition.native,
    transitionDuration: const Duration(milliseconds: 500),
  ),
];

//*-------------------------------Track Routes--------------------------------------------
List<GetPage> trackPages = [];

//*---------------------------Statiststics Routes-----------------------------------------
List<GetPage> statisticsPages = [];

//*------------------------------Settings Routes------------------------------------------
List<GetPage> settingsPages = [];
