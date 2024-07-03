const String baseSvgPath = 'assets/svgs/';
const String basePngPath = 'assets/pngs/';
const String baseJsonPath = 'assets/json/';
const String baseJpgPath = 'assets/jpgs/';

extension ImageExtension on String {
  // png paths
  String get png => '$basePngPath$this.png';
  // jpg paths
  String get jpg => '$baseJpgPath$this.jpg';
  // svg paths
  String get svg => '$baseSvgPath$this.svg';
  // json paths
  String get json => '$baseJsonPath$this.json';
}

//? JPGS
final String splashImage = 'splash-bg'.jpg;

//? SVGS
final String shoeIcon = 'shoe-icon'.svg;
final String appleIcon = 'apple-icon'.svg;
final String googleIcon = 'google-icon'.svg;
final String facebookIcon = 'facebook-icon'.svg;
final String trophyIcon = 'trophy-icon'.svg;
final String sparkleEffect = 'sparkle-effect'.svg;
final String arrowLeft = 'arrow-left'.svg;
final String arrowRight = 'arrow-right'.svg;
final String arrowDown = 'arrow-down'.svg;

final String homeOutlined = 'home-outlined'.svg;
final String homeFilled = 'home-filled'.svg;
final String exploreOutlined = 'explore-outlined'.svg;
final String exploreFilled = 'explore-filled'.svg;
final String statsOutlined = 'stats-outlined'.svg;
final String statsFilled = 'stats-filled'.svg;
final String settingsOutlined = 'settings-outlined'.svg;
final String settingsFilled = 'settings-filled'.svg;
//Settings screen
final String drawerIcon = 'drawer-icon'.svg;
final String globeIcon = 'globe-icon'.svg;
final String watchIcon = 'watch-icon'.svg;
final String themeIcon = 'theme-icon'.svg;
//Statistics
final String selector = 'selector'.svg;
final String calendarIcon = 'calendar-icon'.svg;
final String caloriesBurned = 'calories-burned'.svg;
final String historyWeight = 'history-weight'.svg;
final String kgIcon = 'kgIcon'.svg;
final String diagonalArrows = 'diagonalArrows'.svg;
final String footsteps = 'footsteps'.svg;
final String stepProgress = 'stepProgress'.svg;
final String weightLossGraph = 'weightLossGraph'.svg;
final String bmiLine = 'bmiLine'.svg;
//Explore
final String timerIcon = 'timer-icon'.svg;
final String nutrientCycle = 'nutientCycle'.svg;
final String quickBurst = 'quickBurst'.svg;
final String excersiceSet = 'excersiceSet'.svg;
//Home
final String stagChart = 'stag-chart'.svg;
final String dailyCal = 'daily-cal'.svg;
final String dailySteps = 'dailty-steps'.svg;
final String weightChart = 'weight-chart'.svg;
final String fireIcon = 'fire-icon'.svg;
final String stepsIcon = 'steps-icon'.svg;
final String weightIcon = 'weight-icon'.svg;
final String foodIcon = 'food-icon'.svg;
final String addIcon = 'addIcon'.svg;
final String doublePlay = 'double-play'.svg;
final String nrcIcon = 'nrc'.svg;

//? PNGS
final String sparkleEffectSmall = 'sparkle-effect-small'.png;
