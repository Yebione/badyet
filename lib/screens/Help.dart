import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Help extends StatelessWidget {
  const Help({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Material(
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            Stack(children: [
              Container(
                padding: EdgeInsets.only(
                  left: screenWidth * 0.07,
                  right: screenWidth * 0.07,
                  top: 55,
                ),
                height: MediaQuery.of(context).size.height / 4 +
                    (MediaQuery.of(context).size.height / 13),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
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
                child: Column(children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.arrow_back_ios,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              Navigator.pop(context, true);
                            },
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Text(
                            "Help",
                            style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                decoration: TextDecoration.none),
                          ),
                        ],
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.settings,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            '/settings',
                          );
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: screenWidth * 0.10),
                  Padding(
                    padding: EdgeInsets.only(left: screenWidth / 20),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              'Hello!',
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w700,
                                  color: Color.fromARGB(255, 255, 255, 255),
                                  fontSize: screenWidth * 0.1,
                                  decoration: TextDecoration.none),
                            ),
                          ],
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Thank you for downloading badyet. We will now walk you through our app. ',
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w400,
                                color: Colors.white,
                                fontSize: screenWidth * 0.035,
                                decoration: TextDecoration.none),
                          ),
                        ),
                      ],
                    ),
                  ),
                ]),
              ),
            ]),
            Align(
              alignment: Alignment.bottomCenter,
              child: ConstrainedBox(
                  constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height -
                          (MediaQuery.of(context).size.height / 4 +
                              (MediaQuery.of(context).size.height / 13)),
                      minWidth: MediaQuery.of(context)
                          .size
                          .width // Adjust the maxHeight as needed
                      ),
                  child: SingleChildScrollView(
                    child: Container(
                        child: Padding(
                      padding: EdgeInsets.only(
                        left: screenWidth * 0.09,
                        right: screenWidth * 0.09,
                        top: 20,
                      ),
                      child: Column(
                        children: [
                          SizedBox(
                            height: screenWidth * 0.05,
                          ),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              "Daily Budget Reccommender",
                              style: GoogleFonts.poppins(
                                  fontSize: screenWidth * 0.04,
                                  color: Colors.black,
                                  decoration: TextDecoration.none,
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                          SizedBox(
                            height: screenWidth * 0.08,
                          ),
                          Container(
                            alignment:
                                Alignment.topLeft, // Align to the top-left
                            padding: EdgeInsets.symmetric(
                                horizontal: screenWidth * 0.06,
                                vertical: screenWidth * 0.02),
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
                                        decoration: TextDecoration.none,
                                      ),
                                    ),
                                    Text(
                                      'PHP 250.00',
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                        fontSize: screenWidth * 0.09,
                                        decoration: TextDecoration.none,
                                      ),
                                    ),
                                    SizedBox(
                                      height: screenWidth * 0.02,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: screenWidth * 0.06,
                          ),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              """   Badyet’s main feature is the daily reccomended budget. It works by setting a budget for the week and our algorithm will automatically suggest a budget for the day. Everytime you enter an expense, the daily reccomended budget  automatically recalculates ensuring that you are going to stick to your budget. """,
                              style: GoogleFonts.poppins(
                                fontSize: screenWidth * 0.03,
                                color: Colors.black,
                                decoration: TextDecoration.none,
                                fontWeight: FontWeight.w400,
                              ),
                              textAlign: TextAlign.justify,
                            ),
                          ),
                          SizedBox(
                            height: screenWidth * 0.15,
                          ),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              "Expense Categories",
                              style: GoogleFonts.poppins(
                                  fontSize: screenWidth * 0.04,
                                  color: Colors.black,
                                  decoration: TextDecoration.none,
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                          SizedBox(
                            height: screenWidth * 0.06,
                          ),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              """   With categories, you can now mindfully group your expenses giving you an edge in analyzing your spending habits """,
                              style: GoogleFonts.poppins(
                                fontSize: screenWidth * 0.03,
                                color: Colors.black,
                                decoration: TextDecoration.none,
                                fontWeight: FontWeight.w400,
                              ),
                              textAlign: TextAlign.justify,
                            ),
                          ),
                          SizedBox(
                            height: screenWidth * 0.15,
                          ),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              "Home Expense View",
                              style: GoogleFonts.poppins(
                                  fontSize: screenWidth * 0.04,
                                  color: Colors.black,
                                  decoration: TextDecoration.none,
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                          SizedBox(
                            height: screenWidth * 0.08,
                          ),
                          Container(
                            padding:
                                EdgeInsets.only(top: 30, left: 30, right: 35),
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Expenses Today",
                                            style: GoogleFonts.poppins(
                                                color: Colors.grey[850],
                                                fontSize: screenWidth / 22,
                                                fontWeight: FontWeight.bold,
                                                decoration:
                                                    TextDecoration.none),
                                          ),
                                          Text(
                                            "PHP. 130.00",
                                            textAlign: TextAlign.left,
                                            style: GoogleFonts.poppins(
                                                color: Colors.grey[850],
                                                fontSize: screenWidth / 24,
                                                decoration:
                                                    TextDecoration.none),
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
                                SizedBox(
                                    height: 16), // Adjust the height as needed
                                Divider(
                                  height:
                                      2, // You can adjust the height of the divider
                                  color: const Color.fromARGB(201, 48, 48, 48),
                                ),
                                SizedBox(height: 25),
                                Column(
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Icon(Icons.fastfood,
                                            size: screenWidth / 12),
                                        SizedBox(width: screenWidth / 22),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Food",
                                              style: TextStyle(
                                                fontSize: screenWidth * 0.042,
                                                fontWeight: FontWeight.w900,
                                                decoration: TextDecoration.none,
                                                color: Colors.black,
                                              ),
                                              textAlign: TextAlign.left,
                                            ),
                                            Text(
                                              "Siomai",
                                              style: GoogleFonts.poppins(
                                                  fontSize: screenWidth * 0.03,
                                                  color: Colors.black,
                                                  decoration:
                                                      TextDecoration.none),
                                            ),
                                          ],
                                        ),
                                        Expanded(
                                          // Use Expanded to take up the remaining space
                                          child: Text(
                                            "- PHP 30.00",
                                            textAlign: TextAlign.right,
                                            style: GoogleFonts.poppins(
                                                fontSize: screenWidth * 0.037,
                                                color: Colors.black,
                                                decoration:
                                                    TextDecoration.none),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 18),
                                  ],
                                )
                              ],
                            ),
                          ),
                          SizedBox(height: screenWidth * 0.07),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              """   Keep track of what you spend throughout the day with the home expense view. With meaningful icons and description, it will be the tool to make you mindful about how you spend your money.  """,
                              style: GoogleFonts.poppins(
                                fontSize: screenWidth * 0.03,
                                color: Colors.black,
                                decoration: TextDecoration.none,
                                fontWeight: FontWeight.w400,
                              ),
                              textAlign: TextAlign.justify,
                            ),
                          ),
                          SizedBox(
                            height: screenWidth * 0.15,
                          ),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              "Insights",
                              style: GoogleFonts.poppins(
                                  fontSize: screenWidth * 0.04,
                                  color: Colors.black,
                                  decoration: TextDecoration.none,
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                          SizedBox(height: screenWidth * 0.06),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              """   With informative graphs, you can now check your weekly spending habits in birds eye view!  """,
                              style: GoogleFonts.poppins(
                                fontSize: screenWidth * 0.03,
                                color: Colors.black,
                                decoration: TextDecoration.none,
                                fontWeight: FontWeight.w400,
                              ),
                              textAlign: TextAlign.justify,
                            ),
                          ),
                          SizedBox(
                            height: screenWidth * 0.15,
                          ),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              "Dark Mode!",
                              style: GoogleFonts.poppins(
                                  fontSize: screenWidth * 0.04,
                                  color: Colors.black,
                                  decoration: TextDecoration.none,
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                          SizedBox(height: screenWidth * 0.06),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              """   To all of dark mode supremacist, we have it!   """,
                              style: GoogleFonts.poppins(
                                fontSize: screenWidth * 0.03,
                                color: Colors.black,
                                fontWeight: FontWeight.w400,
                                decoration: TextDecoration.none,
                              ),
                              textAlign: TextAlign.justify,
                            ),
                          ),
                          SizedBox(
                            height: screenWidth / 4,
                          ),
                          Center(
                            child: Text(
                              """   MASHAKYJA SOLUTIONS ©   """,
                              style: GoogleFonts.poppins(
                                fontSize: screenWidth * 0.03,
                                color: Colors.black,
                                decoration: TextDecoration.none,
                              ),
                              textAlign: TextAlign.justify,
                            ),
                          ),
                          SizedBox(
                            height: screenWidth / 20,
                          ),
                        ],
                      ),
                    )),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
