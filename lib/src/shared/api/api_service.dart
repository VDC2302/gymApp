import 'dart:async';
import 'dart:convert';
import 'package:flutter_svg/svg.dart';
import 'package:flutter/material.dart';
import 'package:gymApp/src/features/auth/presentation/screens/signup_screen.dart';
import 'package:http/http.dart' as http;
import 'package:gymApp/src/features/navigation/nav.dart';
import 'package:gymApp/src/features/navigation/routes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

final usernameController = TextEditingController();
final passwordController = TextEditingController();

class Token {
  final String jwtToken;
  final String refreshToken;

  Token({required this.jwtToken, required this.refreshToken});

  factory Token.fromJson(Map<String, dynamic> json) {
    return Token(
      jwtToken: json['jwtToken'],
      refreshToken: json['refreshToken'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'jwtToken': jwtToken,
      'refreshToken': refreshToken,
    };
  }
}

class ApiService{
  Future<void> storeToken(Token token) async{
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('jwtToken', token.jwtToken);
    prefs.setString('refreshToken', token.refreshToken);
  }

  Future<Token?> getToken() async{
    final prefs = await SharedPreferences.getInstance();
    final jwtToken = prefs.getString('jwtToken');
    final refreshToken = prefs.getString('refreshToken');

    if(jwtToken != null && refreshToken != null){
      return Token(jwtToken: jwtToken, refreshToken: refreshToken);
    }
    return null;
  }

  Future<void> logout() async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('jwtToken');
    await prefs.remove('refreshToken');
    AppNavigator.pushNamed(AuthRoutes.loginOrSignUp);
  }

  Future<void> fetchData() async{
    Token? token = await getToken();

    if(token != null){
      final response = await http.get(Uri.parse('http://10.0.2.2:8080/api/v1/user/profile'),
        headers: {
          'Authorization': 'Bearer ${token.jwtToken}',
        },);

      if(response.statusCode == 202){
        //handle response
        print('Data: ${response.body}');
      }else{
        //handle error
        print('Failed to load data');
      }
    }else{
      print('Token not found');
    }
  }

  Future<void> login(String username, password) async{
    try{
      var data ={'username' : username, 'password' : password};
      print(json.encode(data));
      final response = await http.post(Uri.parse('http://10.0.2.2:8080/api/v1/common/authenticate'),
          headers: {
            'Content-Type': 'application/json',
          },
          body: json.encode(data));

      if(response.statusCode == 200){
        print('Login successful.');
        Map<String, dynamic> jsonMap = jsonDecode(response.body);
        Token token = Token.fromJson(jsonMap);
        await storeToken(token); //store token

        print(token.jwtToken);

        final response1 = await http.get(Uri.parse('http://10.0.2.2:8080/api/v1/user/profile'),
          headers: {
            'Authorization': 'Bearer ${token.jwtToken}',
          },
        );
        if(response1.statusCode == 202){
          Map<String, dynamic> responseData = jsonDecode(response1.body);
          print("profile: " + response1.body);
        }else{
          print(response1.statusCode);
        }
        AppNavigator.pushNamed(HomeRoutes.main);

      }else{
        print('login failed');
        int scode = response.statusCode;
      }
    }catch(e){
      print(e.toString());
    }
  }

  Future<String?> getFullName() async{
    final token = await getToken();

    if(token != null){
      final response = await http.get(Uri.parse('http://10.0.2.2:8080/api/v1/user/profile'),
        headers: {
          'Authorization': 'Bearer ${token.jwtToken}',
        },);

      if(response.statusCode == 202){
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final String firstName = responseData['firstName'];
        final String lastName = responseData['lastName'];
        return '$lastName $firstName';
      }else{
        throw Exception('Failed to load profile');
      }
    }else{
      throw Exception('token not found');
    }
  }

  Future<Map<String, dynamic>?> getProfile() async{
    final token = await getToken();

    if(token != null){
      final response = await http.get(Uri.parse('http://10.0.2.2:8080/api/v1/user/profile'),
      headers: {
        'Authorization' : 'Bearer ${token.jwtToken}'
          },);
      if(response.statusCode == 202){
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        return responseData;
      }
    }
  }
}

// void profile(String firstName, String lastName) async{
//   try{
//     var data = {'firstName': firstName, 'lastName': lastName};
//     Response response = await get(Uri.parse('http://10.0.2.2:8080/api/v1/user/profile'),
//     headers:{
//       'Authorization': 'Bearer ' + token.jwtToken;
//     },);
//   }catch(e){
//
//   }
// }

//

//
// class MyHttpException extends HttpException {
//   final int statusCode;
//   MyHttpException(this.statusCode, String message) : super(message);
// }
//
// class ApiService {
//   static const String baseUrl = 'localhost:8080/api/v1/common';
//
//   static ApiService? instance;
//
//   factory ApiService() => instance ??= ApiService._internal();
//
//   ApiService._internal();



//   Future<Response> login(String? username, String password) async {
//     final url = new Uri.https(baseUrl, '/registration');
//     final credentials = '$username:$password';
//     final basic = 'Basic ${base64Encode(utf8.encode(credentials))}';
//     final json = await NetworkUtils.post(url, headers: {
//       HttpHeaders.AUTHORIZATION: basic,
//     });
//     return Response.fromJson(json);
//   }
// }

// class NetworkUtils {
//   static Future get(Uri url, {Map<String, String>? headers}) async {
//     final response = await http.get(url, headers: headers);
//     final body = response.body;
//     final statusCode = response.statusCode;
//     if (body == null) {
//       throw MyHttpException(statusCode, 'Response body is null');
//     }
//     final decoded = json.decode(body);
//     if (statusCode < 200 || statusCode >= 300) {
//       throw MyHttpException(statusCode, decoded['message']);
//     }
//     return decoded;
//   }
//
//   static Future post(Uri url,
//       {Map<String, String>? headers, Map<String, String>? body}) {
//     return _helper('POST', url, headers: headers, body: body);
//   }
//
//   static Future _helper(String method, Uri url,
//       {Map<String, String>? headers, Map<String, String>? body}) async {
//     final request = new http.Request(method, url);
//     if (body != null) {
//       request.bodyFields = body;
//     }
//     if (headers != null) {
//       request.headers.addAll(headers);
//     }
//     final streamedReponse = await request.send();
//
//     final statusCode = streamedReponse.statusCode;
//     final decoded = json.decode(await streamedReponse.stream.bytesToString());
//
//     debugPrint('decoded: $decoded');
//
//     if (statusCode < 200 || statusCode >= 300) {
//       throw MyHttpException(statusCode, decoded['message']);
//     }
//
//     return decoded;
//   }
//
//   static Future put(Uri url, {Map<String, String>? headers, body}) {
//     return _helper('PUT', url, headers: headers, body: body);
//   }
// }