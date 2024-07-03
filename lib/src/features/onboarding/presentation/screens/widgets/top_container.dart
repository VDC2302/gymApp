import 'package:fitness_tracker_app/src/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class TopContainer extends StatelessWidget {
  final int currentPage;
  final PageController pageController;
  const TopContainer({
    super.key,
    required this.currentPage,
    required this.pageController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 15.dy),
      color: appColors.white,
      child: currentPage == 0
          ? Column(
              children: [
                Text(
                  'Welcome Simi !',
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'Tell us about yourself',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: appColors.grey,
                    height: 2.5,
                  ),
                ),
                Text(
                  'This helps us customize your fitness experience',
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    color: appColors.grey,
                  ),
                ),
              ],
            )
          : Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        pageController.previousPage(
                            duration: const Duration(milliseconds: 600),
                            curve: Curves.ease);
                        // print(currentPage);
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15.dx),
                        child: SvgPicture.asset(arrowLeft),
                      ),
                    ),
                    const Spacer(flex: 2),
                    Text(
                      currentPage == 1
                          ? 'How old are you ?'
                          : currentPage == 2
                              ? 'How much do you weigh ?'
                              : currentPage == 3
                                  ? 'What is your height ?'
                                  : currentPage == 4
                                      ? 'Please select your Goals'
                                      : currentPage == 5
                                          ? 'What is your physical activity level ?'
                                          : currentPage == 6
                                              ? 'You\'re all set now you can move'
                                              : '',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(flex: 3),
                  ],
                ),
                YBox(10.dy),
                Text(
                  currentPage == 1
                      ? 'This helps us customize your fitness experience'
                      : currentPage == 2
                          ? 'This helps us customize your fitness experience'
                          : currentPage == 3
                              ? 'This helps us customize your fitness experience'
                              : currentPage == 4
                                  ? '    You can select more than one\n     you can also make changes later'
                                  : currentPage == 5
                                      ? 'You can select only one\nyou can also make changes later'
                                      : currentPage == 6
                                          ? '     Weldon! you have earned your\n    first move mint'
                                          : '',
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    color: appColors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
    );
  }
}
