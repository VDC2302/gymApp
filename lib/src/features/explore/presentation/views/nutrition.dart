import 'package:gymApp/src/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../shared/api/api_service.dart';

enum MealType { breakfast, lunch, dinner }

enum HealthyRecipe { first, second, third }

enum NutrientCycle { protein, carbs, fat }

class Nutrition extends StatefulWidget {
  const Nutrition({super.key});

  @override
  _NutritionState createState() => _NutritionState();
}

class _NutritionState extends State<Nutrition>{
  late Future<List<Map<String, dynamic>>> _mealDataFuture;

  @override
  void initState() {
    super.initState();
    _mealDataFuture = _fetchMealData();
  }

  Future<List<Map<String, dynamic>>> _fetchMealData() async {
    ApiService apiService = ApiService();
    return await apiService.getUserMeal();
  }


  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _mealDataFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          List<Map<String, dynamic>> mealData = snapshot.data ?? [];

          double? breakfastCalories = mealData.firstWhere(
                (meal) => meal['meal'] == 'BREAKFAST',
            orElse: () => {'calories': 0.0},
          )['calories'];

          double? lunchCalories = mealData.firstWhere(
                (meal) => meal['meal'] == 'LUNCH',
            orElse: () => {'calories': 0.0},
          )['calories'];

          double? dinnerCalories = mealData.firstWhere(
                (meal) => meal['meal'] == 'DINNER',
            orElse: () => {'calories': 0.0},
          )['calories'];


          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.dx),
              child: Column(
                children: [
                  SparkleContainer(
                    height: 148.dy,
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text.rich(
                                TextSpan(
                                  text: 'NUTRIENT\n',
                                  style: GoogleFonts.inter(
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: 'CYCLE',
                                      style: GoogleFonts.inter(
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              AppText(
                                text: 'Close your rings\nto earn tokens',
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w400,
                              )
                            ],
                          ),
                        ),
                        Center(
                            child: Padding(
                              padding: EdgeInsets.only(right: 12.dx),
                              child: SvgAsset(assetName: nutrientCycle),
                            )),
                        Padding(
                          padding: EdgeInsets.only(right: 10.dx),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _nutrientCycleRow(NutrientCycle.protein),
                              YBox(6.dy),
                              _nutrientCycleRow(NutrientCycle.carbs),
                              YBox(6.dy),
                              _nutrientCycleRow(NutrientCycle.fat),
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
                      breakfastCalories!,
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
                      MealType.lunch,
                      lunchCalories!,
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
                      MealType.dinner,
                      dinnerCalories!,
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

  Widget _nutrientCycleRow(NutrientCycle nutrientCycle) {
    return Row(
      children: [
        Container(
          height: 6.25.dx,
          width: 6.25.dx,
          decoration: BoxDecoration(
            color: nutrientCycle == NutrientCycle.protein
                ? appColors.yellow
                : nutrientCycle == NutrientCycle.carbs
                    ? appColors.green
                    : appColors.black,
            shape: BoxShape.circle,
          ),
        ),
        XBox(10.dx),
        AppText(
          text: nutrientCycle == NutrientCycle.protein
              ? 'Proteins'
              : nutrientCycle == NutrientCycle.carbs
                  ? 'Carbs'
                  : 'Fats',
          fontSize: 12.sp,
          fontWeight: FontWeight.w400,
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
                    : 'DINNER',
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: mealType != MealType.breakfast ? appColors.white : null,
              ),
              Text.rich(
                  TextSpan(
                    text: calories.toString() ?? '0',
                    style: GoogleFonts.inter(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                      color: mealType != MealType.breakfast ? appColors.white : null,
                    ),
                      children: [
                        TextSpan(
                          text: ' CAL',
                          style: GoogleFonts.inter(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w600,
                            color: mealType == MealType.dinner || mealType == MealType.lunch
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
