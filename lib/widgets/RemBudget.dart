import 'dart:math';
import 'package:badyet/ExpensesTodayBox.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';

class RemBudget extends StatefulWidget {
  const RemBudget({super.key});

  @override
  State<RemBudget> createState() => _RemBudget();
}

class _RemBudget extends State<RemBudget> {
  final addBudgetController = TextEditingController();

  final box = Hive.box('Budget');
  double recBudgetToday =
      Hive.box('Budget').get("RecBudgetToday", defaultValue: 0.0);
  String savedDay = Hive.box('Budget').get("SavedDay", defaultValue: "null");
  double totalBudget = Hive.box('Budget').get("TotalBudget", defaultValue: 0.0);
  double totalBudgetAdded =
      Hive.box('Budget').get("TotalBudgetAdded", defaultValue: 0.0);
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

  String generateKey(int len) {
    var r = Random();
    const chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    return List.generate(len, (index) => chars[r.nextInt(chars.length)]).join();
  }

  int getDayToday() {
    final now = DateTime.now();
    if (now.weekday == 7) {
      return 7;
    } else {
      return 7 - now.weekday;
    }
  }

  void clearExpensesToday() {
    expenseTodayBox.clear();
  }

  void saveDayToday(String value) {
    box.put("SavedDay", value);
  }

  void saveTotalBudget(double value) {
    box.put("TotalBudget", value);
  }

  void saveTotalBudgetAdded(double value) {
    box.put("TotalBudgetAdded", value);
  }

  void saveRecBudget(double value) {
    box.put("RecBudgetToday", value);
  }

  String getSavedDay() {
    return box.get("SavedDay", defaultValue: "new");
  }

  double getTotalBudget() {
    return box.get("TotalBudget", defaultValue: 0.0);
  }

  double getTotalBudgetAdded() {
    return box.get("TotalBudgetAdded", defaultValue: 0.0);
  }

  double getRecBudgetToday() {
    return box.get("RecBudgetToday", defaultValue: 0.0);
  }

  void calculateRecommended() {
    double temp = getTotalBudget();
    if (temp != 0) {
      recBudgetToday = getTotalBudget() / getDayToday();
      saveRecBudget(recBudgetToday);
    }
  }

  void addBudgetHandler(TextEditingController controller) {
    saveTotalBudget(getTotalBudget() + double.parse(controller.text));
    saveTotalBudgetAdded(getTotalBudgetAdded() + double.parse(controller.text));
    calculateRecommended();
    saveRecBudget(recBudgetToday);
  }

  void addBudget(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text("Add Budget"),
              content: TextField(
                controller: addBudgetController,
                autofocus: true,
                decoration: const InputDecoration(hintText: 'Amount'),
              ),
              actions: [
                TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancel')),
                TextButton(
                    onPressed: () {
                      setState(() {
                        addBudgetHandler(addBudgetController);
                        recBudgetToday = getRecBudgetToday();
                      });
                      Navigator.of(context).pop();
                    },
                    child: const Text('Add'))
              ],
            ));
  }

  void loadData() {
    if (savedDay == "null") {
      saveDayToday(days[getDayToday()]);
    } else if (savedDay != "null" && savedDay != days[getDayToday()]) {
      clearExpensesToday();
      saveDayToday(days[getDayToday()]);
      calculateRecommended();
    }
  }

  @override
  void initState() {
    loadData();
    super.initState();
  }

  @override
  void dispose() {
    addBudgetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return ValueListenableBuilder<Box>(
      valueListenable: Hive.box('Budget').listenable(),
      builder: (context, box, _) {
        return Column(
          children: [
            // Gradient container with main budget
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: const LinearGradient(
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight,
                  colors: [
                    Color.fromRGBO(52, 119, 216, 1),
                    Color.fromRGBO(81, 218, 96, 1)
                  ],
                ),
              ),
              child: Row(
                children: [
                  // Budget content
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                        top: screenWidth * 0.04,
                        bottom: screenWidth * 0.04,
                        left: screenWidth * 0.06,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'REMAINING FOR THE WEEK',
                            style: TextStyle(
                              fontWeight: FontWeight.w300,
                              color: Colors.white,
                              fontSize: screenWidth * 0.035,
                            ),
                          ),
                          Text(
                            'P ${getRecBudgetToday().round().toString()}',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              fontSize: screenWidth * 0.11,
                            ),
                          ),
                          SizedBox(height: screenWidth * 0.02),
                          Row(
                            children: [
                              Text(
                                'Recommended: ',
                                style: TextStyle(
                                  fontWeight: FontWeight.w300,
                                  color: Colors.white.withOpacity(0.8),
                                  fontSize: screenWidth * 0.035,
                                ),
                              ),
                              Text(
                                'P 2,500',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                  fontSize: screenWidth * 0.035,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Edit button on the right, centered vertically
                  Padding(
                    padding: EdgeInsets.only(right: screenWidth * 0.03),
                    child: IconButton(
                      icon: Icon(Icons.edit_rounded,
                          color: Colors.white, size: screenWidth * 0.06),
                      onPressed: () {
                        addBudget(context);
                      },
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: screenWidth * 0.05),
            // White container with stats
            Container(
              padding: EdgeInsets.all(screenWidth * 0.045),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Month Budget:',
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          color: Colors.grey[600],
                          fontSize: screenWidth * 0.035,
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            'P 15,000',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                              fontSize: screenWidth * 0.035,
                            ),
                          ),
                          Text(
                            ' / 20,000',
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              color: Colors.grey[500],
                              fontSize: screenWidth * 0.035,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: screenWidth * 0.025),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Luxury Budget:',
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          color: Colors.grey[600],
                          fontSize: screenWidth * 0.035,
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            'P 5,000',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                              fontSize: screenWidth * 0.035,
                            ),
                          ),
                          Text(
                            ' / 10,000',
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              color: Colors.grey[500],
                              fontSize: screenWidth * 0.035,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: screenWidth * 0.025),
                  Divider(
                    height: 1,
                    color: Colors.grey[300],
                  ),
                  SizedBox(height: screenWidth * 0.025),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total Month Spend:',
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          color: Colors.grey[600],
                          fontSize: screenWidth * 0.035,
                        ),
                      ),
                      Text(
                        'P 8,350',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                          fontSize: screenWidth * 0.035,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
