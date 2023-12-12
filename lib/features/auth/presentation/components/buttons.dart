import 'package:flutter/material.dart';
import 'package:gwelcome_front/core/library/network_service.dart';
import 'package:gwelcome_front/fitness_app/my_diary/chatbot.dart';
import 'package:gwelcome_front/fitness_app/my_diary/mypage.dart';
import 'package:gwelcome_front/fitness_app/my_diary/policy_details.dart';


String policy_id_now="";
String policy_title_now="";

class BuildButton extends StatefulWidget {
  final String uri;
  final String token;

  BuildButton({required this.uri, required this.token});

  @override
  _BuildButtonState createState() => _BuildButtonState();
}

class _BuildButtonState extends State<BuildButton> {
  List<dynamic> contents = []; // 서버로부터 가져온 content를 저장할 리스트

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      var data = await getData(widget.uri, widget.token);
      setState(() {
        contents = data;
      });
    } catch (e) {
      print('Error: $e');
    }
  }



  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Divider(
          height: 0,
          thickness: 2,
          color: Colors.grey,
        ),
        for (var item in contents) ...[
          Button(
            id: item['id'].toString(), // 'id' 값을 문자열로 변환
            title: item['title'], // 'title' 값을 직접 사용
            intro: item['intro'], // 'intro' 값을 직접 사용
            image_url: item['image_url'], // 'image_url' 값을 직접 사용
            policy_field: item['policy_field'],
            d_day: item['d_day'],
            onPressed: () async {
              Navigator.pushNamed(context, MyPage.id);
            },
          ),
        ],
      ],
    );
  }
}





String formatMessage(String message) {
  const int maxLength = 20; // 최대 표시할 문자열 길이
  if (message.length > maxLength) {
    return message.substring(0, maxLength) + '...';
  }
  return message;
}




class MyButtonKakao extends StatelessWidget {
  final void Function()? onPressed;
  final String? iconUrl;
  final String text;
  const MyButtonKakao({
    super.key,
    this.onPressed,
    this.iconUrl,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        minimumSize: const Size(double.infinity, 60),
        backgroundColor: const Color(0xFFFEE500),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.zero, // 모서리를 직각으로 만듭니다.
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          if (iconUrl != null)
            Image.asset(
              iconUrl!,
              width: 30,
              height: 30,
            )
          else
            const SizedBox(
              width: 30,
            ),
          const SizedBox(width: 10),
          Text(
            text,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 20,
            ),
          ),
          const Icon(
            Icons.abc,
            size: 50,
            color: Colors.transparent,
          ),
        ],
      ),
    );
  }
}

class MyButtonNaver extends StatelessWidget {
  final void Function()? onPressed;
  final String? iconUrl;
  final String text;
  const MyButtonNaver({
    super.key,
    this.onPressed,
    this.iconUrl,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        minimumSize: const Size(double.infinity, 60),
        backgroundColor: const Color(0xFF1FCB53),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.zero, // 모서리를 직각으로 만듭니다.
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          if (iconUrl != null)
            Image.asset(
              iconUrl!,
              width: 30,
              height: 30,
            )
          else
            const SizedBox(
              width: 30,
            ),
          const SizedBox(width: 10),
          Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
          const Icon(
            Icons.abc,
            size: 50,
            color: Colors.transparent,
          ),
        ],
      ),
    );
  }
}




class MyButtonTwo extends StatelessWidget {
  final String text;
  final void Function()? onPressed;
  const MyButtonTwo({
    super.key,
    required this.text,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        minimumSize: const Size(double.infinity, 60),
        backgroundColor: const Color(0xFF265AE8),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 20,
        ),
      ),
    );
  }
}

class FavoriteButton extends StatefulWidget {
  @override
  _FavoriteButtonState createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {
  bool isFavorited = true; // 초기 상태는 즐겨찾기 되었다고 가정

  void toggleFavorite() {
    setState(() {
      isFavorited = !isFavorited;

      // 서버에 즐겨찾기 목록에서 추가/제외시키는 로직이 들어갈 부분
      // if (isFavorited) {
      //   // 서버에 추가하는 로직
      // } else {
      //   // 서버에서 제외시키는 로직
      // }
    });
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        isFavorited ? Icons.favorite : Icons.favorite_border,
        color: isFavorited ? Colors.red : null,
        size: 40,
      ),
      onPressed: toggleFavorite,
    );
  }
}



class MyButton extends StatelessWidget {
  final void Function()? onPressed;
  final String? iconUrl;
  final String text;
  const MyButton({
    super.key,
    this.onPressed,
    this.iconUrl,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(double.infinity, 80),
        backgroundColor: Colors.white,
        side: BorderSide(color: Colors.transparent),
        shape: BeveledRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          if (iconUrl != null)
            Image.asset(
              iconUrl!,
              width: 30,
              height: 30,
            )
          else
            const SizedBox(
              width: 30,
            ),
          const SizedBox(width: 10),
          Text(
            text,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 20,
            ),
          ),
          const Icon(
            Icons.abc,
            size: 50,
            color: Colors.transparent,
          ),
        ],
      ),
    );
  }
}



class Button extends StatelessWidget {
  final void Function()? onPressed;
  final String id;
  final String title;
  final String intro;
  final String image_url;
  final String policy_field;
  final String d_day;

  const Button({
    Key? key,
    this.onPressed,
    required this.id,
    required this.title,
    required this.intro,
    required this.image_url,
    required this.policy_field,
    required this. d_day,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Divider(
          height: 0,
          thickness: 2,
          color: Colors.grey,
        ),
        Row(
          children: [
            Expanded(
              child: Container(
                height: 100, // 세로 방향의 최소 크기 설정
                child: OutlinedButton(
                  onPressed: (){
                    policy_id_now = this.id;
                    policy_title_now = this.title;
                    print(policy_id_now);
                    print(policy_title_now);
                    print(policy_detail_uri);
                    Navigator.pushNamed(context, PolicyDetails.id);
                    Navigator.pushNamed(context, ChatBotScreen.id);
                    Navigator.pushNamed(context, ChatBotScreen.title);
                },
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.white,
                    side: BorderSide(color: Colors.transparent),
                  ),
                  child: Row(
                    children: <Widget>[
                          ClipOval(
                            child: Image.network(
                              image_url,
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                            ),
                          ),
                      SizedBox(width: 20), // 이미지와 텍스트 사이의 간격
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(policy_field, style: TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.bold),
                              ),
                            Text(formatMessage(intro),
                                style: TextStyle(fontSize: 12, color: Color(0xFF959595))),
                            SizedBox(height: 5),
                            Row(
                              children: [
                                Container(
                                  constraints: BoxConstraints(minWidth: 50),
                                  padding: EdgeInsets.all(0), // 내부 여백
                                  decoration: BoxDecoration(
                                    color: Color(0xffFCF1EF),
                                    border: Border.all(color: Color(0xFFF8E6E6), width: 2.0), // 테두리 색상 및 너비
                                    borderRadius: BorderRadius.circular(20.0), // 양끝이 둥글게
                                  ),
                                  child: Center(child: Text(d_day, style: TextStyle(color: Color(0xFFE97673),
                                        ),
                                      ),
                                    ), // 표시할 텍스트
                                ),
                                SizedBox(width: 10),
                                Center(child: Text(d_day, style: TextStyle(fontSize: 12, color: Colors.black))),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
             FavoriteButton(),
          ],
        ),
      ],
    );
  }
}



