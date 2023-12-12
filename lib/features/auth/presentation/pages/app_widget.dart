import 'package:flutter/material.dart';
import 'package:gwelcome_front/features/auth/presentation/pages/admin_page.dart';
import 'package:gwelcome_front/features/auth/presentation/pages/login_page.dart';
import 'package:gwelcome_front/features/auth/presentation/pages/search_page.dart';
import 'package:gwelcome_front/features/auth/presentation/pages/temp.dart';
import 'package:gwelcome_front/fitness_app/my_diary/mypage.dart';
import 'package:gwelcome_front/features/auth/presentation/pages/get_user_info.dart';
import 'package:gwelcome_front/fitness_app/my_diary/policy_details.dart';
import 'package:gwelcome_front/fitness_app/fitness_app_home_screen.dart';
import 'package:gwelcome_front/home_screen.dart';



class AppWidget extends StatefulWidget {
  static Map<String, Object> loggedUser = {};
  static bool isLogin = false;
  const AppWidget({super.key});

  @override
  State<AppWidget> createState() => _AppWidgetState();
}

class _AppWidgetState extends State<AppWidget> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AppWidget.isLogin ? const AdminPage() : FitnessAppHomeScreen(),
      routes: {
        MyHomePage.id: (context) => const MyHomePage(),
        LoginPage.id: (context) => const LoginPage(),
        SearchScreen.id: (context) => const SearchScreen(),
        AdminPage.id: (context) => const AdminPage(),
        TempPage.id: (context) => const TempPage(),
        MyPage.id: (context) => const MyPage(),
        UserInfo.id: (context) => const UserInfo(),
        PolicyDetails.id: (context) => const PolicyDetails(),
      },
    );
  }
}
