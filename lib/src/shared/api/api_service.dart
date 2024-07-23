import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:gymApp/src/features/navigation/nav.dart';
import 'package:gymApp/src/features/navigation/routes.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    prefs.setString('jwtToken', token.jwtToken) ?? [];
    prefs.setString('refreshToken', token.refreshToken) ?? [];
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

  Future<Map<String, dynamic>?> login(String username, String password) async{
    try{
      var data = {'username': username, 'password': password};
      final response = await http.post(Uri.parse('http://10.0.2.2:8080/api/v1/common/authenticate'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode(data));

      if(response.statusCode == 200){
        Map<String, dynamic> jsonMap = json.decode(response.body);
        Token token = Token.fromJson(jsonMap);
        await storeToken(token);
        return{'success': true};
      }else{
        List<dynamic> errorResponse = json.decode(response.body);
        String errorMessage = errorResponse.isNotEmpty ? errorResponse[0]['message'] : 'An unknown error occurred';
        return{
          'success': false,
          'errors': errorMessage
        };
      }
    }catch(e){
      return {'success': false, 'message': e.toString()};
    }
  }


  Future<Map<String, dynamic>?> register (String firstName, String lastName, String username, String password, String? gender) async{
    try{
      var data = {'firstName': firstName, 'lastName': lastName, 'username': username, 'password': password, 'gender': gender};
      if (gender != null) {
        data['gender'] = gender;
      }
      final response = await http.post(Uri.parse('http://10.0.2.2:8080/api/v1/common/registration'),
      headers: {
        'Content-Type': 'application/json'
      },
        body: json.encode(data)
      );

      if (response.statusCode == 201) {
        return {'success': true};
      } else {
        List<dynamic> errorResponse = jsonDecode(response.body);
        String errorMessage = errorResponse.isNotEmpty ? errorResponse[0]['message'] : 'An unknown error occurred';
        return {
          'success': false,
          'errors': errorMessage,
        };
      }
    }catch(e){
      return {'success': false, 'message': e.toString()};
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

  Future<List<String>?> getTrackingTypes() async {
    final token = await getToken();

    if (token != null) {
      final response = await http.get(
        Uri.parse('http://10.0.2.2:8080/api/v1/user/progression/type'),
        headers: {
          'Authorization': 'Bearer ${token.jwtToken}',
        },
      );

      if (response.statusCode == 202) {
        return List<String>.from(json.decode(response.body));
      } else {
        throw Exception('Failed to load tracking types');
      }
    } else {
      throw Exception('Token not found');
    }
  }

  Future<void> postTrackingValue(String value, String trackingType, String date) async {
    try {
      final token = await getToken();
      if (token != null) {
        var data = {'value': value, 'trackingType': trackingType, 'date': date};
        final response = await http.post(
          Uri.parse('http://10.0.2.2:8080/api/v1/user/progression'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${token.jwtToken}',
          },
          body: json.encode(data),
        );

      //   if (response.statusCode == 200) {
      //     return json.decode(response.body);
      //   } else {
      //     Map<String, dynamic> errorResponse = json.decode(response.body);
      //     return {'success': false, 'message': [errorResponse]};
      //   }
      // } else {
      //   throw Exception('Token not found');
        if (response.statusCode != 202) {
          throw Exception('Failed to update data for $trackingType');
        }
      }
      else{
        throw Exception('Token not found');
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<Map<String, dynamic>?> getTrackingValue(String trackingType) async{
    final token = await getToken();

    if(token != null){
      final response = await http.get(Uri.parse('http://10.0.2.2:8080/api/v1/user/progression'),
      headers: {
        'Authorization': 'Bearer ${token.jwtToken}'
      });

      if(response.statusCode == 202){
        final List<dynamic> responseData = json.decode(response.body);

        final List<dynamic> item = responseData.where(
              (item) => item['trackingType'] == trackingType).toList();

        if(item.isNotEmpty){
          final Map<String, dynamic> latestItem = item.reduce(
              (a,b) => a['id'] > b['id'] ? a : b,
          );
          return latestItem;
        } else {
          throw Exception('Tracking type not found');
        }

      }else{
        throw Exception('Failed to load value');
      }
    }else{
      throw Exception('Token not found');
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