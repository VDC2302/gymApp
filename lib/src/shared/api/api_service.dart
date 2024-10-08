import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:gymApp/src/features/navigation/nav.dart';
import 'package:gymApp/src/features/navigation/routes.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http_parser/http_parser.dart';

import '../../features/statistics/presentation/views/logs.dart';

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
  static const baseUrl = "http://10.0.2.2:8080";
  
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

  Future<Map<String, dynamic>?> register(String firstName, String lastName,
      int birthYear, String username, String password, String? gender) async {
    try {
      var data = {
        'firstName': firstName,
        'lastName': lastName,
        'birthYear': birthYear,
        'username': username,
        'password': password,
        'gender': gender
      };
      if (gender != null) {
        data['gender'] = gender;
      }
      final response = await http.post(
          Uri.parse('$baseUrl/api/v1/common/registration'),
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
      return {'success': false, 'message': 'Please check your information again'};
    }
  }

  Future<Map<String, dynamic>?> login(String username, String password) async {
    try {
      var data = {'username': username, 'password': password};
      final response = await http.post(
          Uri.parse('$baseUrl/api/v1/common/authenticate'),
          headers: {
            'Content-Type': 'application/json',
          },
          body: json.encode(data));

      if (response.statusCode == 200 && response.body.isNotEmpty) {
        Map<String, dynamic> jsonMap = json.decode(response.body);
        Token token = Token.fromJson(jsonMap);
        await storeToken(token);
        return {'success': true};

      }else {
        dynamic errorResponse = json.decode(response.body);
        String errorMessage;

        if (errorResponse is List && errorResponse.isNotEmpty && response.body.isNotEmpty) {
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
      return {'success': false, 'message': 'Please check your username and password again'};
    }
  }

  Future<String> checkTarget() async{
    final token = await getToken();

    if (token != null) {
      final response = await http.get(
        Uri.parse('$baseUrl/api/v1/user/profile/is-target'),
        headers: {
          'Authorization': 'Bearer ${token.jwtToken}',
        },
      );
      if(response.statusCode == 202){
        if(response.body.isNotEmpty){
          return json.decode(response.body).toString();
        }else{
          return 'false';
        }
      }else{
        return 'admin';
      }
    }else{
      throw Exception('Token not found');
    }
  }

  Future<void> postUserTarget({
    required double weight,
    required double height,
    required String activityFrequency}) async{

    final token = await getToken();
    final data = {
      'weight': weight,
      'height': height,
      'activityFrequency': activityFrequency,
    };

    if (token != null) {
      final response = await http.put(
        Uri.parse('$baseUrl/api/v1/user/profile'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${token.jwtToken}'
        },
          body: json.encode(data)
      );
      if(response.statusCode != 202){
        throw Exception('Failed to submit data');
      }
    }
  }

  Future<Map<String, dynamic>?> getProfile() async {
    final token = await getToken();

    if (token != null) {
      final response = await http.get(
        Uri.parse('$baseUrl/api/v1/user/profile'),
        headers: {
          'Authorization': 'Bearer ${token.jwtToken}'
        },);
      if (response.statusCode == 202) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        return responseData;
      }else{
        return null;
      }
    }else{
      throw Exception('Token not found');
    }
  }

  Future<void> editProfile(double weight, double height, String activity) async{
    final token = await getToken();

    if (token != null) {
      final response = await http.put(
        Uri.parse('$baseUrl/api/v1/user/profile'),
        headers: {
          'Authorization': 'Bearer ${token.jwtToken}'
        },);
      if (response.statusCode != 202) {
        throw Exception('Failed to update data');
      }
    }else{
      throw Exception('Token not found');
    }
  }

  Future<List<String>?> getTrackingTypes() async {
    final token = await getToken();

    if (token != null) {
      final response = await http.get(
        Uri.parse('$baseUrl/api/v1/user/progression/type'),
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
          Uri.parse('$baseUrl/api/v1/user/progression'),
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

  Future<List<TrackingData>> graphTrackingData(String trackingType) async {
    try {
      final token = await getToken();
      if (token != null) {
        final response = await http.get(
          Uri.parse('$baseUrl/api/v1/user/progression'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${token.jwtToken}',
          },
        );

        if (response.statusCode == 202) {  // Change status code check to 200
          List<dynamic> responseData = json.decode(response.body);
          List<TrackingData> trackingData = responseData
              .map((data) => TrackingData.fromJson(data))
              .where((data) => data.trackingType == trackingType) // Filter by trackingType
              .toList();
          return trackingData;
        } else {
          throw Exception('Failed to fetch data');
        }
      } else {
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
          Uri.parse('$baseUrl/api/v1/user/progression/latest/list'),
          headers: {
            'Authorization': 'Bearer ${token.jwtToken}'
          });

      if (response.statusCode == 202) {
        final List<dynamic> responseData = json.decode(response.body);

        final Map<String, dynamic> item = responseData.firstWhere(
                (item) => item['trackingType'] == trackingType,
        orElse: () => {'value' : 0.0, 'createdDate': 'N/A'});

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
          Uri.parse('$baseUrl/api/v1/user/progression/latest/list'),
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
          Uri.parse('$baseUrl/api/v1/user/progression'),
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

  Future<void> editTrackingValue(int id, String value, String trackingType,
      String createdDate) async{
    var data = {'id': id, 'value': value, 'trackingType': trackingType, 'createdDate': createdDate};
    final token = await getToken();

    if (token != null) {
      final response = await http.put(
          Uri.parse('$baseUrl/api/v1/user/progression'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${token.jwtToken}'
          },
          body: json.encode(data));
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
            '$baseUrl/api/v1/user/training-program/$programType?page=$pageNumber$queryParams'),
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
              '$baseUrl/api/v1/user/training-program/online?page=$pageNumber'),
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
              '$baseUrl/api/v1/user/training-program/user/$programType?page=$pageNumber$queryParams'),
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
          Uri.parse('$baseUrl/api/v1/user/training-program/save/$id'),
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
  Future<Map<String,dynamic>> getUserTodayCalories() async{
    final token = await getToken();

    if (token != null) {
      final response = await http.get(
        Uri.parse('$baseUrl/api/v1/user/nutrition/today'),
        headers: {
          'Authorization': 'Bearer ${token.jwtToken}',
        },
      );
      if(response.statusCode == 200){
        if(response.body.isNotEmpty){
          Map<String, dynamic> data = json.decode(response.body);
          return data;
        }else{
          return {'dailyCalories': 0.0};
        }
      }else{
        return {'dailyCalories': 0.0};
      }
    }else{
      throw Exception('Token not found');
    }
  }

  Future<List<Map<String, dynamic>>?> getUserTodayMeal() async {
    final token = await getToken();

    if (token != null) {
      final response = await http.get(
        Uri.parse('$baseUrl/api/v1/user/nutrition/today'),
        headers: {
          'Authorization': 'Bearer ${token.jwtToken}',
        },
      );

      if (response.statusCode == 200) {
        if (response.body.isNotEmpty) {
          Map<String, dynamic> data = json.decode(response.body);

          // Extract the mealNutritionList from the response
          List<dynamic> mealNutritionList = data['mealNutritionList'] ?? [];

          return mealNutritionList.map((item) => item as Map<String, dynamic>).toList();
        } else {
          // Handle empty response body
          return [];
        }
      } else {
        // Handle non-200 status codes
        return [];
      }
    } else {
      throw Exception('Token not found');
    }
  }

  Future<void> postUserTodayMeals(Map<String, dynamic> requestedData) async {
    final token = await getToken();

    if (token != null) {
      final response = await http.post(
          Uri.parse('$baseUrl/api/v1/user/nutrition'),
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
          Uri.parse('$baseUrl/api/v1/user/nutrition/this-week'),
          headers: {
            'Authorization': 'Bearer ${token.jwtToken}'
          });
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        return {};
      }
    }else{
      throw Exception('Token not found');
    }
  }

  Future<void> postWorkoutHistory(String exercise, double calories, DateTime createdDate) async {
    final token = await getToken();

    if (token != null) {
      final response = await http.post(
        Uri.parse('$baseUrl/api/v1/user/history'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${token.jwtToken}'
        },
        body: json.encode({
          'exercise': exercise,
          'calories': calories,
          'createdDate': DateFormat('yyyy-MM-dd').format(createdDate),
        }),
      );
      if(response.statusCode != 202){
        throw Exception('Error');
      }
    }else{
      throw Exception('Token not found');
    }
  }

  Future<void> adminPostWorkout(String title, String description, String type, String startDate, String startTime) async{
    final token = await getToken();
    final data = {
      'title': title,
      'description': description,
      'type': type,
      'startDate': startDate,
      'startTime': startTime
    };
    if (token != null) {
      final response = await http.post(
          Uri.parse('$baseUrl/api/v1/admin/training-program'),
          headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${token.jwtToken}'
          },
          body: json.encode(data));
      if(response.statusCode != 202){
        throw Exception('Cannot add training program');
      }
    }else{
      throw Exception('Token not found');
    }
  }

  Future<void> adminUpdateWorkout(int id, String title, String description, String type, String startDate, String startTime) async{
    final token = await getToken();
    final data = {
      'id': id,
      'title': title,
      'description': description,
      'type': type,
      'startDate': startDate,
      'startTime': startTime
    };
    if (token != null) {
      final response = await http.put(
          Uri.parse('$baseUrl/api/v1/admin/training-program'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${token.jwtToken}'
          },
          body: json.encode(data));
      if(response.statusCode != 202){
        throw Exception('Cannot edit training program');
      }
    }else{
      throw Exception('Token not found');
    }
  }

  Future<Map<String, dynamic>> adminGetAllTrainingProgram(int pageNumber,
      String type, [String queryParams = '']) async {

    final token = await getToken();

    if (token != null) {
      String programType = type.toLowerCase();
      final response = await http.get(
        Uri.parse(
            '$baseUrl/api/v1/admin/training-program/$programType?page=$pageNumber$queryParams'),
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

  Future<Map<String, dynamic>> adminGetAllOnlineTrainingProgram(
      int pageNumber) async {
    final token = await getToken();

    if (token != null) {
      final response = await http.get(
          Uri.parse(
              '$baseUrl/api/v1/admin/training-program/online?page=$pageNumber'),
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

  Future<void> adminUploadLesson(int programId, String name, String description, PlatformFile file) async{
    final token = await getToken();

    if (token != null) {
      final uri = Uri.parse('$baseUrl/api/v1/admin/training-program/add-lesson');
      final request = http.MultipartRequest('POST', uri)
        ..headers['Authorization'] = 'Bearer ${token.jwtToken}'
        ..fields['programId'] = programId.toString()
        ..fields['name'] = name
        ..fields['description'] = description
        ..files.add(
          http.MultipartFile.fromBytes(
            'file',
            File(file.path!).readAsBytesSync(),
            filename: file.name,
            contentType: MediaType('video', 'mp4'),
          ),
        );
      try {
        final response = await request.send();
        if (response.statusCode == 202) {
          print('Upload success');
        } else {
          print('Upload failed: ${response.statusCode}');
        }
      } catch (e) {
        print('Upload failed: $e');
      }
    }else{
      throw Exception('Token not found');
    }
  }

  Future<void> adminDeleteLesson(String id) async{
    final token = await getToken();

    if (token != null) {
      final response = await http.delete(
          Uri.parse('$baseUrl/api/v1/admin/training-program/delete-lesson/$id'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${token.jwtToken}'
          },);

      if(response.statusCode != 202){
        throw Exception('Failed to delete');
      }
    }else{
      throw Exception('Token not found');
    }
  }
}