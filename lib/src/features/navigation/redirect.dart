// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class AuthMiddleware extends GetMiddleware {
//   @override
//   RouteSettings? redirect(String? route) {
//     if (authManager.firstTimeUser) {
//       return const RouteSettings(name: AuthRoutes.onboarding);
//     }

//     if (authManager.authStatus == AuthStatus.unauthenticated) {
//       return const RouteSettings(name: AuthRoutes.login);
//     }

//     if (authManager.authStatus == AuthStatus.authenticated) {
//       return null;
//     }

//     return null;
//   }
// }
