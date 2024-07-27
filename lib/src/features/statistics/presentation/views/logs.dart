import 'package:gymApp/src/shared/shared.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:gymApp/src/shared/api/api_service.dart';
import 'package:gymApp/src/features/auth/presentation/widgets/widgets.dart';

class Logs extends StatefulWidget {
  const Logs({super.key});

  @override
  _LogsState createState() => _LogsState();
}

class _LogsState extends State<Logs> {
  ApiService apiService = ApiService();
  List<FlSpot> dataPoints = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _getTrackingValues();
  }

  Future<void> _getTrackingValues() async {
    try {
      final trackingData = await apiService.getTrackingValues('WEIGHT');

      // Filter and sort the tracking data by date
      final validData = trackingData.where((data) {
        return data['createdDate'] != null && data['value'] != null;
      }).toList();

      validData.sort((a, b) {
        DateTime dateA = DateTime.parse(a['createdDate']);
        DateTime dateB = DateTime.parse(b['createdDate']);
        return dateA.compareTo(dateB);
      });

      setState(() {
        dataPoints = trackingData
            .map((data) => FlSpot(
            (DateTime.parse(data['createdDate']).millisecondsSinceEpoch / 1000).toDouble(),
            data['value'].toDouble()))
            .toList();
        isLoading = false;
      });
    } catch (e) {
      print('Failed to load tracking values: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  String formatDate(double value) {
    final date = DateTime.fromMillisecondsSinceEpoch(value.toInt() * 1000);
    return '${date.day}/${date.month}';
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weight'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: LineChart(
          LineChartData(
            gridData: const FlGridData(show: true),
            titlesData: FlTitlesData(
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 22,
                  interval: (dataPoints.isNotEmpty && dataPoints.length > 1) ? (dataPoints.last.x - dataPoints.first.x) / 5 : 1,
                  getTitlesWidget: (value, meta) {
                    return SideTitleWidget(
                      axisSide: meta.axisSide,
                      space: 8.0,
                      child: Text(
                        formatDate(value),
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    );
                  },
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 28,
                  getTitlesWidget: (value, meta) {
                    return Text(
                      '${value.toInt()}',
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    );
                  },
                ),
              ),
            ),
            borderData: FlBorderData(
              show: true,
              border: Border.all(color: const Color(0xff37434d), width: 1),
            ),
            minX: dataPoints.isNotEmpty ? dataPoints.first.x : 0,
            maxX: dataPoints.isNotEmpty ? dataPoints.last.x : 0,
            minY: 0,
            maxY: dataPoints.isNotEmpty
                ? dataPoints.map((e) => e.y).reduce((a, b) => a > b ? a : b)
                : 0,
            lineBarsData: [
              LineChartBarData(
                spots: dataPoints,
                isCurved: true,
                color: Colors.blue,
                barWidth: 4,
                belowBarData: BarAreaData(show: false),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       child: Padding(
//         padding: EdgeInsets.symmetric(horizontal: 15.dx),
//         child: Column(
//           children: [
//             SvgAsset(assetName: caloriesBurned),
//             YBox(10.dy),
//             SvgAsset(assetName: historyWeight),
//             YBox(20.dy),
//           ],
//         ),
//       ),
//     );
//   }
