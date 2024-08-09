import 'package:flutter_svg/flutter_svg.dart';
import 'package:gymApp/src/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../shared/api/api_service.dart';
import 'NutritionForm.dart';

enum MealType { breakfast, lunch, afternoon, dinner }

enum HealthyRecipe { first, second, third }

enum NutrientType { calories, protein, fat, carbohydrates }

class Nutrition extends StatefulWidget {
  final VoidCallback? onFetchData;
  const Nutrition({super.key, this.onFetchData});

  @override
  _NutritionState createState() => _NutritionState();
}

class _NutritionState extends State<Nutrition> {
  bool isLoading = true;
  late Future<Map<MealType, double>> _todayMealDataFuture;
  late Future<Map<NutrientType, double>> _thisWeekNutrientFuture;

  @override
  void initState() {
    super.initState();
    fetchData();
    widget.onFetchData?.call();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    fetchData();
  }

  void fetchData() {
    setState(() {
      isLoading = true;
    });


    Future<Map<MealType, double>> _getTodayMealData() async {
      ApiService apiService = ApiService();
      List<Map<String, dynamic>> mealData = await apiService
          .getUserTodayMeal() ?? [];

      Map<MealType, double> todayCalories = {
        MealType.breakfast: mealData.firstWhere(
              (meal) => meal['meal'] == 'BREAKFAST',
          orElse: () => {'calories': 0.0},
        )['calories'] as double,
        MealType.lunch: mealData.firstWhere(
              (meal) => meal['meal'] == 'LUNCH',
          orElse: () => {'calories': 0.0},
        )['calories'] as double,
        MealType.afternoon: mealData.firstWhere(
              (meal) => meal['meal'] == 'AFTERNOON',
          orElse: () => {'calories': 0.0},
        )['calories'] as double,
        MealType.dinner: mealData.firstWhere(
              (meal) => meal['meal'] == 'DINNER',
          orElse: () => {'calories': 0.0},
        )['calories'] as double,
      };
      return todayCalories;
    }

    Future<Map<NutrientType, double>> _getThisWeekNutrientData() async {
      ApiService apiService = ApiService();
      Map<String, dynamic> thisWeekData = await apiService
          .getThisWeekNutrition();

      return {
        NutrientType.calories: thisWeekData['weeklyCalories'] ?? 0.0,
        NutrientType.protein: thisWeekData['weeklyProtein'] ?? 0.0,
        NutrientType.fat: thisWeekData['weeklyFat'] ?? 0.0,
        NutrientType.carbohydrates: thisWeekData['weeklyCarbohydrates'] ?? 0.0,
      };
    }

    _todayMealDataFuture = _getTodayMealData();
    _thisWeekNutrientFuture = _getThisWeekNutrientData();


    Future.wait([_todayMealDataFuture, _thisWeekNutrientFuture]).then((_) {
      setState(() {
        isLoading = false;
      });
    }).catchError((error) {
      setState(() {
        isLoading = false;
      });
      // Handle the error if needed
      print('Error: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appColors.lightGrey,
      floatingActionButton: FloatingActionButton(
        onPressed: fetchData, // Call the method to refresh the data
        child: const Icon(Icons.refresh),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : FutureBuilder<Map<MealType, double>>(
        future: _todayMealDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            Map<MealType, double> todayCalories = snapshot.data ?? {};

            return FutureBuilder<Map<NutrientType, double>>(
              future: _thisWeekNutrientFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  Map<NutrientType, double> thisWeekNutrients =
                      snapshot.data ?? {};


                  return SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15.dx),
                    child: Column(
                      children: [
                        SparkleContainer(
                          height: 170.dy,
                          isBgWhite: true,
                          padding: EdgeInsets.all(10.dx),
                          decoration: BoxDecoration(
                            color: appColors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(bottom: 25.dy),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment
                                      .spaceBetween,
                                  children: [
                                    Text.rich(
                                      TextSpan(
                                        text: 'NUTRIENT',
                                        style: GoogleFonts.inter(
                                          fontSize: 20.sp,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    SvgAsset(assetName: nutrientCycle)
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(right: 5.dx),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _nutrientCycleRow(NutrientType.calories,
                                        thisWeekNutrients[NutrientType
                                            .calories] ?? 0.0),
                                    YBox(6.dy),
                                    _nutrientCycleRow(NutrientType.protein,
                                        thisWeekNutrients[NutrientType
                                            .protein] ?? 0.0),
                                    YBox(6.dy),
                                    _nutrientCycleRow(NutrientType.fat,
                                        thisWeekNutrients[NutrientType.fat] ??
                                            0.0),
                                    YBox(6.dy),
                                    _nutrientCycleRow(
                                        NutrientType.carbohydrates,
                                        thisWeekNutrients[NutrientType
                                            .carbohydrates] ?? 0.0),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        _buildHeaderText('Today Meals'),
                        SparkleContainer(
                          height: 75.dy,
                          isBgWhite: true,
                          decoration: BoxDecoration(
                            color: appColors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: _todayMealsContent(
                            MealType.breakfast,
                            todayCalories[MealType.breakfast] ?? 0.0,
                          ),
                        ),
                        YBox(15.dy),
                        SparkleContainer(
                          height: 75.dy,
                          decoration: BoxDecoration(
                            color: appColors.green,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: _todayMealsContent(
                            MealType.lunch,
                            todayCalories[MealType.lunch] ?? 0.0,
                          ),
                        ),
                        YBox(15.dy),
                        SparkleContainer(
                          height: 75.dy,
                          decoration: BoxDecoration(
                            color: appColors.grey33,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: _todayMealsContent(
                            MealType.afternoon,
                            todayCalories[MealType.afternoon] ?? 0.0,
                          ),
                        ),
                        YBox(15.dy),
                        SparkleContainer(
                          height: 75.dy,
                          decoration: BoxDecoration(
                            color: appColors.black,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: _todayMealsContent(
                            MealType.dinner,
                            todayCalories[MealType.dinner] ?? 0.0,
                          ),
                        ),
                        _buildHeaderText('Healthy recipes'),
                        SparkleContainer(
                          height: 148.dy,
                          isBgWhite: true,
                          decoration: BoxDecoration(
                            color: appColors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: _healthRecipeContent(HealthyRecipe.first),
                        ),
                        YBox(15.dy),
                        SparkleContainer(
                          height: 148.dy,
                          isBgWhite: true,
                          decoration: BoxDecoration(
                            color: appColors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: _healthRecipeContent(HealthyRecipe.second),
                        ),
                        YBox(15.dy),
                        SparkleContainer(
                          height: 148.dy,
                          isBgWhite: true,
                          decoration: BoxDecoration(
                            color: appColors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: _healthRecipeContent(HealthyRecipe.third),
                        ),
                        YBox(30.dy),
                      ],
                    ),
                  ),
                  );
                }
                },
            );
          }
          },
      ),
    );
  }

  Widget _nutrientCycleRow(NutrientType nutrientType, double value) {
    return Row(
      children: [
        Container(
          height: 6.25.dx,
          width: 6.25.dx,
          decoration: BoxDecoration(
            color: nutrientType == NutrientType.protein
                ? appColors.yellow
                : nutrientType == NutrientType.calories
                ? appColors.green
                : appColors.black,
            shape: BoxShape.circle,
          ),
        ),
        XBox(10.dx),
        AppText(
          text: nutrientType == NutrientType.protein
              ? 'Proteins: $value'
              : nutrientType == NutrientType.calories
              ? 'Calories: $value'
              : nutrientType == NutrientType.fat
              ? 'Fats: $value'
              : 'Carbohydrates: $value',
          fontSize: 15.sp,
          fontWeight: FontWeight.w500,
        ),
      ],
    );
  }

  Widget _healthRecipeContent(HealthyRecipe healthyRecipe) {
    return Padding(
      padding: EdgeInsets.all(12.dx),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppText(
                text: healthyRecipe == HealthyRecipe.first
                    ? 'Chicken & spinach\nSkillet'
                    : healthyRecipe == HealthyRecipe.second
                    ? 'Rice and vegetable\nsauce'
                    : 'Fruity splash\n  ',
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 20.dy),
                child: AppText(
                  text: healthyRecipe == HealthyRecipe.first
                      ? 'High protein\nmeal'
                      : healthyRecipe == HealthyRecipe.second
                      ? 'Balanced carbs\nmeal'
                      : 'Vitamin packed\nmeal',
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppText(
                  text: healthyRecipe == HealthyRecipe.first
                      ? '15%Proteins'
                      : healthyRecipe == HealthyRecipe.second
                      ? '15%Proteins'
                      : '0%Proteins',
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                ),
                YBox(3.dy),
                AppText(
                  text: healthyRecipe == HealthyRecipe.first
                      ? '10%Carbs'
                      : healthyRecipe == HealthyRecipe.second
                      ? '40%Carbs'
                      : '50%Vitamins',
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                ),
                YBox(3.dy),
                AppText(
                  text: healthyRecipe == HealthyRecipe.first
                      ? '13%Fat'
                      : healthyRecipe == HealthyRecipe.second
                      ? '10%Fat'
                      : '2%Fat',
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _todayMealsContent(MealType mealType, double calories) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.dx),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(
                text: mealType == MealType.breakfast
                    ? 'BREAKFAST'
                    : mealType == MealType.lunch
                    ? 'LUNCH'
                    : mealType == MealType.afternoon
                    ? 'AFTERNOON'
                    : 'DINNER',
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: mealType != MealType.breakfast ? appColors.white : null,
              ),
              Text.rich(
                TextSpan(
                  text: calories.toString(),
                  style: GoogleFonts.inter(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                    color: mealType != MealType.breakfast
                        ? appColors.white
                        : null,
                  ),
                  children: [
                    TextSpan(
                      text: ' CAL',
                      style: GoogleFonts.inter(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600,
                        color: mealType == MealType.dinner ||
                            mealType == MealType.lunch ||
                            mealType == MealType.afternoon
                            ? appColors.white
                            : appColors.grey80,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(right: 10.dx),
            child: SvgAsset(
              assetName: arrowDown,
              color: mealType != MealType.breakfast ? appColors.white : null,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderText(String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20.dy),
      child: AppText(
        isStartAligned: true,
        text: text,
        fontSize: 16.sp,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}