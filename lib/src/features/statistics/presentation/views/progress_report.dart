import 'package:gymApp/src/shared/api/api_service.dart';
import 'package:gymApp/src/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:google_fonts/google_fonts.dart';

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
  String _weightDate = '';
  String _chestDate = '';
  String _waistDate = '';
  String _hipsDate = '';

  TextEditingController _weightController = TextEditingController();
  TextEditingController _chestController = TextEditingController();
  TextEditingController _waistController = TextEditingController();
  TextEditingController _hipsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getTrackingValues();
  }

  Future<void> _getTrackingValues() async {
    try {
      final weightData = await apiService.getTrackingValue('WEIGHT');
      final chestData = await apiService.getTrackingValue('CHEST');
      final waistData = await apiService.getTrackingValue('WAIST');
      final hipsData = await apiService.getTrackingValue('HIPS');

      setState(() {
        _weight = weightData?['value'];
        _chest = chestData?['value'];
        _waist = waistData?['value'];
        _hips = hipsData?['value'];
        _weightDate = weightData?['createdDate'];
        _chestDate = chestData?['createdDate'];
        _waistDate = waistData?['createdDate'];
        _hipsDate = hipsData?['createdDate'];
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _selectDate(BuildContext context, String initialDate, ValueChanged<String> onDateSelected) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate.isNotEmpty ? DateTime.parse(initialDate) : DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      onDateSelected(picked.toIso8601String().split('T').first);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.dx),
        child: Column(
          children: [
            SparkleContainer(
              height: 148.dy,
              isBgWhite: true,
              padding: EdgeInsets.all(10.dx).copyWith(right: 2),
              decoration: BoxDecoration(
                color: appColors.white,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 5.dx),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text.rich(
                              TextSpan(
                                text: 'Weight',
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                            const Spacer(),
                            SvgAsset(assetName: diagonalArrows),
                          ],
                        ),
                        YBox(10.dy),
                        Row(
                          children: [
                            Text.rich(
                              TextSpan(
                                text: _weight != null ? '$_weight' : '0',
                                style: TextStyle(
                                  fontSize: 24.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                                children: [
                                  TextSpan(
                                    text: ' kg ',
                                    style: GoogleFonts.inter(
                                      color: appColors.grey80,
                                      fontSize: 24.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  WidgetSpan(
                                    child: Column(
                                      mainAxisAlignment:
                                      MainAxisAlignment.start,
                                      children: [
                                        Container(
                                          height: 9.dy,
                                          width: 1.dx,
                                          color: appColors.black,
                                        ),
                                        Container(
                                          height: 10.dy,
                                          width: 1.dx,
                                          color: Colors.transparent,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Spacer(),
                            Column(
                              children: [
                                _buildWeightNumber(),
                                SvgAsset(
                                  assetName: weightLossGraph,
                                  width: 152.dx,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  _buildRecordButton(
                      title: 'Weight',
                      valueController: _weightController,
                      date: _weightDate,
                      onSave: (newValue, newDate) async {
                        await apiService.postTrackingValue(newValue, 'WEIGHT',
                            newDate.isEmpty ? DateTime.now().toString().split(
                                ' ')[0] : newDate);

                        setState(() {
                          _weightController.text = newValue;
                          _weightDate = newDate;
                        });
                      },
                  ),
                ],
              ),
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
              child: _chestContent(),
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
              child: _waistContent(),
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
              child: _hipsContent(),
            ),
            YBox(30.dy),
          ],
        ),
      ),
    );
  }

  Container _buildWeightNumber() {
    return Container(
      width: 33.dx,
      height: 15.dy,
      alignment: Alignment.center,
      margin: EdgeInsets.only(left: 80.dx),
      decoration: BoxDecoration(
        color: appColors.green,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        _weight != null ? '$_weight kg' : '0 kg',
        style: GoogleFonts.inter(
          fontSize: 7.sp,
          fontWeight: FontWeight.w500,
          color: appColors.white,
        ),
      ),
    );
  }

  Widget _buildEditableContainer({
    required String title,
    required TextEditingController valueController,
    required String date,
    required VoidCallback onEdit,
  }) {
    return SparkleContainer(
      height: 157.dy,
      isBgWhite: true,
      padding: EdgeInsets.all(10.dx).copyWith(right: 2),
      decoration: BoxDecoration(
        color: appColors.white,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 5.dx),
            child: Column(
              children: [
                Row(
                  children: [
                    Text.rich(
                      TextSpan(
                        text: title,
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    const Spacer(),
                    SvgAsset(assetName: diagonalArrows),
                  ],
                ),
                YBox(10.dy),
                Text('Value: ${valueController.text}'),
                YBox(10.dy),
                Text('Date: $date'),
              ],
            ),
          ),
          const Spacer(),
          ElevatedButton(
            onPressed: onEdit,
            child: Text('Edit'),
          ),
        ],
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
                decoration: InputDecoration(labelText: '$title Value'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: dateController,
                decoration: InputDecoration(labelText: 'Date'),
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
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
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Save'),
              onPressed: () async {
                await onSave(valueController.text, dateController.text);
                await _getTrackingValues();
                Navigator.of(context).pop();
              },
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
    required Future<void> Function(String value, String date) onSave,
  }) {
    return InkWell(
      onTap: () {
        _showEditDialog(
          context: context,
          title: title,
          valueController: valueController,
          initialDate: date,
          onDateSelected: (newDate) {
            setState(() {
              date = newDate;
            });
          },
          onSave: onSave,
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

  Widget _buildDaySteps(String text) {
    return Column(
      children: [
        SvgAsset(assetName: stepProgress),
        YBox(10.dy),
        AppText(
          text: '$text  ',
          fontSize: 10.sp,
          fontWeight: FontWeight.w500,
          color: appColors.green,
        )
      ],
    );
  }

  Widget _chestContent() {
    return Column(
      children: [
        YBox(10.dy),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppText(
              text: 'Chest',
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              color: appColors.white,
            ),
            SvgAsset(
              assetName: arrowRight,
              color: appColors.white,
              height: 16.dx,
            ),
          ],
        ),
        const Spacer(),
        Row(
          children: [
            AppText(
              text: _chest != null ? '$_chest' : '0',
              fontSize: 20.sp,
              fontWeight: FontWeight.w600,
              color: appColors.white,
            ),
            const Spacer(),
            SvgAsset(assetName: kgIcon),
          ],
        ),
        AppText(
          isStartAligned: T,
          text: _chestDate != null ? '$_chestDate' : 'null',
          fontSize: 14.sp,
          fontWeight: FontWeight.w400,
          color: appColors.white,
        ),
        YBox(10.dy),
        const Spacer(),
        _buildRecordButton(
          title: 'Chest',
          valueController: _weightController,
          date: _weightDate,
          onSave: (newValue, newDate) async {
            await apiService.postTrackingValue(newValue, 'CHEST',
                newDate.isEmpty ? DateTime.now().toString().split(
                    ' ')[0] : newDate);

            setState(() {
              _weightController.text = newValue;
              _weightDate = newDate;
            });
          },
        ),
      ],
    );
  }

  Widget _waistContent() {
    return Column(
      children: [
        YBox(10.dy),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppText(
              text: 'Waist',
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              // color: appColors.white,
            ),
            SvgAsset(
              assetName: arrowRight,
              // color: appColors.white,
              height: 16.dx,
            ),
          ],
        ),
        const Spacer(),
        Row(
          children: [
            AppText(
              text: _waist != null ? '$_waist' : '0',
              fontSize: 20.sp,
              fontWeight: FontWeight.w600,
              // color: appColors.white,
            ),
            const Spacer(),
                SvgAsset(assetName: fireIcon),
          ],
        ),
        AppText(
          isStartAligned: T,
          text: _waistDate != null ? '$_waistDate' : 'null',
          fontSize: 14.sp,
          fontWeight: FontWeight.w400,
          // color: appColors.white,
        ),
        YBox(10.dy),
        const Spacer(),
        _buildRecordButton(
          title: 'Waist',
          valueController: _weightController,
          date: _weightDate,
          onSave: (newValue, newDate) async {
            await apiService.postTrackingValue(newValue, 'WAIST',
                newDate.isEmpty ? DateTime.now().toString().split(
                    ' ')[0] : newDate);

            setState(() {
              _weightController.text = newValue;
              _weightDate = newDate;
            });
          },
        ),
      ],
    );
  }

  Widget _hipsContent() {
    return Column(
      children: [
        YBox(10.dy),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppText(
              text: 'Hips',
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              color: appColors.white,
            ),
            SvgAsset(
              assetName: arrowRight,
              color: appColors.white,
              height: 16.dx,
            ),
          ],
        ),
        const Spacer(),
        Row(
          children: [
            AppText(
              text: _hips != null ? '$_hips' : '0',
              fontSize: 20.sp,
              fontWeight: FontWeight.w600,
              color: appColors.white,
            ),
            const Spacer(),
            SvgAsset(assetName: fireIcon),
          ],
        ),
        AppText(
          isStartAligned: T,
          text: _hipsDate != null ? '$_hipsDate' : 'null',
          fontSize: 14.sp,
          fontWeight: FontWeight.w400,
          color: appColors.white,
        ),
        YBox(10.dy),
        const Spacer(),
        _buildRecordButton(
          title: 'Hips',
          valueController: _weightController,
          date: _weightDate,
          onSave: (newValue, newDate) async {
            await apiService.postTrackingValue(newValue, 'HIPS',
                newDate.isEmpty ? DateTime.now().toString().split(
                    ' ')[0] : newDate);

            setState(() {
              _weightController.text = newValue;
              _weightDate = newDate;
            });
          },
        ),
      ],
    );
  }
}

