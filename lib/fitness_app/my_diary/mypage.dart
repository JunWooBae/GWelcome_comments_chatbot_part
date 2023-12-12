import 'package:flutter/material.dart';
import 'package:gwelcome_front/features/auth/presentation/components/buttons.dart';
import 'package:gwelcome_front/core/library/network_service.dart';


class Profile extends StatefulWidget {
  final String profile_url;
  final String nickname;
  final int n_custom_policy;
  final int n_scrap;
  final int n_comment;


  const Profile({
    Key? key,
    required this.profile_url,
    required this.nickname,
    required this.n_custom_policy,
    required this.n_scrap,
    required this.n_comment,
  }) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}


class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Column(
        children: [
          Row(
            children: [
              ClipOval(
                child: Image.network(
                  widget.profile_url,
                  width: 70,
                  height: 70,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(width: 40),
              Expanded( // Center를 Expanded로 감싸서 Row 안에서 공간을 차지하도록 함
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.nickname,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '프로필 수정',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF828282),
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.settings,
                  size: 20,
                ),
                onPressed: () {
                  // 버튼 클릭 시 수행할 동작
                },
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  Text(
                    '맞춤정책',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    '${widget.n_custom_policy}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Text(
                    '스크랩',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    '${widget.n_scrap}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Text(
                    '작성 댓글',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    '${widget.n_comment}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}




class MyPage extends StatefulWidget {
  static const String id = "mypage";
  const MyPage({super.key});

  @override

  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  Map<String, dynamic> profileData = {};

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      var data = await getData2(profile_uri, Tokens.accessToken);
      setState(() {
        profileData = data;
      });
    } catch (e) {
      print('Error: $e');
      setState(() {
        profileData = {}; // 오류 발생 시 빈 딕셔너리 할당
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar:AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          '마이페이지',
          style: const TextStyle(
            color: Colors.black,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Profile(
                profile_url: profileData['image_url'], // 'id' 값을 문자열로 변환
                nickname: profileData['username'], // 'title' 값을 직접 사용
                n_custom_policy: profileData['myPolicies'], // 'intro' 값을 직접 사용
                n_scrap: profileData['myLikes'], // 'image_url' 값을 직접 사용
                n_comment: profileData['myReplies'],
              ),
              SizedBox(height: 10),
              BuildButton(
                uri: policy_uri,
                token: Tokens.accessToken,
              ),
            ],
           ),
          ),
        ),
      );
  }
}
