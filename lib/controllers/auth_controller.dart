import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:personal_expense_tracker_app/main.dart';
import 'package:personal_expense_tracker_app/views/home_screen.dart';
import 'package:personal_expense_tracker_app/views/login_screen.dart';

class AuthController extends GetxController {
  final dio = Dio(
    BaseOptions(
      baseUrl: 'http://192.168.1.6:8000',
    ),
  );
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final emailController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  var responseData = {};

  void signUp() async {
    if (passwordController.text != confirmPasswordController.text) {
      Get.snackbar('Error', 'Passwords do not match',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    final data = {
      'username': usernameController.text,
      'email': emailController.text,
      'password': passwordController.text,
      'confirmPassword': confirmPasswordController.text,
    };
    print(data);
    try {
      final response = await dio.post(
        '/api/v1/register',
        data: jsonEncode(data),
        options: Options(
          headers: {
            'content-type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 201) {
        responseData = response.data;
        print(responseData['message']);
      } else {
        print(responseData['message']);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  void login() async {
    try {
      final data = {
        'email': emailController.text,
        'password': passwordController.text,
      };
      final response = await dio.post(
        '/api/v1/login',
        data: jsonEncode(data),
      );
      if (response.statusCode == 200) {
        responseData = response.data;
        String token = responseData['data'][0]['Token'];
        await prefs.setString('token', token);
        await prefs.setBool('isLogin', true);
        print(token);
        Get.offAll(HomeScreen());
      } else {
        print(responseData['message']);
      }
    } catch (e) {
      print(e);
    }
  }

  void logout() async {
    try {
      String? token = prefs.getString('token');
      final response = await dio.delete(
        '/api/v1/logout',
        options: Options(headers: {
          'content-type': 'application/json',
          'authorization': 'Bearer $token',
        }),
      );
      if (response.statusCode == 200) {
        await prefs.remove('token');
        await prefs.setBool('isLogin', false);
        Get.offAll(LoginScreen());
        print(response.data['message']);
      } else {
        print(response.data['message']);
      }
    } catch (e) {
      print(e);
    }
  }
}
