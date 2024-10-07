// To parse this JSON data, do
//
//     final admin = adminFromJson(jsonString);

import 'dart:convert';

Admin adminFromJson(String str) => Admin.fromJson(json.decode(str));

String adminToJson(Admin data) => json.encode(data.toJson());

class Admin {
  String username;
  String accessToken;
  String refreshToken;

  Admin({
    required this.username,
    required this.accessToken,
    required this.refreshToken,
  });

  factory Admin.fromJson(Map<String, dynamic> json) => Admin(
        username: json["username"],
        accessToken: json["accessToken"],
        refreshToken: json["refreshToken"],
      );

  Map<String, dynamic> toJson() => {
        "username": username,
        "accessToken": accessToken,
        "refreshToken": refreshToken,
      };
}
