import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class noExpense extends StatelessWidget {
  const noExpense({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Column(
      children: [
        SizedBox(height: MediaQuery.of(context).size.height/6,),
        Container(
          width: screenWidth*0.25, 
          height: screenWidth*0.25, 
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/thinking.png'),
              fit: BoxFit.fill,
            ),
          ),
        ),
        SizedBox(height: screenWidth*0.08, ),
        Text(
          '''Looks like you don’t\n have expenses yet...''',
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            color: const Color(0xFF4D4D4D),
            fontSize: screenWidth*0.05,            
            fontWeight: FontWeight.w700,
           
          ),
        )
      ],
    );
  }
}
