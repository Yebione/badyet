import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AddExpenseButton extends StatelessWidget {
  const AddExpenseButton({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return 
      Container(
            height: screenWidth/6,
            width: screenWidth/6,
            child: FittedBox(
              child: ClipOval(
                child: FloatingActionButton(
                    onPressed: () {},
                    child: Container(
                      height: screenWidth/5,
                      width: screenWidth/5,
                      child: Center(child: Text("+",  style: GoogleFonts.poppins (fontSize: screenWidth/11, fontWeight: FontWeight.w600, color: Colors.white))),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(colors: [
                            const Color.fromRGBO(53, 122, 213, 1),
                            const Color.fromRGBO(81, 218, 96, 1)
                          ])),
                    )

                    
                    ),
              ),
            ),
          );
  }
}