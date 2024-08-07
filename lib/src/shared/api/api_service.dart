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

class ApiService {
  Future<void> storeToken(Token token) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('jwtToken', token.jwtToken);
    prefs.setString('refreshToken', token.refreshToken);
  }

  Future<Token?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    final jwtToken = prefs.getString('jwtToken');
    final refreshToken = prefs.getString('refreshToken');

    if (jwtToken != null && refreshToken != null) {
      return Token(jwtToken: jwtToken, refreshToken: refreshToken);
    }
    return null;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('jwtToken');
    await prefs.remove('refreshToken');
    AppNavigator.pushNamed(AuthRoutes.loginOrSignUp);
  }

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final jwtToken = prefs.getString('jwtToken');
    return jwtToken != null;
  }

  // Future<void> fetchData() async{
  //   Token? token = await getToken();
  //
  //   if(token != null){
  //     final response = await http.get(Uri.parse('http://10.0.2.2:8080/api/v1/user/profile'),
  //       headers: {
  //         'Authorization': 'Bearer ${token.jwtToken}',
  //       },);
  //
  //     if(response.statusCode == 202){
  //       //handle response
  //       print('Data: ${response.body}');
  //     }else{
  //       //handle error
  //       print('Failed to load data');
  //     }
  //   }else{
  //     print('Token not found');
  //   }
  // }

  Future<Map<String, dynamic>?> login(String username, String password) async {
    try {
      var data = {'username': username, 'password': password};
      final response = await http.post(
          Uri.parse('http://10.0.2.2:8080/api/v1/common/authenticate'),
          headers: {
            'Content-Type': 'application/json',
          },
          body: json.encode(data));

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonMap = json.decode(response.body);
        Token token = Token.fromJson(jsonMap);
        await storeToken(token);
        return {'success': true};
      } else {
        dynamic errorResponse = json.decode(response.body);
        String errorMessage;

        // Check if the error response is a List or a Map
        if (errorResponse is List && errorResponse.isNotEmpty) {
          errorMessage = errorResponse[0]['message'];
        } else
        if (errorResponse is Map && errorResponse.containsKey('message')) {
          errorMessage = errorResponse['message'];
        } else {
          errorMessage = 'An unknown error occurred';
        }
        return {
          'success': false,
          'message': errorMessage,
        };
      }
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }


  Future<Map<String, dynamic>?> register(String firstName, String lastName,
      String username, String password, String? gender) async {
    try {
      var data = {
        'firstName': firstName,
        'lastName': lastName,
        'username': username,
        'password': password,
        'gender': gender
      };
      if (gender != null) {
        data['gender'] = gender;
      }
      final response = await http.post(
          Uri.parse('http://10.0.2.2:8080/api/v1/common/registration'),
          headers: {
            'Content-Type': 'application/json'
          },
          body: json.encode(data)
      );

      if (response.statusCode == 201) {
        return {'success': true};
      } else {
        List<dynamic> errorResponse = jsonDecode(response.body);
        String errorMessage = errorResponse.isNotEmpty
            ? errorResponse[0]['message']
            : 'An unknown error occurred';
        return {
          'success': false,
          'errors': errorMessage,
        };
      }
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>?> getProfile() async {
    final token = await getToken();

    if (token != null) {
      final response = await http.get(
        Uri.parse('http://10.0.2.2:8080/api/v1/user/profile'),
        headers: {
          'Authorization': 'Bearer ${token.jwtToken}'
        },);
      if (response.statusCode == 202) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        return responseData;
      }
    }
    return null;
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

  Future<void> postTrackingValue(String value, String trackingType,
      String date) async {
    try {
      final token = await getToken();
      if (token != null) {
        var data = {'value': value, 'trackingType': trackingType, 'createdDate': date};
        final response = await http.post(
          Uri.parse('http://10.0.2.2:8080/api/v1/user/progression'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${token.jwtToken}',
          },
          body: json.encode(data),
        );

        if (response.statusCode != 202) {
          throw Exception('Failed to update data for $trackingType');
        }
      }
      else {
        throw Exception('Token not found');
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<Map<String, dynamic>?> getLatestTrackingValue(String trackingType) async {
    final token = await getToken();

    if (token != null) {
      final response = await http.get(
          Uri.parse('http://10.0.2.2:8080/api/v1/user/progression/latest/list'),
          headers: {
            'Authorization': 'Bearer ${token.jwtToken}'
          });

      if (response.statusCode == 202) {
        final List<dynamic> responseData = json.decode(response.body);

        final Map<String, dynamic> item = responseData.firstWhere(
                (item) => item['trackingType'] == trackingType,
        orElse: () => {'value' : 0.0, 'createdDate': 'N/A'});

        print(item);

        return item;
      } else {
        print('Failed to load value');
      }
    } else {
      throw Exception('Token not found');
    }
    return null;
  }

  Future<List<Map<String, dynamic>>> getLatestListTrackingValue() async{
    final token = await getToken();

    if (token != null) {
      final response = await http.get(
          Uri.parse('http://10.0.2.2:8080/api/v1/user/progression/latest/list'),
          headers: {
            'Authorization': 'Bearer ${token.jwtToken}'
          });

      if(response.statusCode == 202){
        final List<Map<String, dynamic>> listValue = json.decode(response.body);
        return listValue;
      }else{
        throw Exception('Value not found');
      }
    }else{
      throw Exception('Token not found');
    }
  }


  Future<List<Map<String, dynamic>>> getTrackingValues(
      String trackingType) async {
    final token = await getToken();

    if (token != null) {
      final response = await http.get(
          Uri.parse('http://10.0.2.2:8080/api/v1/user/progression'),
          headers: {
            'Authorization': 'Bearer ${token.jwtToken}'
          });

      if (response.statusCode == 202) {
        final List<dynamic> responseData = json.decode(response.body);

        final List<Map<String, dynamic>> items = responseData
            .where((item) => item['trackingType'] == trackingType)
            .map((item) =>
        {
          'value': item['value'],
          'createdDate': item['createdDate'],
        }).toList();

        if (items.isNotEmpty) {
          return items;
        } else {
          throw Exception('Tracking type not found');
        }
      } else {
        throw Exception('Failed to load values');
      }
    } else {
      throw Exception('Token not found');
    }
  }

  Future<void> editTrackingValue() async{
    final token = await getToken();

    if (token != null) {
      final response = await http.put(
          Uri.parse('http://10.0.2.2:8080/api/v1/user/progression'),
          headers: {
            'Authorization': 'Bearer ${token.jwtToken}'
          });
      if(response.statusCode != 202){
        throw Exception('Failed to edit');
      }
    }else{
      throw Exception('Token not found');
    }
  }

  Future<Map<String, dynamic>> getAllTrainingProgram(int pageNumber,
      String type, [String queryParams = '']) async {
    final token = await getToken();

    if (token != null) {
      String programType = type.toLowerCase();
      final response = await http.get(
        Uri.parse(
            'http://10.0.2.2:8080/api/v1/user/training-program/$programType?page=$pageNumber$queryParams'),
        headers: {
          'Authorization': 'Bearer ${token.jwtToken}'
        },
      );
      if (response.statusCode == 202) {
        final responseData = json.decode(response.body);
        return responseData;
      } else {
        throw Exception('Failed to load programs');
      }
    } else {
      throw Exception('Token not found');
    }
  }

  Future<Map<String, dynamic>> getAllOnlineTrainingProgram(
      int pageNumber) async {
    final token = await getToken();

    if (token != null) {
      final response = await http.get(
          Uri.parse(
              'http://10.0.2.2:8080/api/v1/user/training-program/online?page=$pageNumber'),
          headers: {
            'Authorization': 'Bearer ${token.jwtToken}'
          });
      if (response.statusCode == 202) {
        final responseData = json.decode(response.body);
        return responseData;
      } else {
        throw Exception('Failed to load programs');
      }
    } else {
      throw Exception('Token not found');
    }
  }

  Future<Map<String, dynamic>> getUserTrainingProgram(int pageNumber,
      String type, [String queryParams = '']) async {
    final token = await getToken();

    if (token != null) {
      String programType = type.toLowerCase();
      final response = await http.get(
          Uri.parse(
              'http://10.0.2.2:8080/api/v1/user/training-program/user/$programType?page=$pageNumber$queryParams'),
          headers: {
            'Authorization': 'Bearer ${token.jwtToken}'
          });
      if (response.statusCode == 202) {
        final responseData = json.decode(response.body);
        return responseData;
      } else {
        throw Exception('Failed to load programs');
      }
    } else {
      throw Exception('Token not found');
    }
  }

  Future<void> userRegisterProgram(int id) async {
    final token = await getToken();

    if (token != null) {
      final response = await http.put(
          Uri.parse('http://10.0.2.2:8080/api/v1/user/training-program/save/$id'),
          headers: {
            'Authorization': 'Bearer ${token.jwtToken}'
          });
      if (response.statusCode != 202) {
        throw Exception('Failed to register!');
      }
    } else {
      throw Exception('Token not found');
    }
  }

  Future<List<Map<String, dynamic>>?> getUserTodayMeal() async{
    final token = await getToken();
    
    if(token != null){
      final response = await http.get(Uri.parse('http://10.0.2.2:8080/api/v1/user/nutrition/today'),
      headers: {
        'Authorization': 'Bearer ${token.jwtToken}'
      });

      if(response.statusCode == 200){
        List<dynamic> data = json.decode(response.body);
        return data.map((item) => item as Map<String, dynamic>).toList();
      }else{
        print('Cannot get today meal');

      }
    }else{
      throw Exception('Token not found');
    }
    return null;
  }

  Future<void> postUserTodayMeals(Map<String, dynamic> requestedData) async {
    final token = await getToken();

    if (token != null) {
      final response = await http.post(
          Uri.parse('http://10.0.2.2:8080/api/v1/user/nutrition'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${token.jwtToken}'
          },
          body: json.encode(requestedData));
      if(response.statusCode != 202){
        throw Exception('Failed to post meals');
      }
    }else{
      throw Exception('Token not found');
    }
  }

  Future<Map<String, dynamic>> getThisWeekNutrition() async {
    final token = await getToken();

    if (token != null) {
      final response = await http.get(
          Uri.parse('http://10.0.2.2:8080/api/v1/user/nutrition/this-week'),
          headers: {
            'Authorization': 'Bearer ${token.jwtToken}'
          });
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Cannot get this week Nutrition');
      }
    }else{
      throw Exception('Token not found');
    }
  }
}