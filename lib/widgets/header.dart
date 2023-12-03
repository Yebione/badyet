import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Header extends StatelessWidget {
  const Header({Key? key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: [
              Container(
                
                height: screenWidth / 10,
                width: screenWidth / 10,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset('assets/images/avatar.jpg'),
                ),
              ),

              SizedBox(width: 20,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Today is Thursday',
                    style: GoogleFonts.poppins(
                      color: Colors.green[400],
                      fontSize: screenWidth * 0.045,
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.left,
                  ),
                  Text(
                    'September 11',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: screenWidth * 0.035,
                      fontWeight: FontWeight.normal,
                      fontFamily: GoogleFonts.poppins().fontFamily,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.all(
               screenWidth * 0.001),
            child: Container(
              // Adjust the maximum width as needed
              child: TextButton(
                onPressed: () {
                  // Your button's action goes here
                },
                style: TextButton.styleFrom(
                  primary: Colors.grey.shade300,
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  textStyle: GoogleFonts.poppins(
                    fontSize: screenWidth * 0.029,
                    fontWeight: FontWeight.w500,                    
                  ),
                  backgroundColor: Colors.grey.shade700,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text("HELP"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
