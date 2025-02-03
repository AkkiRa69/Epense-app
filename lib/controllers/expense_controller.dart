import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:personal_expense_tracker_app/main.dart';

class ExpenseController extends GetxController {
  var expenses = [].obs;
  var total = 0.0.obs;
  final dio = Dio(
    BaseOptions(
      baseUrl: 'http://192.168.1.6:8000',
    ),
  );

  final amountController = TextEditingController();
  final categoryController = TextEditingController();
  final notesController = TextEditingController();
  final dateController = TextEditingController();

  void getExpenses() async {
    try {
      final String? token = prefs.getString('token');
      final response = await dio.get(
        '/api/v1/expense',
        options: Options(
          headers: {
            'content-type': 'application/json',
            'authorization': 'Bearer $token',
          },
        ),
      );
      if (response.statusCode == 200) {
        expenses.value = response.data['data'];
        print(response.data['message']);
      } else {
        print(response.data['message']);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  void create() async {
    try {
      final data = {
        'amount': double.parse(amountController.text),
        'category': categoryController.text,
        'notes': notesController.text,
        'date': dateController.text,
      };
      final String? token = prefs.getString('token');
      final response = await dio.post(
        '/api/v1/expense',
        data: jsonEncode(data),
        options: Options(
          headers: {
            'content-type': 'application/json',
            'authorization': 'Bearer $token',
          },
        ),
      );
      if (response.statusCode == 201) {
        print(response.data['message']);
        getExpenses();
        clearField();
      } else {
        print(response.data['message']);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  void delete(int id) async {
    try {
      final String? token = prefs.getString('token');
      final response = await dio.delete(
        '/api/v1/expense/$id',
        options: Options(
          headers: {
            'content-type': 'application/json',
            'authorization': 'Bearer $token',
          },
        ),
      );
      if (response.statusCode == 200) {
        print(response.data['message']);
        getExpenses();
      } else {
        print(response.data['message']);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  void updateExpense(int id) async {
    try {
      final data = {
        'amount': double.parse(amountController.text),
        'category': categoryController.text,
        'notes': notesController.text,
        'date': dateController.text,
      };
      final String? token = prefs.getString('token');
      final response = await dio.put(
        '/api/v1/expense/$id',
        data: jsonEncode(data),
        options: Options(
          headers: {
            'content-type': 'application/json',
            'authorization': 'Bearer $token',
          },
        ),
      );
      if (response.statusCode == 200) {
        print(response.data['message']);
        getExpenses();
        clearField();
      } else {
        print(response.data['message']);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  void clearField() {
    amountController.clear();
    categoryController.clear();
    notesController.clear();
    dateController.clear();
  }
}
