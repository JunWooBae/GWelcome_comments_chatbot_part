import 'package:gwelcome_front/fitness_app/fitness_app_home_screen.dart';
import 'package:flutter/widgets.dart';

// 처음화면에서 4가지 테마 보이는 화면인데,
// fitness만 보이게 설정했음

class HomeList {
  HomeList({
    this.navigateScreen,
    this.imagePath = '',
  });

  Widget? navigateScreen;
  String imagePath;

  static List<HomeList> homeList = [
    HomeList(
      imagePath: 'assets/fitness_app/fitness_app.png',
      navigateScreen: FitnessAppHomeScreen(),
    ),
  ];
}
