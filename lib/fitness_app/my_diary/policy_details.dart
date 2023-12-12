import 'package:gwelcome_front/core/library/network_service.dart';
import 'package:gwelcome_front/features/auth/presentation/components/buttons.dart';
import 'package:gwelcome_front/fitness_app/my_diary/chatbot.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';


class PolicyDetails extends StatefulWidget {
  static const String id = "policy_details";
  const PolicyDetails({super.key});

  @override
  State<PolicyDetails> createState() => _PolicyDetailsState();
}

// 상세 정책 6가지 가져오는 함수
class _PolicyDetailsState extends State<PolicyDetails> {

  /* 필요한 변수 선언한 부분임 */
  String _jwtToken = 'eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ7XCJtZW1iZXJJZFwiOlwiMmM5MTgwODI4YzU3ZTQ1YTAxOGM1ZTQ3NThhMzAwMDBcIn0iLCJpYXQiOjE3MDIzODg3ODMsImV4cCI6OTAwMDE3MDIzODg3ODN9.iUO6035wku0Ig8u96Lmr39Q8LTMk4dWHBZ-iRSeYQog';


  String a = policy_id_now;

  List<Reply> comments = []; // Reply 객체들을 저장하는 리스트

  final TextEditingController _controller = TextEditingController();


  /* 여기 아래에서 부터는 함수들 정의한 부분임 */
  // 서버에서 상세 정책 가져오는 함수
  Future<List<Policy>> fetchData() async {
    Uri myUri = Uri.parse("$policy_detail_uri${a}");
    final response = await http.get(
      myUri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_jwtToken',
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonData = json.decode(utf8.decode(response.bodyBytes));
      //debugPrint(jsonData.toString());

      // jsonData['data']를 단일 객체로 처리하고, 이를 리스트에 담습니다.
      Map<String, dynamic> dataMap = jsonData['data'];
      List<Map<String, dynamic>> dataList = [dataMap];

      debugPrint(dataList.toString());

      return dataList.map((item) => Policy.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load data');
    }
  }


  @override
  // 화면 프레임
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('G - welcome 정책 상세보기'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            _buildPolicySection(),  // 정책 세부 정보 섹션
            _buildBottomSection(),  // 하단 섹션 (사이트 바로가기, 챗봇 상담 버튼)
            _buildCommentSection(), // 댓글 섹션
          ],
        ),
      ),
    );
  }

  // 정책에 관한 상세 내용 보여주는 함수
  Widget _buildPolicySection() {
    return FutureBuilder<List<Policy>>(
      future: fetchData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          return ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final policy = snapshot.data![index];
              return Card(
                child: Column(
                  children: <Widget>[
                    Image.network(policy.imageUrl, fit: BoxFit.cover),
                    ListTile(
                      title: Text(policy.title),
                      subtitle: Text(policy.intro),
                      trailing: IconButton(
                        icon: Icon(Icons.arrow_forward),
                        onPressed: () {
                          // 상세 정보 페이지나 관련 작업으로 이동
                        },
                      ),
                    ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  child: Column(
                    children: <Widget>[
                      _buildInfoTile(Icons.thumb_up, "Likes: ${policy.likesCount}"),
                      _buildInfoTile(Icons.category, "Field: ${policy.policyField}"),
                      _buildInfoTile(Icons.timer, "Deadline: ${policy.dDay}"),
                      _buildInfoTile(Icons.attach_money, "Living Income: ${policy.livingIncome}"),
                      _buildInfoTile(Icons.person, "Age: ${policy.age}"),
                      _buildInfoTile(Icons.calendar_today, "Application Period: ${policy.businessApplicationPeriod}"),
                    ],
                  ),
                ),
                  ],
                ),
              );
            },
          );
        } else {
          return Text('데이터를 불러오지 못했습니다.');
        }
      },
    );
  }

  Widget _buildInfoTile(IconData icon, String text) {
    return Container(
      padding: EdgeInsets.all(8.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(icon, size: 20),
          SizedBox(width: 8),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }


  Widget _buildBottomSection() {
    return Container(
      padding: EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          ElevatedButton(
            onPressed: () async {
              final url = Uri.parse('https://www.kinfa.or.kr/product/youthJump.do');
              if (await canLaunchUrl(url)) {
                await launchUrl(url);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('연결할 수 없습니다!')),
                );
              }
            },
            child: Text('사이트 바로가기'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ChatBotScreen()),
              );
            },
            child: Text('챗봇 상담'),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentSection() {
    return Column(
      children: <Widget>[
        _buildCommentInputField(),
        _buildCommentsList(),
      ],
    );
  }


  Widget _buildCommentInputField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: '댓글을 입력하세요...',
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: () {
              final commentText = _controller.text;
              postComment(commentText);
              _controller.clear();
            },
          ),
        ],
      ),
    );
  }

  // 댓글 목록 함수
  Widget _buildCommentsList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: comments.length,
      itemBuilder: (context, index) {
        final Reply comment = comments[index];
        return ListTile(
          title: Text(comment.username),
          subtitle: Text(comment.comment),
          trailing: Text(comment.createDate),
        );
      },
    );
  }


  // 댓글 서버로 보내는 함수
  void postComment(String comment) async {
    try {
      final response = await http.post(
        Uri.parse('https://gwelcomebackend.site/api/reply/${a}'),
        headers: {
          'Content-Type': 'application/json', // 여기에 Content-Type 추가
          'Authorization': 'Bearer $_jwtToken',
        },
        body: json.encode({
          'content': comment,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        getComments(); // 서버로부터 최신 댓글 목록을 다시 가져옵니다.
      } else {
        print('Failed to post comment: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('Error occurred: $e');
    }
  }

  // 댓글 보내기 버튼 클릭하면 화면 다시 재시작하는 함수
  @override
  void initState() {
    super.initState();
    getComments();
  }

  // 서버에서 댓글 가져오기 함수
  Future<void> getComments() async {
    try {
      final response = await http.get(Uri.parse('https://gwelcomebackend.site/api/reply/${a}'));

      if (response.statusCode == 200) {
        final decodedBody = utf8.decode(response.bodyBytes);
        final apiResponse = ApiResponse.fromJson(json.decode(decodedBody));
        setState(() {
          comments = apiResponse.replies;
        });
      } else {
        print('Failed to load comments: ${response.statusCode}');
      }
    } catch (e) {
      print('Error occurred while fetching comments: $e');
    }
  }

}


// 댓글 가져오기 데이터 모델링
class Reply {
  final int replyId;
  final String comment;
  final String username;
  final String createDate;

  Reply({required this.replyId, required this.comment, required this.username, required this.createDate});

  factory Reply.fromJson(Map<String, dynamic> json) {
    return Reply(
      replyId: json['replyId'] as int,
      comment: json['comment'] as String,
      username: json['username'] as String,
      createDate: json['createDate'] as String,
    );
  }
}

class ApiResponse {
  final int status;
  final int totalReplies;
  final List<Reply> replies;

  ApiResponse({required this.status, required this.totalReplies, required this.replies});

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    var list = json['data']['replyResponseDTO'] as List;
    List<Reply> repliesList = list.map((i) => Reply.fromJson(i)).toList();

    return ApiResponse(
      status: json['status'] as int,
      totalReplies: json['data']['totalReplies'] as int,
      replies: repliesList,
    );
  }
}



// 상세 정책 데이터 모델링
class Policy {
  final int id;
  final String title;
  final String intro;
  final String imageUrl;
  final int likesCount;
  final String policyField;
  final String dDay;
  final String livingIncome;
  final String age;
  final String businessApplicationPeriod;

  Policy({
    required this.id,
    required this.title,
    required this.intro,
    required this.imageUrl,
    required this.likesCount,
    required this.policyField,
    required this.dDay,
    required this.livingIncome,
    required this.age,
    required this.businessApplicationPeriod,
  });

  factory Policy.fromJson(Map<String, dynamic> json) {
    return Policy(
      id: json['id'] as int,
      title: json['title'] as String,
      intro: json['intro'] as String,
      imageUrl: json['image_url'] as String,
      likesCount: json['likesCount'] as int,
      policyField: json['policy_field'] as String,
      dDay: json['d_day'] as String,
      livingIncome: json['living_income'] as String,
      age: json['age'] as String,
      businessApplicationPeriod: json['business_application_period'] as String,
    );
  }
}