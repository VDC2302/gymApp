import 'package:gymApp/src/features/statistics/presentation/views/progress_report.dart';
import 'package:gymApp/src/shared/shared.dart';
import 'package:flutter/cupertino.dart';

class Logs extends StatelessWidget {
  const Logs({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.dx),
        child: Column(
          children: [
            SvgAsset(assetName: caloriesBurned),
            YBox(10.dy),
            SvgAsset(assetName: historyWeight),
            YBox(20.dy),
          ],
        ),
      ),
    );
  }
}
