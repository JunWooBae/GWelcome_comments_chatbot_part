import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../fitness_app_home_screen.dart';

class EntireChatBotScreen extends StatefulWidget {
  const EntireChatBotScreen({Key? key, this.animationController}) : super(key: key);
  final AnimationController? animationController;
  // const EntireChatBotScreen({super.key});

  @override
  State<EntireChatBotScreen> createState() => _EntireChatBotScreenState();
}

class _EntireChatBotScreenState extends State<EntireChatBotScreen> {
  final List<Map<String, String>> messages = [];
  final TextEditingController textEditingController = TextEditingController();
  final String _jwtToken = 'eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ7XCJtZW1iZXJJZFwiOlwiMmM5MTgwODI4YzU3ZTQ1YTAxOGM1ZTQ3NThhMzAwMDBcIn0iLCJpYXQiOjE3MDIzODg3ODMsImV4cCI6OTAwMDE3MDIzODg3ODN9.iUO6035wku0Ig8u96Lmr39Q8LTMk4dWHBZ-iRSeYQog';

  // 서버에서 초기 문구를 가져오는 함수
  Future<void> fetchInitialMessage() async {
    try {
      final response = await http.get(Uri.parse('https://gwelcomebackend.site/api/chat/server'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_jwtToken',
        },);
      if (response.statusCode == 200) {
        final responseBody = json.decode(utf8.decode(response.bodyBytes));
        final ChatBotInitialData initialData = ChatBotInitialData.fromJson(responseBody);
        setState(() {
          messages.add({"type": "bot", "text": initialData.data});
        });
      } else {
        print('Failed to fetch initial message: ${response.statusCode}');
      }
    } catch (e) {
      print('Error occurred while fetching initial message: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchInitialMessage(); // 챗봇 화면 로드 시 초기 문구를 가져옴
  }


  // 경기웰컴 정책 20개 전체 학습한(덜떨어지는) gpt 호출 + 메시지 post 하는 함수
  Future<void> sendQuestionToServer(String question) async {
    try {
      final response = await http.post(
        Uri.parse('https://gwelcomebackend.site/api/chat/server'),
        headers: {'Content-Type': 'application/json',
                  'Authorization': 'Bearer $_jwtToken',
        },
        body: jsonEncode({
          'question': question
        }),
      );

      if (response.statusCode == 200) {
        final responseBody = json.decode(utf8.decode(response.bodyBytes));
        debugPrint(responseBody.toString());
        final ServerChatResponse chatResponse = ServerChatResponse.fromJson(responseBody);
        if (chatResponse.status == 200) {
          setState(() {
            messages.add({'type': 'bot', 'text': chatResponse.answer});
          });
        } else {
          print('Error: Invalid response from server');
        }
      } else {
        print('Failed to fetch response: ${response.statusCode}');
      }
    } catch (e) {
      print('Error occurred while sending question: $e');
    }
  }





  // sendMessage 함수(종속 사용)
  void sendMessage() {
    final text = textEditingController.text;
    if (text.trim().isNotEmpty) {
      setState(() {
        messages.add({'type': 'user', 'text': text});
      });
      sendQuestionToServer(text);
      textEditingController.clear();
    }
  }

  // 화면 ui 구성 부분
  Widget buildMessage(Map<String, String> message) {
    bool isUserMessage = message['type'] == 'user';

    return Row(
      mainAxisAlignment:
      isUserMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: <Widget>[
        if (!isUserMessage)
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: CircleAvatar(child: Text('G bot')),
          ),
        ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.8, // 최대 너비를 화면의 80%로 설정
          ),
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 14),
            decoration: BoxDecoration(
              color: isUserMessage ? Colors.blue[300] : Colors.grey[200],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              message["text"] ?? "",
              style: TextStyle(
                color: isUserMessage ? Colors.white : Colors.black,
              ),
              softWrap: true, // 자동 줄바꿈 활성화
            ),
          ),
        ),
      ],
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // 현재 화면을 FitnessAppHomeScreen으로 대체
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => FitnessAppHomeScreen()),
            );
          },
        ),
        title: Text('챗봇 상담'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                return buildMessage(message);
              },
            )
            ,
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: TextField(
                  controller: textEditingController,
                  decoration: InputDecoration(
                    hintText: "여기에 메시지를 입력하세요.",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.send),
                onPressed: sendMessage,
              ),
            ],
          ),
        ],
      ),
    );
  }

}



// 챗봇 초기 데이터 가져오기 데이터모델링
class ChatBotInitialData {
  final String data;

  ChatBotInitialData({required this.data});

  factory ChatBotInitialData.fromJson(Map<String, dynamic> json) {
    return ChatBotInitialData(
      data: json['data'] as String,
    );
  }
}

// 정책 20개 학습한 gpt 데이터 모델링
class ServerChatResponse {
  final int status;
  final String answer;

  ServerChatResponse({required this.status, required this.answer});

  factory ServerChatResponse.fromJson(Map<String, dynamic> json) {
    return ServerChatResponse(
      status: json['status'] as int,
      answer: json['data']['answer'] as String,
    );
  }
}

