import 'package:badyet/DatesBox.dart';
import 'package:badyet/ExpenseItemClass.dart';
import 'package:badyet/ExpenseTodayHistoryBox.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
// import 'package:syncfusion_flutter_charts/charts.dart';

class LatestHistory extends StatefulWidget {
  const LatestHistory({super.key});

  @override
  State<LatestHistory> createState() => _LatestHistory();
}

String savedDayHistory =
    Hive.box('Budget').get("SavedDayHistory", defaultValue: "null");
DateTime today = DateTime.now();

var days = [
  "",
  "Monday",
  "Tuesday",
  "Wednesday",
  "Thursday",
  "Friday",
  "Saturday",
  "Sunday"
];
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
int getDayToday() {
  final now = DateTime.now();
  if (now.weekday == 7) {
    return 7;
  } else {
    return 7 - now.weekday;
  }
}

void addDate(String date) {
  datesBox.add(date);
}

String getMonth() {
  return months[today.month];
}

String dateStr = "${months[today.month]} ${today.day}, ${today.year}";

class _LatestHistory extends State<LatestHistory> {
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
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                  color: Colors.green,
                  gradient: LinearGradient(
                    begin: Alignment.bottomLeft,
                    end: Alignment.topRight,
                    colors: [
                      Color.fromRGBO(52, 119, 216, 1),
                      Color.fromRGBO(81, 218, 96, 1),
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
                            icon: const Icon(
                              Icons.arrow_back_ios,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              Navigator.pop(context, true);
                            },
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          Text(
                            "History",
                            style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                decoration: TextDecoration.none),
                          ),
                        ],
                      ),
                      IconButton(
                        icon: const Icon(
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
                              '${getMonth()} EXPENSES',
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w400,
                                  color:
                                      const Color.fromARGB(255, 255, 255, 255),
                                  fontSize: screenWidth * 0.045,
                                  decoration: TextDecoration.none),
                            ),
                          ],
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            '',
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                fontSize: screenWidth * 0.10,
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
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: screenWidth * 0.09,
                        right: screenWidth * 0.09,
                        top: 20,
                      ),
                      child: Column(
                        children: [
                          const SizedBox(height: 10.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                "",
                                style: GoogleFonts.poppins(
                                    fontSize: 25,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                    decoration: TextDecoration.none),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          const Divider(
                            height:
                                2, // You can adjust the height of the divider
                            color: Color.fromARGB(201, 48, 48, 48),
                          ),
                          const SizedBox(height: 30.0),
                          // Container(
                          //   child: SfCartesianChart(
                          //       // Initialize category axis
                          //       primaryXAxis: CategoryAxis(),
                          //       series: <ChartSeries>[
                          //         // Initialize line series
                          //         LineSeries<SalesData, String>(
                          //             dataSource: [
                          //               // Bind data source
                          //               SalesData('Sun', 0),
                          //               SalesData('Mon', 0),
                          //               SalesData('Tue', 100),
                          //               SalesData('Wed', 150),
                          //               SalesData('Thur', 100),
                          //               SalesData('Fri', 0),
                          //               SalesData('Sat', 0),
                          //             ],
                          //             xValueMapper: (SalesData sales, _) =>
                          //                 sales.year,
                          //             yValueMapper: (SalesData sales, _) =>
                          //                 sales.sales)
                          //       ]),
                          // ),
                          const SizedBox(height: 30.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                "Record",
                                style: GoogleFonts.poppins(
                                    fontSize: 25,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                    decoration: TextDecoration.none),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          const Divider(
                            height:
                                2, // You can adjust the height of the divider
                            color: Color.fromARGB(201, 48, 48, 48),
                          ),
                          const SizedBox(height: 30.0),
                          ValueListenableBuilder<Box>(
                              valueListenable:
                                  expenseTodayHistoryBox.listenable(),
                              builder: (context, box, _) {
                                return ListView.builder(
                                    key: UniqueKey(),
                                    shrinkWrap: true,
                                    itemCount: expenseTodayHistoryBox.length,
                                    itemBuilder: (context, index) {
                                      ExpenseItemClass? item =
                                          expenseTodayHistoryBox.getAt(index);
                                      return Column(children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              item!.date,
                                              style: GoogleFonts.poppins(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.black,
                                                  decoration:
                                                      TextDecoration.none),
                                            ),
                                            Text(
                                              "- Php 100.00",
                                              style: GoogleFonts.poppins(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.black,
                                                  decoration:
                                                      TextDecoration.none),
                                            ),
                                          ],
                                        ),
                                        Column(children: [
                                          SizedBox(
                                            height: screenWidth * 0.04,
                                          ),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Icon(
                                                  Icons.monetization_on_rounded,
                                                  size: screenWidth / 12),
                                              SizedBox(width: screenWidth / 22),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    item.category,
                                                    style: GoogleFonts.poppins(
                                                        fontSize:
                                                            screenWidth * 0.042,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: Colors.black,
                                                        decoration:
                                                            TextDecoration
                                                                .none),
                                                    textAlign: TextAlign.left,
                                                  ),
                                                  Text(
                                                    item.type,
                                                    style: GoogleFonts.poppins(
                                                        fontSize:
                                                            screenWidth * 0.03,
                                                        color: Colors.black,
                                                        decoration:
                                                            TextDecoration
                                                                .none),
                                                  ),
                                                ],
                                              ),
                                              Expanded(
                                                // Use Expanded to take up the remaining space
                                                child: Text(
                                                  "- PHP ${item.price}",
                                                  textAlign: TextAlign.right,
                                                  style: GoogleFonts.poppins(
                                                      fontSize:
                                                          screenWidth * 0.037,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      decoration:
                                                          TextDecoration.none),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: screenWidth * 0.04,
                                          ),
                                        ]),
                                      ]);
                                    });
                              }),
                        ],
                      ),
                    ),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}

// class SalesData {
//   SalesData(this.year, this.sales);
//   final String year;
//   final double sales;
// }







