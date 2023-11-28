import 'package:badyet/screens/ExpenseItem.dart';
import 'package:flutter/material.dart';

class ExpenseContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(30),
      padding: EdgeInsets.only(top: 30, left: 30, right: 35),
      width: 365,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Color.fromARGB(204, 196, 196, 196),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Expenses Today",
                      style: TextStyle(
                          color: Colors.grey[850],
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "PHP 290.00",
                      textAlign: TextAlign.left,
                      style: TextStyle(color: Colors.grey[850]),
                    ),
                  ],
                ),
                Container(
                  width: 26.0,
                  height: 26.0,
                  padding: EdgeInsets.all(1),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: Colors.grey[850]),
                  child: Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 15,
                  ),
                )
              ],
            ),
          ),
          SizedBox(height: 16), // Adjust the height as needed
          Divider(
            height: 2, // You can adjust the height of the divider
            color: const Color.fromARGB(201, 48, 48, 48),
          ),
          SizedBox(height: 25),

          ExpenseItem(),
          ExpenseItem(),
          ExpenseItem(),
          ExpenseItem(),
          ExpenseItem(),
          ExpenseItem(),
          ExpenseItem(),
          ExpenseItem(),
        ],
      ),
    );
  }
}
