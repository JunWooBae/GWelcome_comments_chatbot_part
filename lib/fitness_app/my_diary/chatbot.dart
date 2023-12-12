import 'package:flutter/material.dart';
import 'package:gwelcome_front/features/auth/presentation/components/buttons.dart';
import 'package:gwelcome_front/fitness_app/my_diary/policy_details.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ChatBotScreen extends StatefulWidget {
  static const String id = "policy_details_id";
  static const String title = "policy_details_title";
  const ChatBotScreen({super.key});

  @override
  _ChatBotScreenState createState() => _ChatBotScreenState();
}

class _ChatBotScreenState extends State<ChatBotScreen> {
  String id = policy_id_now;
  String title = policy_title_now;


  final List<Map<String, dynamic>> messages = [];
  final TextEditingController textEditingController = TextEditingController();
  final String _jwtToken = 'eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ7XCJtZW1iZXJJZFwiOlwiMmM5MTgwODI4YzU3ZTQ1YTAxOGM1ZTQ3NThhMzAwMDBcIn0iLCJpYXQiOjE3MDIzODg3ODMsImV4cCI6OTAwMDE3MDIzODg3ODN9.iUO6035wku0Ig8u96Lmr39Q8LTMk4dWHBZ-iRSeYQog';

  @override
  void initState() {
    super.initState();
    messages.add({
      "type": "bot",
      "text": "어서오세요. ${} 대해 상세한 상담이 가능합니다. 궁금하신 부분에 대해 질문해주세요."
    });
  }


  // ◈◈◈ 경기웰컴 상세정책전용 gpt 호출 + 메시지 post 하는 함수
  Future<void> sendQuestionToServer(String policyName, String question) async {
    try {
      final response = await http.post(
        Uri.parse('https://gwelcomebackend.site/api/chat/button'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_jwtToken'
        },
        body: jsonEncode({
          'policy_name': policyName,
          'question': question
        }),
      );

      if (response.statusCode == 200) {
        final responseBody = json.decode(utf8.decode(response.bodyBytes));
        debugPrint("!!!");
        debugPrint(responseBody.toString());
        final ChatResponse chatResponse = ChatResponse.fromJson(responseBody);

        if (chatResponse.status == 200) { // 여기를 수정했습니다.
          setState(() {
            messages.add({"type": "bot", "text": chatResponse.answer});
          });
        } else {
          setState(() {
            messages.add({"type": "bot", "text": "Error: Invalid response from server"});
          });
        }
      } else {
        print('Failed to fetch response: ${response.statusCode}');
      }
    } catch (e) {
      print('Error occurred while sending question: $e');
      setState(() {
        messages.add({"type": "bot", "text": "Error: Exception - ${e.toString()}"});
      });
    }
  }


  // ◈◈◈ top3 답변 post 하는 함수 + 답변 받아오는 함수
  Future<void> fetchSimilarQuestions(int policyId, String question) async {
    try {
      final response = await http.post(
        Uri.parse('https://gwelcomebackend.site/api/chat/top3'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_jwtToken',
        },
        body: jsonEncode({
          'policy_id': policyId,
          'question': question
        }),
      );

      if (response.statusCode == 200) {
        final responseBody = json.decode(utf8.decode(response.bodyBytes));
        debugPrint("@@@");
        debugPrint(responseBody.toString());
        final SimilarQuestionsResponse similarQuestionsResponse = SimilarQuestionsResponse.fromJson(responseBody);

        if (similarQuestionsResponse.status == 200) {
          setState(() {
            // 먼저 안내 메시지를 추가합니다.
            messages.add({
              "type": "text",
              "text": "사용자 질문과 관련된 top 3 질문입니다",
            });
            // 이후 버튼 목록을 추가합니다.
            messages.add({
              "type": "buttons",
              "options": similarQuestionsResponse.similarQuestions,
            });
          });
        } else {
          print('Error: Invalid response from server');
        }
      } else {
        print('Failed to fetch similar questions: ${response.statusCode}');
      }
    } catch (e) {
      print('Error occurred while fetching similar questions: $e');
    }
  }

  // ◈◈◈ 새로운 질문에 대한 답변을 요청하는 함수
  Future<void> sendAnswerRequest(int policyId, String question) async {
    try {
      final response = await http.post(
        Uri.parse('https://gwelcomebackend.site/api/chat/answer'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_jwtToken',
        },
        body: jsonEncode({
          'policy_id': policyId,
          'question': question,
        }),
      );

      if (response.statusCode == 200) {
        final responseBody = json.decode(utf8.decode(response.bodyBytes));
        debugPrint("###");
        debugPrint(responseBody.toString());
        final AnswerResponse answerResponse = AnswerResponse.fromJson(responseBody);

        if (answerResponse.status == 200) { // 수정된 부분
          setState(() {
            messages.add({"type": "bot", "text": answerResponse.answer});
          });
        } else {
          print('Error: Invalid response from server');
        }
      } else {
        print('Failed to fetch response: ${response.statusCode}');
      }
    } catch (e) {
      print('Error occurred while sending request: $e');
      debugPrint('Response body parsing failed'); // 에러가 발생했을 때 출력됩니다.
    }
  }


  // ♣♣♣ 챗봇 최상위 함수(모함수) ♣♣♣
  void sendMessage() {
    final text = textEditingController.text;
    if (text.trim().isNotEmpty) {
      setState(() {
        messages.add({"type": "user", "text": text});
      });
      int policyId = int.tryParse(policy_id_now) ?? 0; // String을 int로 변환. 변환 실패시 0을 기본값으로 사용
      sendQuestionToServer(title, text); //★★★★★★★★ 반드시 title 전역변수 처리해야함

      fetchSimilarQuestions(policyId, text); /////★★★★★★★ 반드시 id 전역변수 처리해야함
      textEditingController.clear();
    }
  }


  // 화면 ui 구성 부분
  Widget buildMessage(Map<String, dynamic> message) {
    int policyId = int.tryParse(policy_id_now) ?? 0;
    // 메시지가 버튼 목록인 경우
    if (message["type"] == "buttons") {
      List<String> options = List<String>.from(message["options"]);
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0), // 좌우 패딩 설정
        child: Wrap(
          alignment: WrapAlignment.center,
          spacing: 8.0, // 버튼 사이의 간격
          runSpacing: 8.0, // 줄 사이의 간격
          children: options.map<Widget>((option) {
            return ElevatedButton(
              onPressed: () {
                sendAnswerRequest(policyId, option); // ##################################### id 전역변수 반드시 필요
              },
              child: Text(option),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(350, 60), // 버튼의 최소 크기
                maximumSize: Size(350, 100), // 버튼의 최대 크기
              ),
            );
          }).toList(),
        ),
      );
    }
    // top 3 버튼 메시지 전에  일반 텍스트 메시지 처리
    if (message["type"] == "text") {
      return Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          width: double.infinity, // 컨테이너를 화면 너비에 맞게 확장
          decoration: BoxDecoration(
            color: Colors.lightBlue[50], // 배경색 설정 (옵션)
            borderRadius: BorderRadius.circular(10), // 모서리 둥글게 (옵션)
          ),
          padding: const EdgeInsets.all(8.0), // 내부 패딩
          child: Text(
            message["text"],
            textAlign: TextAlign.center, // 텍스트를 중앙 정렬
            style: TextStyle(
              color: Colors.black, // 텍스트 색상 (옵션)
              // 추가적인 텍스트 스타일링을 적용할 수 있습니다.
            ),
          ),
        ),
      );
    }
    // 일반 텍스트 메시지 처리
    bool isUserMessage = message["type"] == "user";
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
        title: Text('챗봇 상담'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(

            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) => buildMessage(messages[index]),
            ),
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

// 경기웰컴 지피티 상세정책 데이터 가져오기 데이터모델링
class ChatResponse {
  final int status;
  final String answer;

  ChatResponse({required this.status, required this.answer});

  factory ChatResponse.fromJson(Map<String, dynamic> json) {
    var data = json['data'] as Map<String, dynamic>? ?? {};
    return ChatResponse(
      status: json['status'] as int,
      answer: data['answer'] as String,
    );
  }
}

// top3 답변 데이터모델링
class SimilarQuestionsResponse {
  final int status;
  final List<String> similarQuestions;

  SimilarQuestionsResponse({required this.status, required this.similarQuestions});

  factory SimilarQuestionsResponse.fromJson(Map<String, dynamic> json) {
    var data = json['data'] as Map<String, dynamic>? ?? {};
    var questions = data['similar_questions'] as List<dynamic>? ?? [];
    return SimilarQuestionsResponse(
      status: json['status'] as int,
      similarQuestions: questions.map((q) => q as String).toList(),
    );
  }
}

// answer 답변 응답 데이터 모델링
class AnswerResponse {
  final int status;
  final String answer;

  AnswerResponse({required this.status, required this.answer});

  factory AnswerResponse.fromJson(Map<String, dynamic> json) {
    var data = json['data'] as Map<String, dynamic>? ?? {};
    return AnswerResponse(
      status: json['status'] as int,
      answer: data['answer'] as String,
    );
  }
}