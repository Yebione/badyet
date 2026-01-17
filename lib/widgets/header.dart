import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

var dayOfTheWeek = [
  "",
  "Monday",
  "Tuesday",
  "Wednesday",
  "Thursday",
  "Friday",
  "Saturday",
  "Sunday"
];

class header extends StatefulWidget {
  const header({super.key});

  @override
  State<header> createState() => _header();
}

var months = [
  "",
  "January",
  "February",
  "March",
  "April",
  "May",
  "June",
  "July",
  "August",
  "September",
  "October",
  "November",
  "December"
];

class _header extends State<header> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    DateTime now = DateTime.now();
    int day = now.weekday;
    String dayToday = dayOfTheWeek[day];

    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: [
              SizedBox(
                height: screenWidth / 10,
                width: screenWidth / 10,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset('assets/images/avatar.png'),
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Today is $dayToday',
                    style: GoogleFonts.poppins(
                      color: Color.fromRGBO(34, 139, 34, 1),
                      fontSize: screenWidth * 0.045,
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.left,
                  ),
                  Text(
                    "${months[now.month]} ${now.day}, ${now.year}",
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
        ],
      ),
    );
  }
}
