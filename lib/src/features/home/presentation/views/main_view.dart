import 'package:fitness_tracker_app/src/features/explore/presentation/views/explore_view.dart';
import 'package:fitness_tracker_app/src/features/home/presentation/views/home_view.dart';
import 'package:fitness_tracker_app/src/features/settings/presentation/views/setting_view.dart';
import 'package:fitness_tracker_app/src/features/statistics/presentation/views/statistics_view.dart';
import 'package:fitness_tracker_app/src/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MainView extends HookWidget {
  const MainView({super.key});

  @override
  Widget build(BuildContext context) {
    final selectedIndex = useState<int>(0);

    List<Widget> pages = const [
      HomeView(),
      ExploreView(),
      StatisticsView(),
      SettingsView(),
    ];

    return Scaffold(
      backgroundColor: appColors.lightGrey,
      body: IndexedStack(
        index: selectedIndex.value,
        children: pages,
      ),
      bottomNavigationBar: Padding(
        padding:
            EdgeInsets.symmetric(horizontal: 20.dx).copyWith(bottom: 10.dy),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(26),
          child: BottomNavigationBar(
            currentIndex: selectedIndex.value,
            onTap: (value) {
              selectedIndex.value = value;
            },
            enableFeedback: false,
            backgroundColor: appColors.white,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: appColors.green,
            unselectedItemColor: appColors.black,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            unselectedLabelStyle: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
              // color: appColors.black,
            ),
            selectedLabelStyle: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
            ),
            items: [
              BottomNavigationBarItem(
                icon: SvgPicture.asset(homeOutlined),
                label: 'Home',
                activeIcon: SvgPicture.asset(homeFilled),
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(exploreOutlined),
                label: 'Explore',
                activeIcon: SvgPicture.asset(exploreFilled),
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(statsOutlined),
                label: 'Stats',
                activeIcon: SvgPicture.asset(statsFilled),
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(settingsOutlined),
                label: 'Settings',
                activeIcon: SvgPicture.asset(settingsFilled),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
