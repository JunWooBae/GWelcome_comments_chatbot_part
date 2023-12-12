import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:gwelcome_front/core/library/network_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';




String email = "asdf";

class UserInfo extends StatefulWidget {
  static const String id = "user_info";
  const UserInfo({super.key});

  @override
  State<UserInfo> createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo> {
  Map<String, dynamic> profileData = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                children: [
                  SizedBox(height: 80),
                  Text(
                    '청년들을 위한 복지 서비스',
                    style: TextStyle(
                      fontSize: 30,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    'Gwelcome',
                    style: TextStyle(
                      fontSize: 40,
                      color: Color(0xFFFFB906),
                    ),
                  ),
                  Text(
                    '에 오신 것을 환영합니다.',
                    style: TextStyle(
                      fontSize: 30,
                      color: Colors.black,
                    ),
                  ),
                  ClipOval(
                    child: Image.asset(
                      'assets/images/gbear.png',
                      width: 150,
                      height: 150,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SelectionButton<String>(
                    options: ['남자', '여자'],
                    initialButtonText: '성별',
                    profileData: profileData,
                    dataKey: 'gender',
                    onOptionSelected: () => setState(() {}),
                  ),
                  SizedBox(height: 15,),
                  SelectionButton<String>(
                    options: ['18', '19', '20', '21', '22', '23', '24', '25', '26', '27', '28', '29', '30'],
                    initialButtonText: '만 나이',
                    profileData: profileData,
                    dataKey: 'age',
                    onOptionSelected: () => setState(() {}),
                  ),
                  SizedBox(height: 15,),
                  SelectionButton<String>(
                    options: ['고양시', '과천시', '광명시', '광주시', '성남시'],
                    initialButtonText: '주거지역',
                    profileData: profileData,
                    dataKey: 'livingArea',
                    onOptionSelected: () => setState(() {}),
                  ),
                  SizedBox(height: 15,),
                  SelectionButton<String>(
                    options: ['일자리분야', '주거분야', '복지분야', '교육분야', '문화분야'],
                    initialButtonText: '관심분야',
                    profileData: profileData,
                    dataKey: 'interests',
                    onOptionSelected: () => setState(() {}),
                  ),
                  SizedBox(height: 15,),
                  SizedBox(
                    width: 400, height: 70,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFFFB910),
                      ),
                      onPressed: (){
                        profileData['email'] = email;
                        print(profileData);
                        sendData(profileData);
                        },
                      child: Text('입력하기',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
      ),


    );
  }
}


class SelectionButton<T> extends StatefulWidget {
  final List<T> options;
  final String initialButtonText;
  final Map<String, dynamic> profileData;
  final String dataKey;
  final Function() onOptionSelected;

  SelectionButton({
    Key? key,
    required this.options,
    required this.initialButtonText,
    required this.profileData,
    required this.dataKey,
    required this.onOptionSelected,
  }) : super(key: key);

  @override
  _SelectionButtonState<T> createState() => _SelectionButtonState<T>();
}

class _SelectionButtonState<T> extends State<SelectionButton<T>> {
  late String buttonText;

  @override
  void initState() {
    super.initState();
    buttonText = widget.initialButtonText; // Set initial button text
  }

  void _showDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: ListBody(
              children: widget.options.map((option) => ListTile(
                title: Text(option.toString()),
                onTap: () {
                  setState(() {
                    buttonText = option.toString(); // Update button text
                    widget.profileData[widget.dataKey] = option;
                  });
                  widget.onOptionSelected();
                  Navigator.of(context).pop();
                },
              )).toList(),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 400, height: 70,
      child: ElevatedButton(
        onPressed: () => _showDialog(context),
        child: Text(buttonText,
          style: TextStyle(
          fontSize: 20,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}

Future<void> sendData(Map<String, dynamic> profileData) async {
  var url = Uri.parse(Userinfo_uri);

  try {
    var response = await http.post(
      url,
      body: json.encode(profileData),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${Tokens.accessToken}', // 전역 토큰 변수 사용
      },
    );
    if (response.statusCode == 200) {
      print("Data sent successfully");
    } else {
      print("Error sending data: ${response.statusCode}");
    }
  } catch (e) {
    print("Exception caught: $e");
  }
}