import 'package:gymApp/src/shared/api/api_service.dart';
import 'package:gymApp/src/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';

class ProgressReport extends StatefulWidget {
  const ProgressReport({super.key});

  @override
  _ProgressReportState createState() => _ProgressReportState();
}

class _ProgressReportState extends State<ProgressReport> {
  ApiService apiService = ApiService();
  double? _weight;
  double? _chest;
  double? _waist;
  double? _hips;
  double? _calories;
  String _weightDate = '';
  String _chestDate = '';
  String _waistDate = '';
  String _hipsDate = '';
  String _caloriesDate = '';
  int? _weightId;
  int? _chestId;
  int? _waistId;
  int? _hipsId;
  int? _caloriesId;


  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _chestController = TextEditingController();
  final TextEditingController _waistController = TextEditingController();
  final TextEditingController _hipsController = TextEditingController();
  final TextEditingController _caloriesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getTrackingValues();
  }

  Future<void> _getTrackingValues() async {
    try {
      final weightData = await apiService.getLatestTrackingValue('WEIGHT');
      final chestData = await apiService.getLatestTrackingValue('CHEST');
      final waistData = await apiService.getLatestTrackingValue('WAIST');
      final hipsData = await apiService.getLatestTrackingValue('HIPS');
      final caloriesData = await apiService.getLatestTrackingValue('CALORIES');

      setState(() {
        _weight = weightData?['value'];
        _chest = chestData?['value'];
        _waist = waistData?['value'];
        _hips = hipsData?['value'];
        _calories = caloriesData?['value'];
        _weightDate = weightData?['createdDate'] ?? '';
        _chestDate = chestData?['createdDate'] ?? '';
        _waistDate = waistData?['createdDate'] ?? '';
        _hipsDate = hipsData?['createdDate'] ?? '';
        _caloriesDate = caloriesData?['createdDate'] ?? '';

        _weightId = weightData?['id'];
        _chestId = chestData?['id'];
        _waistId = waistData?['id'];
        _hipsId = hipsData?['id'];
        _caloriesId = caloriesData?['id'];
      });
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(onRefresh: _getTrackingValues,
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.dx),
          child: Column(
            children: [
              SparkleContainer(
                height: 157.dy,
                isBgWhite: true,
                fit: BoxFit.cover,
                padding: EdgeInsets.all(10.dx),
                decoration: BoxDecoration(
                  color: appColors.white,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: _measureContent('Calories Burned', 'CALORIES', _calories, _caloriesDate, _caloriesController, _caloriesId),
              ),
              YBox(30.dy),
              SparkleContainer(
                height: 157.dy,
                fit: BoxFit.cover,
                padding: EdgeInsets.all(10.dx),
                decoration: BoxDecoration(
                  color: appColors.green,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: _measureContent('Weight', 'WEIGHT', _weight, _weightDate, _weightController, _weightId),
              ),
              YBox(30.dy),
              SparkleContainer(
                height: 157.dy,
                isBgWhite: true,
                fit: BoxFit.cover,
                padding: EdgeInsets.all(10.dx),
                decoration: BoxDecoration(
                  color: appColors.white,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: _measureContent('Chest', 'CHEST', _chest, _chestDate, _chestController, _chestId),
              ),
              YBox(30.dy),
              SparkleContainer(
                height: 157.dy,
                fit: BoxFit.cover,
                padding: EdgeInsets.all(10.dx),
                decoration: BoxDecoration(
                  color: appColors.green,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: _measureContent('Waist', 'WAIST', _waist, _waistDate, _waistController, _waistId),
              ),
              YBox(30.dy),
              SparkleContainer(
                height: 157.dy,
                isBgWhite: true,
                fit: BoxFit.cover,
                padding: EdgeInsets.all(10.dx),
                decoration: BoxDecoration(
                  color: appColors.white,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: _measureContent('Hips', 'HIPS', _hips, _hipsDate, _hipsController, _hipsId),
              ),
              YBox(30.dy),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showEditDialog({
    required BuildContext context,
    required String title,
    required TextEditingController valueController,
    required String initialDate,
    required ValueChanged<String> onDateSelected,
    required Future<void> Function(String value, String date) onSave,
    required int? id, // Add this parameter
  }) async {
    TextEditingController dateController = TextEditingController(text: initialDate);

    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit $title'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: valueController,
                decoration: InputDecoration(labelText: '$title Value', labelStyle: const TextStyle(color: Colors.black)),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: dateController,
                decoration: const InputDecoration(labelText: 'Date', labelStyle: TextStyle(color: Colors.black)),
                readOnly: true,
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime.now(),
                  );
                  if (pickedDate != null) {
                    dateController.text = pickedDate.toString().split(' ')[0];
                    onDateSelected(dateController.text);
                  }
                },
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.black,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                await onSave(valueController.text, dateController.text);
                await _getTrackingValues();
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.black,
              ),
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  InkWell _buildRecordButton({
    required String title,
    required TextEditingController valueController,
    required String date,
    required int? id, // Add this parameter
    required Future<void> Function(String value, String date) onSave,
  }) {
    return InkWell(
      onTap: () {
        _showEditDialog(
          context: context,
          title: title,
          valueController: valueController,
          initialDate: DateTime.now().toString().split(' ')[0],
          onDateSelected: (newDate) {
            setState(() {
              date = newDate;
            });
          },
          onSave: (newValue, newDate) async {
            await onSave(newValue, newDate);
          },
          id: id, // Pass ID to dialog
        );
      },
      child: Container(
        height: 35.35.dy,
        width: 173.9.dx,
        decoration: BoxDecoration(
          color: appColors.yellow,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
          child: AppText(
            text: 'Edit',
            fontSize: 15.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _measureContent(
      String title,
      String type,
      double? value,
      String date,
      TextEditingController controller,
      int? id, // Change to int?
      ) {
    return Column(
      children: [
        YBox(10.dy),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppText(
              text: title,
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              color: type == 'WEIGHT' || type == 'WAIST' ? appColors.white : appColors.black,
            ),
            SvgAsset(
              assetName: arrowRight,
              color: type == 'WEIGHT' || type == 'WAIST' ? appColors.white : appColors.black,
              height: 16.dx,
            ),
          ],
        ),
        const Spacer(),
        Row(
          children: [
            AppText(
              text: value != null ? '$value' : '0',
              fontSize: 20.sp,
              fontWeight: FontWeight.w600,
              color: type == 'WEIGHT' || type == 'WAIST' ? appColors.white : appColors.black,
            ),
            const Spacer(),
            SvgAsset(assetName: type == 'WEIGHT' ? kgIcon
                : type == 'CALORIES' ? exploreFilled : fireIcon),
          ],
        ),
        AppText(
          isStartAligned: T,
          text: date.isNotEmpty ? date : 'N/A',
          fontSize: 14.sp,
          fontWeight: FontWeight.w400,
          color: type == 'WEIGHT' || type == 'WAIST' ? appColors.white : appColors.black,
        ),
        YBox(10.dy),
        const Spacer(),
        Visibility(
          visible: type != 'CALORIES' ? true : false,
          child: _buildRecordButton(
            title: title,
            valueController: controller,
            date: date,
            id: id, // Pass id here
            onSave: (newValue, newDate) async {
              if (id != null) {
                await apiService.editTrackingValue(id, newValue, type, newDate);
              } else {
                await apiService.postTrackingValue(newValue, type, newDate);
              }

              setState(() {
                controller.text = newValue;
                date = newDate;
              });
            },
          ),
        ),
      ],
    );
  }
}