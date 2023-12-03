import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ExpenseItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.fastfood, size: screenWidth/12),
            SizedBox(width: screenWidth/22),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Food",
                  style: TextStyle(
                    fontSize: screenWidth *0.042,
                    fontWeight: FontWeight.w900,
                  ),
                  textAlign: TextAlign.left,
                ),
                Text(
                  "Siomai",
                  style: TextStyle(
                    fontSize: screenWidth *0.03,
                  ),
                ),
              ],
            ),
            Expanded(
              // Use Expanded to take up the remaining space
              child: Text("- PHP 30.00", textAlign: TextAlign.right, style: GoogleFonts.poppins(fontSize: screenWidth *0.037,),),
            ),
          ],
        ),
        SizedBox(height: 18),
      ],
    );
  }
}
