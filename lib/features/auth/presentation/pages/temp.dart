import 'package:flutter/material.dart';
import 'package:gwelcome_front/features/auth/presentation/components/buttons.dart';
import 'package:gwelcome_front/fitness_app/my_diary/mypage.dart';
import 'package:gwelcome_front/core/library/network_service.dart';



class TempPage extends StatefulWidget {
  static const String id = "temp";
  const TempPage({super.key});

  @override
  State<TempPage> createState() => _TempPageState();
}


class _TempPageState extends State<TempPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Flexible(
              flex: 1,
              child: TextField(
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 16,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(8),
                    ),
                  ),
                  hintText: '검색 키워드를 입력해주세요',
                ),
              ),
            ),
            SizedBox(
              width: 8,
            ),
            TextButton(
              onPressed: () {},
              child: Text('검색'),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 20),
              BuildButton(
                uri: policy_uri,
                token: "eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ7XCJtZW1iZXJJZFwiOlwiMmM5MTgwODI4YzM4YzY3ZDAxOGMzOWFlMGM5ODAwMDhcIn0iLCJpYXQiOjE3MDE3NzQ3NTcsImV4cCI6OTAwMDE3MDE3NzQ3NTd9.fWJ5eUYNlc5SLIKCQzDC_7sLcAFgfQVc9oXFcbrYyt4",
              ),
              MyButton(
                onPressed: () async{
                  Navigator.pushNamed(context, MyPage.id);
                },
                iconUrl: 'assets/images/kakaotalk_sharing_btn_small.png',
                text: "테스트용dddd",
              ),
            ],
          ),
        ),

      ),
    );
  }
}
