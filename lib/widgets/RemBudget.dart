import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RemBudget extends StatelessWidget {
  const RemBudget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Container(
      alignment: Alignment.topLeft, // Align to the top-left
      padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.06, vertical: screenWidth * 0.02),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
          colors: [
            const Color.fromRGBO(52, 119, 216, 1),
            const Color.fromRGBO(81, 218, 96, 1)
          ],
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: screenWidth * 0.035,
              ),
              Text(
                'REMAINING BUDGET FOR TODAY',
                style: TextStyle(
                  fontWeight: FontWeight.w300,
                  color: Colors.white,
                  fontSize: screenWidth * 0.03,
                ),
              ),
              Text(
                'PHP 999.00',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  fontSize: screenWidth * 0.09,
                ),
              ),
              SizedBox(
                height: screenWidth * 0.02,
              ),
            ],
          ),
          IconButton(
            icon: Icon(Icons.edit_rounded,
                color: Colors.white, size: screenWidth * 0.084),
            onPressed: () {},
          )
        ],
      ),
    );
  }
}
