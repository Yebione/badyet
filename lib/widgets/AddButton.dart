import 'package:flutter/material.dart';

class AddExpenseButton extends StatelessWidget {
  const AddExpenseButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        Navigator.pushNamed(context, '/calculator');
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
