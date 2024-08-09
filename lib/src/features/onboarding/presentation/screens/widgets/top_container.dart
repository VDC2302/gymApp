import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gymApp/src/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../shared/api/api_service.dart';

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
                  'Welcome !',
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
                          ? 'Set Your Activity Levels'
                          : '',
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(flex: 4),
                  ],
                ),
              ],
            ),
    );
  }
}
