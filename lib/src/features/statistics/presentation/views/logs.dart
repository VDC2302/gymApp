import 'package:gymApp/src/shared/shared.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:gymApp/src/shared/api/api_service.dart';
import 'package:gymApp/src/features/auth/presentation/widgets/widgets.dart';

class Logs extends StatefulWidget {
  const Logs({Key? key}) : super(key: key);

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

      // Get the last 7 items from the sorted tracking data
      final latestData = trackingData.take(7).toList();

      setState(() {
        dataPoints = latestData
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

  // Helper function to format the date from the value (in seconds since epoch)
  String formatDate(double value) {
    final date = DateTime.fromMillisecondsSinceEpoch(value.toInt() * 1000);
    return '${date.day}/${date.month}';
  }

  @override
  Widget build(BuildContext context) {
    final double minX = dataPoints.isNotEmpty ? dataPoints.first.x : 0;
    final double maxX = dataPoints.isNotEmpty ? dataPoints.last.x : 0;
    final int totalPoints = dataPoints.length;
    final double interval = totalPoints > 7 ? (maxX - minX) : 1;

    // Keep track of displayed dates to avoid duplicates
    Set<String> displayedDates = {};

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
                  showTitles: false,
                  reservedSize: 100,
                   interval: interval,
                  getTitlesWidget: (value, meta) {
                    String formattedDate = formatDate(value);
                    if (displayedDates.contains(formattedDate)) {
                      return const SizedBox.shrink();
                    }
                    displayedDates.add(formattedDate);
                    return SideTitleWidget(
                      axisSide: meta.axisSide,
                      space: 8.0,
                      child: Text(
                        formattedDate, // X-Axis Label
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
                      '${value.toInt()}', // Y-Axis Label
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
            minX: minX, // X-Axis Minimum Value
            maxX: maxX, // X-Axis Maximum Value
            minY: dataPoints.isNotEmpty ? dataPoints.map((e) => e.y).reduce((a, b) => a < b ? a : b) : 0, // Y-Axis Minimum Value
            maxY: dataPoints.isNotEmpty
                ? dataPoints.map((e) => e.y).reduce((a, b) => a > b ? a : b)
                : 0, // Y-Axis Maximum Value
            lineBarsData: [
              LineChartBarData(
                spots: dataPoints, // Data Points
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