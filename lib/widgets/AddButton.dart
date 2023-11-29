import 'dart:js_util';

import 'package:flutter/material.dart';

void Toast(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(text),
  ));
}

void ShowDialog(BuildContext context, TextEditingController controller) {
  void AddBudget() {
    Toast(context, controller.text);
    Navigator.of(context).pop();
  }

  void Cancel() {
    Navigator.of(context).pop();
  }

  showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: Text("Add Budget"),
            content: TextField(
              controller: controller,
              autofocus: true,
              decoration: InputDecoration(hintText: 'Amount'),
            ),
            actions: [
              TextButton(onPressed: Cancel, child: Text('Cancel')),
              TextButton(onPressed: AddBudget, child: Text('Add'))
            ],
          ));
}

class AddExpenseButton extends StatefulWidget {
  const AddExpenseButton({super.key});

  @override
  State<AddExpenseButton> createState() => _AddExpenseButton();
}

class _AddExpenseButton extends State<AddExpenseButton> {
  final addBudgetController = TextEditingController();

  @override
  void dispose() {
    addBudgetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        ShowDialog(context, addBudgetController);
      },
      backgroundColor: Colors.transparent,
      shape: CircleBorder(eccentricity: 0.0),
      child: Container(
        width: 80,
        height: 80,
        child: Icon(
          Icons.add,
          size: 40,
        ),
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(colors: [
              const Color.fromRGBO(53, 122, 213, 1),
              const Color.fromRGBO(81, 218, 96, 1)
            ])),
      ),
      //icon inside button
    );
  }
}
