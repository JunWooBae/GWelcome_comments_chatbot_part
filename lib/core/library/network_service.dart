import 'dart:convert';
import 'package:gwelcome_front/features/auth/presentation/components/buttons.dart';
import 'package:http/http.dart' as http;


Future<String> fetchData(String uri, String token) async {
  var url = Uri.parse(uri);
  var response = await http.get(
    url,
    headers: {
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode == 200) {
    return response.body;
  } else {
    // 실패한 경우 상세한 오류 메시지 포함
    throw Exception('Failed to load data: ${response.statusCode}');
  }
}

Future<List<dynamic>> getData(String uri, String token) async {
  try {
    String response = await fetchData(uri, token);
    var jsonData = json.decode(response);
    return jsonData['data']['content'];
  } catch (e) {
    print('Error: $e');
    return [];
  }
}

Future<Map<String, dynamic>> getData2(String uri, String token) async {
  try {
    String response = await fetchData(uri, token);
    var jsonData = json.decode(response);
    return jsonData['data']; // Map<String, dynamic> 형태의 데이터 반환
  } catch (e) {
    print('Error: $e');
    return {}; // 오류 발생 시 빈 맵 반환
  }
}

class Tokens {
  static String accessToken = '';
  static String refreshToken = '';

  static void setTokens(String atk, String rtk) {
    accessToken = atk;
    refreshToken = rtk;
  }
}




String Kakao_uri = "https://kauth.kakao.com/oauth/authorize?client_id=d852327901316bc90e64af893ee770df&redirect_uri=https://gwelcomebackend.site/auth/kakao/callback&response_type=code";
String profile_uri = "https://gwelcomebackend.site/api/mypage";
String policy_uri = "https://gwelcomebackend.site/api/policy";
String Userinfo_uri = "https://gwelcomebackend.site/api/sign-up";
String policy_detail_uri = "https://gwelcomebackend.site/api/policy/";
