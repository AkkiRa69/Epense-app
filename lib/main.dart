import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:personal_expense_tracker_app/views/home_screen.dart';
import 'package:personal_expense_tracker_app/views/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

late SharedPreferences prefs;
bool isLogin = false;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  prefs = await SharedPreferences.getInstance();
  isLogin = prefs.getBool('isLogin') ?? false;
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      home: isLogin ? HomeScreen() : LoginScreen(),
    );
  }
}
