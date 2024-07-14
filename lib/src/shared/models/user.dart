import 'dart:convert';

class UserModel{
  String? firstName;
  String? lastName;
  String? username;
  String? role;

  UserModel({this.firstName, this.lastName, this.username, this.role});

  factory UserModel.fromJson(Map<String, dynamic> map){
    return UserModel(firstName: map["firstName"], lastName: map["lastName"], username: map["username"], role: map["role"]);
  }

  Map<String, dynamic> toJson(){
    return{"firstName": firstName, "lastName": lastName, "username": username, "role": role};
  }

  @override
  String toString() => '$firstName, $lastName, $username, $role';
}

List<UserModel> userFromJson(String jsonData){
  final data = json.decode(jsonData);
  return List<UserModel>.from(data.map((item) => UserModel.fromJson(item)));
}

String userToJson(UserModel data){
  final jsonData = data.toJson();
  return json.encode(jsonData);
}