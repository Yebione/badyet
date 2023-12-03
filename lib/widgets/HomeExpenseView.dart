import 'package:badyet/widgets/ExpenseItem.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class ExpenseContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    String test = "PHP 290.00";
    return Container(
      margin: EdgeInsets.only(top: 35),
      padding: EdgeInsets.only(top: 30, left: 30, right: 35),
      width: screenWidth,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Color.fromARGB(71, 192, 192, 192),
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
                      style: GoogleFonts.poppins(
                          color: Colors.grey[850],
                          fontSize: screenWidth / 22,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      test,
                      textAlign: TextAlign.left,
                      style: GoogleFonts.poppins(
                          color: Colors.grey[850], fontSize: screenWidth / 24),
                    ),
                  ],
                ),
                IconButton(
                    icon: Icon(
                      Icons.add_circle_rounded,
                      size: screenWidth * 0.07,
                    ),
                    onPressed: () {}),
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
          
        ],
      ),
    );
  }
}
