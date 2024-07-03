import 'package:fitness_tracker_app/src/shared/shared.dart';
import 'package:flutter/material.dart';

class CustomTile extends StatelessWidget {
  final bool isSelected;
  final String text;
  final VoidCallback onTap;
  const CustomTile({
    super.key,
    this.isSelected = false,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 56.72.dy,
        width: double.infinity,
        margin: EdgeInsets.only(bottom: 20.dy),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(26),
          color: appColors.white,
          border: isSelected ? Border.all(color: theme.secondary) : null,
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
