import 'package:flutter/material.dart';

class AddExpenseButton extends StatelessWidget {
  const AddExpenseButton({super.key});

  @override
  Widget build(BuildContext context) {
    return 
      FloatingActionButton(
        onPressed: () {},
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