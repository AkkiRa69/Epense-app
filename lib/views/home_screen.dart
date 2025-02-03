import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:personal_expense_tracker_app/controllers/auth_controller.dart';
import 'package:personal_expense_tracker_app/controllers/expense_controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final controller = Get.put(ExpenseController());
  final authController = Get.put(AuthController());

  @override
  void initState() {
    super.initState();
    controller.getExpenses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Personal Expense Tracker'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              authController.logout();
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          controller.getExpenses();
        },
        child: Center(
          child: Obx(
            () {
              if (controller.expenses.isEmpty) {
                return Text('No expenses found');
              }
              return ListView.separated(
                itemBuilder: (context, index) {
                  final expense = controller.expenses[index]['expnse'];
                  final id = controller.expenses[index]['id'];
                  return Dismissible(
                    key: Key(expense['id'].toString()),
                    background: Container(
                      color: Colors.green,
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Icon(Icons.edit, color: Colors.white),
                    ),
                    secondaryBackground: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Icon(Icons.delete, color: Colors.white),
                    ),
                    confirmDismiss: (direction) async {
                      if (direction == DismissDirection.startToEnd) {
                        // Edit action
                        controller.amountController.text =
                            expense['amount'].toString();
                        controller.categoryController.text = expense['category'];
                        controller.notesController.text = expense['notes'];
                        controller.dateController.text = expense['date'];

                        showModalBottomSheet(
                          isScrollControlled: true,
                          context: context,
                          builder: (context) => Padding(
                            padding: EdgeInsets.only(
                                bottom: MediaQuery.of(context).viewInsets.bottom),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  child: TextField(
                                    controller: controller.amountController,
                                    decoration: InputDecoration(
                                      hintText: 'Amount',
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  child: TextField(
                                    controller: controller.categoryController,
                                    decoration: InputDecoration(
                                      hintText: 'Category',
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  child: TextField(
                                    controller: controller.notesController,
                                    decoration: InputDecoration(
                                      hintText: 'Notes',
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  child: TextField(
                                    onTap: () async {
                                      DateTime? pickedDate = await showDatePicker(
                                        context: context,
                                        initialDate:
                                            DateTime.parse(expense['date']),
                                        firstDate: DateTime(2000),
                                        lastDate: DateTime(2100),
                                      );

                                      if (pickedDate != null) {
                                        var date = pickedDate;
                                        controller.dateController.text =
                                            date.toString();
                                      }
                                    },
                                    controller: controller.dateController,
                                    decoration: InputDecoration(
                                      hintText: 'Date',
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    controller
                                        .updateExpense(int.parse(id.toString()));
                                    Navigator.pop(context);
                                  },
                                  child: Text("Update Expense"),
                                ),
                              ],
                            ),
                          ),
                        );
                        return false;
                      } else if (direction == DismissDirection.endToStart) {
                        // Delete action
                        controller.delete(int.parse(id.toString()));
                        return true;
                      }
                      return false;
                    },
                    child: ListTile(
                      title: Text(expense['category']),
                      subtitle: Text(expense['notes']),
                      trailing: Text('${expense['amount']}\$'),
                    ),
                  );
                },
                separatorBuilder: (context, index) => Divider(),
                itemCount: controller.expenses.length,
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            isScrollControlled: true,
            context: context,
            builder: (context) => Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: TextField(
                      controller: controller.amountController,
                      decoration: InputDecoration(
                        hintText: 'Amount',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: TextField(
                      controller: controller.categoryController,
                      decoration: InputDecoration(
                        hintText: 'Category',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: TextField(
                      controller: controller.notesController,
                      decoration: InputDecoration(
                        hintText: 'Notes',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: TextField(
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );

                        if (pickedDate != null) {
                          var date = pickedDate;
                          controller.dateController.text = date.toString();
                        }
                      },
                      controller: controller.dateController,
                      decoration: InputDecoration(
                        hintText: 'Date',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      controller.create();
                      Navigator.pop(context);
                    },
                    child: Text("Add Expense"),
                  ),
                ],
              ),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
