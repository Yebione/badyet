import 'package:badyet/widgets/HomeExpenseView.dart';
import 'package:flutter/material.dart';

class AddExpenseButton extends StatefulWidget {
  const AddExpenseButton({super.key});

  @override
  State<AddExpenseButton> createState() => _AddExpenseButton();
}

class _AddExpenseButton extends State<AddExpenseButton> {
  final TextEditingController controller = TextEditingController();
  final TextEditingController addTypeController = TextEditingController();
  final TextEditingController addPriceController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        showDialogExpense(context, addTypeController, addPriceController);
      },
      backgroundColor: Colors.transparent,
      shape: const CircleBorder(eccentricity: 0.0),
      child: Container(
        width: 80,
        height: 80,
        decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(colors: [
              Color.fromRGBO(53, 122, 213, 1),
              Color.fromRGBO(81, 218, 96, 1)
            ])),
        child: const Icon(
          Icons.add,
          size: 40,
          color: Colors.white,
        ),
      ),
      //icon inside button
    );
  }
}
