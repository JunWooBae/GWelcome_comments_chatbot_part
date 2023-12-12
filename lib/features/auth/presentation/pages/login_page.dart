import 'package:flutter/material.dart';
import 'package:gwelcome_front/features/auth/presentation/pages/get_user_info.dart';
import 'package:gwelcome_front/features/auth/presentation/pages/temp.dart';
import 'package:gwelcome_front/core/library/network_service.dart';
import 'package:gwelcome_front/home_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


import 'package:url_launcher/url_launcher.dart';
import '../components/buttons.dart';

String email="";

class LoginPage extends StatefulWidget {
  static const String id = "login_page";
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();

}



void launchNaverLogin() async {
  final url = Uri.parse('https://nid.naver.com/oauth2.0/authorize?response_type=code&client_id=7K1bRtXjCC5KofKOhmqB&redirect_uri=http://ec2-3-39-142-226.ap-northeast-2.compute.amazonaws.com:8080/login/oauth2/code/naver&state=RAMDOM_STATE');
  if (await canLaunchUrl(url)) {
    await launchUrl(url);
    //인증 후 로직
  } else {
    throw 'Could not launch $url';
  }
}

Map<String, dynamic> TokenData = {};

void launchKakaoLogin() async {
  final url = Uri.parse(Kakao_uri);
  if (await canLaunchUrl(url)) {
    await launchUrl(url);
    var response = await http.get(url);
    if (response.statusCode==200){
      var jsonData = json.decode(response.body);
      TokenData = jsonData['data'];
      Tokens.setTokens(TokenData['atk'], TokenData['rtk']);
    }
  } else {
    throw 'Could not launch $url';
  }
}


class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
         child: Column(
          children: [
            const SizedBox(
              width: 100,
              height: 70,
            ),
            const Center(
              child: Text(
                "청년들을 위한 복지 서비스\nGwelcome",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30,
                ),
              ),
            ),

              Image.asset('assets/images/gbear.png'),
              Column(
                  children:  [
                    MyButtonNaver(
                      onPressed: () async {
                        Navigator.pushNamed(context, TempPage.id);
                      },
                      iconUrl: 'assets/images/naver.png',
                      text: "네이버 계정으로 시작하기",
                    ),
                    SizedBox(height: 20),
                    MyButtonKakao(
                      onPressed: () async{
                        launchKakaoLogin();
                        if (TokenData.containsKey('email')) {
                          email = TokenData['email'];
                          Navigator.pushNamed(context, UserInfo.id);
                        } else{
                          Navigator.pushNamed(context, MyHomePage.id);
                        }
                      },
                      iconUrl: 'assets/images/kakaotalk_sharing_btn_small.png',
                      text: "카카오 계정으로 시작하기",
                    ),
                    // SizedBox(height: 20),

                  ],
              ),
            const SizedBox(height: 20),
          ],
        ),
      ),
      )
    );
  }
}
