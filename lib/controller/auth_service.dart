import 'package:flutter/material.dart';
import 'package:flutter_camp/provider/admin_providers.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_camp/models/camp_model.dart';
import 'package:flutter_camp/models/admin_model.dart';
import 'dart:convert';
import 'package:flutter_camp/variables.dart';
import 'package:provider/provider.dart';
import 'package:flutter_camp/provider/admin_providers.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AuthService {
  Future<List<Camp>> fetchCamps() async {
    try {
      final response = await http.get(Uri.parse("$apiURL/api/camps"));

      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = json.decode(response.body);
        return jsonResponse.map((camp) => Camp.fromJson(camp)).toList();
      } else {
        throw Exception('Failed to load camps');
      }
    } catch (e) {
      // ถ้าเกิดข้อผิดพลาด ให้คืนค่าลิสต์ว่าง
      return [];
    }
  }

  Future<Admin> login(String userName, String password) async {
    print(apiURL);

    final response = await http.post(Uri.parse("$apiURL/api/auth/login"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "username": userName,
          "password": password,
        }));
    print(response.statusCode);
    if (response.statusCode == 200) {
      return Admin.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to login');
    }
  }

  Future<void> deleteCamp(Camp camp, BuildContext context) async {
    final adminProvider = Provider.of<AdminProviders>(context, listen: false);
    final token = adminProvider.accessToken; // เข้าถึง token

    try {
      final response = await http.delete(
        Uri.parse("$apiURL/api/camp/${camp.id}"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        },
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to delete camp');
      }
    } catch (e) {
      throw Exception('Failed to delete camp: $e');
    }
  }

  Future<void> updateCamp(Camp camp, BuildContext context) async {
    final adminProvider = Provider.of<AdminProviders>(context, listen: false);
    final token = adminProvider.accessToken;
    print(campToJson(camp));
    final response = await http.put(
      Uri.parse('$apiURL/api/camp/${camp.id}'), // แทนที่ด้วย URL ที่ถูกต้อง
      headers: {
        'Content-Type': 'application/json',
        "Authorization": "Bearer $token"
        // หากจำเป็นต้องมีการจัดการ token สำหรับการเข้าใช้งาน ให้เพิ่มที่นี่
      },
      body: campToJson(camp),
      // แปลง Camp object เป็น JSON
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update camp');
    }
  }

  Future<void> addCamp(Camp camp, BuildContext context) async {
    final adminProvider = Provider.of<AdminProviders>(context, listen: false);
    final token = adminProvider.accessToken;

    try {
      final response = await http.post(
        Uri.parse("$apiURL/api/camp"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        },
        body: campToJson(camp), // แปลง Camp object เป็น JSON
      );

      if (response.statusCode != 201) {
        throw Exception('Failed to add camp');
      }
    } catch (e) {
      throw Exception('Failed to add camp: $e');
    }
  }
}
