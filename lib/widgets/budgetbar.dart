import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class budgetBar extends StatelessWidget {
  const budgetBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: 10,
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            child: LinearProgressIndicator(
              value: 0.7,
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF3478D7)),
              backgroundColor: Color(0xffD6D6D6),
            ),
          ),
        ),
        SizedBox(
          height: 5,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "₱ 2,250.00",
              style: GoogleFonts.poppins(fontSize: 12, fontStyle: FontStyle.italic),
            ),
            Text(
              "₱ 3,000.00",
              style: GoogleFonts.poppins(fontSize: 12, fontStyle: FontStyle.italic),
            )
          ],
        )
      ],
    );
  }
}
