import 'package:hive_flutter/hive_flutter.dart';

part 'user_model.g.dart';

@HiveType(typeId: 0)
class UserModel {
  @HiveField(0)
  String email;

  @HiveField(1)
  String username;

  @HiveField(2)
  String token;

  UserModel({
    required this.email,
    required this.token,
    required this.username,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'email': email,
      'username': username,
      'token': token,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      email: map['payload']?['email'] ?? '',
      username: map['payload']?['username'] ?? '',
      token: map['accessToken'],
    );
  }
}
