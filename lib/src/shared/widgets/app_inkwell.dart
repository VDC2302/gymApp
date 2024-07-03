import 'package:fitness_tracker_app/src/shared/shared.dart';
import 'package:flutter/material.dart';

class AppInkWell extends StatelessWidget {
  final Widget child;
  final VoidCallback onTap;
  const AppInkWell({super.key, required this.child, required this.onTap,});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: EdgeInsets.all(10.dx),
        child: child,
      ),
    );
  }
}