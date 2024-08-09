import 'package:gymApp/src/features/statistics/presentation/views/statistics_view.dart';
import 'package:gymApp/src/shared/shared.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gymApp/src/shared/api/api_service.dart';
import 'package:intl/intl.dart';

enum HomeAct { first, second, third, fourth }

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  ApiService apiService = ApiService();
  String? _firstName;
  bool _isLoading = true;
  String? _errorMessage;
  double? _weight;
  double? _calories;
  double? _foodCalories;

  @override
  void initState() {
    super.initState();
    _getFirstName();
    _getTrackingValue();
    _getFoodCalories();
  }

  Future<void> _getFoodCalories() async {
    final foodCalories = await apiService.getUserTodayMeal();
  }

  Future<void> _getFirstName() async {
    try {
      final firstName = await apiService.getProfile();
      setState(() {
        _firstName = firstName?['firstName'];
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load name: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _getTrackingValue() async{
    try{
      final weightData = await apiService.getLatestTrackingValue('WEIGHT');
      final caloriesData = await apiService.getLatestTrackingValue('CALORIES');

      setState(() {
        _weight = weightData?['value'];
       _calories = caloriesData?['value'];
      });
    }catch(e){
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appColors.lightGrey,
      appBar: PreferredSize(
          preferredSize: Size(double.infinity, 122.dy), child: _buildAppBar()),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.dx),
          child: Column(
            children: [
              YBox(20.dy),
              Row(
                children: [
                  Text.rich(
                    TextSpan(
                      text: _isLoading
                          ? 'Loading...'
                          : ('$_firstName\n'),
                      style: GoogleFonts.inter(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                      children: [
                        TextSpan(
                          text: 'your boards are looking good',
                          style: GoogleFonts.inter(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w400,
                            color: appColors.grey80,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  SvgAsset(assetName: stagChart),
                  XBox(20.dx),
                ],
              ),
              _buildText('Activity'),
              SparkleContainer(
                height: 128.dy,
                isBgWhite: true,
                decoration: BoxDecoration(
                  color: appColors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: _buildActivityContent(HomeAct.first),
              ),
              YBox(20.dy),
              SparkleContainer(
                height: 128.dy,
                isBgWhite: true,
                decoration: BoxDecoration(
                  color: appColors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: _buildActivityContent(HomeAct.second),
              ),
              YBox(20.dy),
              SparkleContainer(
                height: 128.dy,
                isBgWhite: true,
                decoration: BoxDecoration(
                  color: appColors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: _buildActivityContent(HomeAct.fourth),
              ),

            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSplitTexts(String text) {
    return Row(
      children: [
        XBox(10.dx),
        AppText(
          text: text,
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
        ),
        const Spacer(),
        BounceInAnimation(
          child: AppText(
            text: 'see more',
            fontSize: 12.sp,
            fontWeight: FontWeight.w400,
            color: appColors.grey80,
          ),
        ),
        XBox(10.dx),
      ],
    );
  }

  Widget _buildActivityContent(HomeAct homeAct) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 20.dy).copyWith(left: 10.dx),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  homeAct == HomeAct.first
                      ? SvgAsset(assetName: fireIcon)
                      : homeAct == HomeAct.second
                      ? SvgAsset(assetName: weightIcon)
                      : SvgAsset(assetName: foodIcon),
                  XBox(5.dx),
                  Text(
                    homeAct == HomeAct.first
                        ? 'Daily calories'
                        : homeAct == HomeAct.second
                            ? 'Weight record'
                            : 'Food',
                    style: GoogleFonts.inter(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              homeAct == HomeAct.first
                  ? Text.rich(
                      TextSpan(
                        text: '   $_calories',
                        style: GoogleFonts.inter(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        ),
                        children: [
                          TextSpan(
                            text: ' CAL',
                            style: GoogleFonts.inter(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                              color: appColors.grey80,
                            ),
                          ),
                        ],
                      ),
                    )
                  : homeAct == HomeAct.second
                      ? Text.rich(
                        TextSpan(
                          text: '   $_weight',   //weight
                          style: GoogleFonts.inter(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                          ),
                          children: [
                            TextSpan(
                              text: ' kg',
                              style: GoogleFonts.inter(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w500,
                                color: appColors.grey80,
                              ),
                            ),
                          ],
                        ),
                      )
                      : Text.rich(
                        TextSpan(
                          text: '   0/1567 ',   //foodkcal
                          style: GoogleFonts.inter(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                          ),
                          children: [
                            TextSpan(
                              text: 'kcal',
                              style: GoogleFonts.inter(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w500,
                                color: appColors.grey80,
                              ),
                            ),
                          ],
                        ),
                      ),
            ],
          ),
        ),
        SizedBox(
          width: 169.dx,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              homeAct == HomeAct.first
                  ? Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(bottom: 20.dy),
                        child: SvgAsset(assetName: dailyCal),
                      ),
                      _recordButton(),
                    ],
                  )
                  : homeAct == HomeAct.second
                  ? Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          width: 33.dx,
                          height: 15.dy,
                          alignment: Alignment.center,
                          margin: EdgeInsets.only(right: 26.dx),
                          decoration: BoxDecoration(
                            color: appColors.green,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(
                            '$_weight'+'kg',
                            style: GoogleFonts.inter(
                              fontSize: 7.sp,
                              fontWeight: FontWeight.w500,
                              color: appColors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SvgAsset(assetName: weightChart),
                    _recordButton(),
                  ],
                  )
                  : Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      YBox(50.dy),
                      _recordButton(),
                    ],
                  ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _recordButton() {
    return BounceInAnimation(
      child: InkWell(
        onTap: () {
          _showExerciseDialog();
        },
        child: Container(
          height: 27.dy,
          width: 76.dx,
          decoration: BoxDecoration(
            color: appColors.yellow,
            borderRadius: BorderRadius.circular(12),
          ),
          child: AppText(
            text: 'Record',
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildText(String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20.dy).copyWith(top: 30.dy),
      child: AppText(
        isStartAligned: true,
        text: text,
        fontSize: 16.sp,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      height: 122.dy,
      width: double.infinity,
      color: appColors.white,
      padding: EdgeInsets.symmetric(horizontal: 20.dx),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            YBox(55.dy),
            Row(
              children: [
                SvgAsset(assetName: drawerIcon),
                const Spacer(),
                const Icon(CupertinoIcons.search),
                XBox(20.dx),
                const Icon(CupertinoIcons.bell),
              ],
            ),
            YBox(20.dy),
            Text(
              formatDate(DateTime.now()),
              style: GoogleFonts.inter(
                fontSize: 11.sp,
                fontWeight: FontWeight.w500,
                color: appColors.grey33,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showExerciseDialog() async {
    final TextEditingController exerciseController = TextEditingController();
    final TextEditingController caloriesController = TextEditingController();
    DateTime selectedDate = DateTime.now();

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Record Workout History'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  controller: exerciseController,
                  decoration: InputDecoration(hintText: 'Exercise Name'),
                ),
                TextField(
                  controller: caloriesController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(hintText: 'Calories'),
                ),
                SizedBox(height: 20),
                Text('Date: ${DateFormat('yyyy-MM-dd').format(selectedDate)}'),
                ElevatedButton(
                  onPressed: () async {
                    final DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: selectedDate,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101),
                    );
                    if (pickedDate != null && pickedDate != selectedDate) {
                      setState(() {
                        selectedDate = pickedDate;
                      });
                    }
                  },
                  child: Text('Pick a Date'),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: const Text('Save'),
              onPressed: () async {
                try {
                  await apiService.postWorkoutHistory(
                    exerciseController.text,
                    double.parse(caloriesController.text),
                    selectedDate,
                  );
                  await _getTrackingValue();
                  Navigator.of(context).pop(); // Close the dialog
                } catch (e) {
                  print('Error: $e');
                }
              },
            ),
          ],
        );
      },
    );
  }
}
