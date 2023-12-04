// my_history_page.dart
import 'dart:developer' as developer;
import 'package:badyet/widgets/ExpenseItem.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyHistoryPage extends StatefulWidget {
  @override
  _MyHistoryPageState createState() => _MyHistoryPageState();
}

class _MyHistoryPageState extends State<MyHistoryPage> {
  double _blueContainerTopMargin = 50.0;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(
        children: [

        Container(
              height: MediaQuery.of(context).size.height / 2 - 10,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.green,
                gradient: LinearGradient(
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight,
                  colors: [
                    const Color.fromRGBO(52, 119, 216, 1),
                    const Color.fromRGBO(81, 218, 96, 1),
                  ],
                ),
              ),
            ),
          

          SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height / 2 -
                      (MediaQuery.of(context).size.height / 5),
                  color: Colors.transparent,
                ),
                Container(
                  margin: EdgeInsets.only(top: _blueContainerTopMargin),
                  width: screenWidth,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30.0),
                      topRight: Radius.circular(40.0),
                    ),
                  ),
                  padding: EdgeInsets.only(
                    left: screenWidth * 0.09,
                    right: screenWidth * 0.09,
                    top: 16,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        children: [
                          Container(
                            width: 90,
                            height: 6,
                            decoration: BoxDecoration(
                              color: Colors.grey[700],
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),

                          SizedBox(height: 30.0),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                "Record",
                                style: GoogleFonts.poppins(
                                    fontSize: 25, fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),

                          Divider(
                            height:
                                2, // You can adjust the height of the divider
                            color: const Color.fromARGB(201, 48, 48, 48),
                          ),
                          SizedBox(height: 30.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "September 04, 2023",
                                style: GoogleFonts.poppins(
                                    fontSize: 15, fontWeight: FontWeight.w500),
                              ),
                              Text(
                                "- Php 60.00",
                                style: GoogleFonts.poppins(
                                    fontSize: 15, fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                          SizedBox(height: 30.0),

                          ExpenseItem(),
                          ExpenseItem(),

                          SizedBox(height: 30.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "September 01, 2023",
                                style: GoogleFonts.poppins(
                                    fontSize: 15, fontWeight: FontWeight.w500),
                              ),
                              Text(
                                "- Php 90.00",
                                style: GoogleFonts.poppins(
                                    fontSize: 15, fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                          SizedBox(height: 30.0),

                          ExpenseItem(),
                          ExpenseItem(),
                          ExpenseItem(),

                          SizedBox(height: 1000.0),
                          // Add other contents inside the blue container
                          Text(
                            'Lorem ipsum dolor sit amet, consectetur adipiscing elit. '
                            '...',
                            style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      // Add more widgets as needed
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              left: screenWidth * 0.07,
              right: screenWidth * 0.07,
              top: 50,
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
                          onPressed: () => Navigator.pop(context),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Text(
                          "History",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          '/settings',
                        );
                      },
                      color: Colors.white,
                      icon: Icon(
                        Icons.settings,
                      
                      )),
                  ],
                ),
                SizedBox(height: 45),
                Row(
                  children: [
                    Text(
                      'SEPTEMBER EXPENSES',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        color: Color.fromARGB(255, 255, 255, 255),
                        fontSize: 17,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Icon(
                      Icons.arrow_drop_down,
                      color: Colors.white,
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'PHP 9999.99',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      fontSize: screenWidth * 0.11,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
