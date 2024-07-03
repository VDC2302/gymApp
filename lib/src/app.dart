import 'package:fitness_tracker_app/src/features/navigation/nav.dart';
import 'package:fitness_tracker_app/src/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      final media = MediaQueryData.fromView(View.of(context));
      Dims.setSize(media);
      return MediaQuery(
        data: MediaQuery.of(context).copyWith(
          textScaler: const TextScaler.linear(1),
        ),
        child: GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'WeMove Fitness Tracker',
          theme: appTheme,
          initialRoute: AppPages.initial,
          getPages: AppPages.routes,
        ),
      );
    });
  }
}
