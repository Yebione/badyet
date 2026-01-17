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
  final monthBudgetController = TextEditingController();
  final luxuryBudgetController = TextEditingController();

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

  double getMonthBudget() {
    return box.get("MonthBudget", defaultValue: 0.0);
  }

  double getLuxuryBudget() {
    return box.get("LuxuryBudget", defaultValue: 0.0);
  }

  void saveMonthBudget(double value) {
    box.put("MonthBudget", value);
  }

  void saveLuxuryBudget(double value) {
    box.put("LuxuryBudget", value);
  }

  int getRemainingDaysInMonth() {
    final now = DateTime.now();
    final lastDay = DateTime(now.year, now.month + 1, 0);
    return lastDay.day - now.day + 1;
  }

  double calculateWeekBudget() {
    double monthBudget = getMonthBudget();
    int remainingDays = getRemainingDaysInMonth();
    // Calculate daily budget and multiply by 7 for week
    double dailyBudget = monthBudget / remainingDays;
    return dailyBudget * 7;
  }

  void calculateRecommended() {
    double weekBudget = calculateWeekBudget();
    if (weekBudget > 0) {
      recBudgetToday = weekBudget;
      saveRecBudget(recBudgetToday);
    }
  }

  void saveBudgetHandler() {
    double monthBudget = double.tryParse(monthBudgetController.text) ?? 0;
    double luxuryBudget = double.tryParse(luxuryBudgetController.text) ?? 0;

    saveMonthBudget(monthBudget);
    saveLuxuryBudget(luxuryBudget);
    saveTotalBudget(monthBudget);
    calculateRecommended();
  }

  void showEditBudgetModal(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    // Pre-fill with current values
    monthBudgetController.text = getMonthBudget() > 0 ? getMonthBudget().round().toString() : '';
    luxuryBudgetController.text = getLuxuryBudget() > 0 ? getLuxuryBudget().round().toString() : '';

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: screenWidth * 0.03),
              Container(
                width: screenWidth * 0.1,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              SizedBox(height: screenWidth * 0.04),
              Text(
                'Edit Budget',
                style: GoogleFonts.poppins(
                  fontSize: screenWidth * 0.045,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: screenWidth * 0.04),

              // Month Budget Input
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Month Budget',
                      style: GoogleFonts.poppins(
                        fontSize: screenWidth * 0.035,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[700],
                      ),
                    ),
                    SizedBox(height: screenWidth * 0.02),
                    TextField(
                      controller: monthBudgetController,
                      keyboardType: TextInputType.number,
                      style: GoogleFonts.poppins(fontSize: screenWidth * 0.04),
                      decoration: InputDecoration(
                        hintText: 'Enter amount',
                        hintStyle: GoogleFonts.poppins(
                          color: Colors.grey[400],
                          fontSize: screenWidth * 0.04,
                        ),
                        prefixText: 'P ',
                        prefixStyle: GoogleFonts.poppins(
                          color: Colors.black87,
                          fontSize: screenWidth * 0.04,
                        ),
                        filled: true,
                        fillColor: Colors.grey[100],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.04,
                          vertical: screenWidth * 0.035,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: screenWidth * 0.04),

              // Luxury Budget Input
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Luxury Budget',
                      style: GoogleFonts.poppins(
                        fontSize: screenWidth * 0.035,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[700],
                      ),
                    ),
                    SizedBox(height: screenWidth * 0.02),
                    TextField(
                      controller: luxuryBudgetController,
                      keyboardType: TextInputType.number,
                      style: GoogleFonts.poppins(fontSize: screenWidth * 0.04),
                      decoration: InputDecoration(
                        hintText: 'Enter amount',
                        hintStyle: GoogleFonts.poppins(
                          color: Colors.grey[400],
                          fontSize: screenWidth * 0.04,
                        ),
                        prefixText: 'P ',
                        prefixStyle: GoogleFonts.poppins(
                          color: Colors.black87,
                          fontSize: screenWidth * 0.04,
                        ),
                        filled: true,
                        fillColor: Colors.grey[100],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.04,
                          vertical: screenWidth * 0.035,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: screenWidth * 0.06),

              // Save Button
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      saveBudgetHandler();
                      recBudgetToday = getRecBudgetToday();
                    });
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: screenWidth * 0.04),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color.fromRGBO(52, 119, 216, 1),
                          Color.fromRGBO(81, 218, 96, 1),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        'Save',
                        style: GoogleFonts.poppins(
                          fontSize: screenWidth * 0.04,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: screenWidth * 0.06),
            ],
          ),
        ),
      ),
    );
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
    monthBudgetController.dispose();
    luxuryBudgetController.dispose();
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
