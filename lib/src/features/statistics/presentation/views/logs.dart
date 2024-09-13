import 'package:flutter/material.dart';
import 'package:gymApp/src/shared/api/api_service.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class Logs extends StatefulWidget {
  const Logs({super.key,});

  @override
  _LogsState createState() => _LogsState();
}

class _LogsState extends State<Logs> {
  bool isLoading = false;
  List<TrackingData> latestData = [];
  ApiService apiService = ApiService();
  late Future<List<TrackingData>> caloriesData;
  late Future<List<TrackingData>> weightData;
  late Future<List<TrackingData>> chestData;
  late Future<List<TrackingData>> waistData;
  late Future<List<TrackingData>> hipsData;


  @override
  void initState() {
    super.initState();
    caloriesData = apiService.graphTrackingData('CALORIES');
    weightData = apiService.graphTrackingData('WEIGHT');
    chestData = apiService.graphTrackingData('CHEST');
    waistData = apiService.graphTrackingData('WAIST');
    hipsData = apiService.graphTrackingData('HIPS');
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildChart(caloriesData, 'Calories'),
            _buildChart(weightData, 'Weight'),
            _buildChart(chestData, 'Chest'),
            _buildChart(waistData, 'Waist'),
            _buildChart(hipsData, 'Hips'),
          ],
        ),
      ),
    );
  }

  Widget _buildChart(Future<List<TrackingData>> dataFuture, String title) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: 300,
        child: FutureBuilder<List<TrackingData>>(
          future: dataFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              final data = snapshot.data ?? [];

              return SfCartesianChart(
                primaryXAxis: const CategoryAxis(
                  labelRotation: 45,
                ),
                primaryYAxis: const NumericAxis(
                  title: AxisTitle(text: 'Value'),
                ),
                title: ChartTitle(
                  text: title,
                  textStyle: const TextStyle(fontSize: 14),
                ),
                tooltipBehavior: TooltipBehavior(enable: true),
                series: <CartesianSeries>[
                  BarSeries<TrackingData, String>(
                    dataSource: data,
                    xValueMapper: (TrackingData data, _) {
                      DateTime parsedDate = DateTime.parse(data.createdDate);
                      String formattedDate = DateFormat('MM-dd').format(
                          parsedDate);
                      return formattedDate; // Return the formatted date string
                    },
                    yValueMapper: (TrackingData data, _) => data.value,
                    name: title,
                    color: Colors.blue,
                    // Render a placeholder bar if there's no data
                    emptyPointSettings: const EmptyPointSettings(
                      mode: EmptyPointMode.zero,
                      color: Colors.grey,
                    ),
                  )
                ],
              );
            }
          },
        ),
      ),
    );
  }
}

class TrackingData {
  final int id;
  final String trackingType;
  final double value;
  final String createdDate;
  final String createdTime;

  TrackingData({
    required this.id,
    required this.trackingType,
    required this.value,
    required this.createdDate,
    required this.createdTime,
  });

  factory TrackingData.fromJson(Map<String, dynamic> json) {
    return TrackingData(
      id: json['id'],
      trackingType: json['trackingType'],
      value: json['value'],
      createdDate: json['createdDate'],
      createdTime: json['createdTime'],
    );
  }
}