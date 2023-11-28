import 'package:flutter/material.dart';

class ExpenseItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.fastfood, size: 37),
            SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Food",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                  ),
                  textAlign: TextAlign.left,
                ),
                Text(
                  "Siomai",
                  style: TextStyle(
                    fontSize: 13,
                  ),
                ),
              ],
            ),
            Expanded(
              // Use Expanded to take up the remaining space
              child: Text("- PHP 30.00", textAlign: TextAlign.right),
            ),
          ],
        ),
        SizedBox(height: 18),
      ],
    );
  }
}
