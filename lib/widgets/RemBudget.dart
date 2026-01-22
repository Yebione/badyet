import 'dart:math';
import 'package:badyet/ExpensesTodayBox.dart';
import 'package:badyet/ExpenseTodayHistoryBox.dart';
import 'package:badyet/screens/Settings.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';

class RemBudget extends StatefulWidget {
  final DateTime? selectedDate;

  const RemBudget({super.key, this.selectedDate});

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
  String savedMonth =
      Hive.box('Budget').get("SavedMonth", defaultValue: "null");
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
    return now.weekday; // 1 = Monday, 7 = Sunday - matches days array
  }

  void clearExpensesToday() {
    expenseTodayBox.clear();
  }

  void saveDayToday(String value) {
    box.put("SavedDay", value);
  }

  void saveMonthToday(String value) {
    box.put("SavedMonth", value);
  }

  String getSavedMonth() {
    return box.get("SavedMonth", defaultValue: "new");
  }

  String getCurrentMonth() {
    final now = DateTime.now();
    return "${now.year}-${now.month}";
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

  double getOriginalLuxuryBudget() {
    double original = box.get("OriginalLuxuryBudget", defaultValue: 0.0);
    // If OriginalLuxuryBudget is not set, use current LuxuryBudget as fallback
    // This should only happen on first load before budget is set
    if (original == 0.0) {
      double current = getLuxuryBudget();
      // Only use current as original if it's greater than 0 and hasn't been spent
      // This is a fallback for cases where OriginalLuxuryBudget wasn't initialized
      return current > 0 ? current : 0.0;
    }
    return original;
  }

  double getTotalExpenses() {
    return box.get("TotalExpensesWeek", defaultValue: 0.0);
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

  double getMonthExpenses() {
    double total = 0;
    final now = DateTime.now();

    for (var item in expenseTodayHistoryBox.values) {
      // Skip income, transfers, and luxury expenses (luxury has its own budget)
      if (item.category == 'Income' ||
          item.category == 'Transfer' ||
          SettingsPage.isLuxuryCategory(item.category)) continue;

      try {
        DateTime date;
        String dateStr = item.date;

        if (dateStr.contains('-')) {
          date = DateTime.parse(dateStr);
        } else if (dateStr.contains('/')) {
          List<String> parts = dateStr.split('/');
          if (parts.length == 3) {
            date = DateTime(
                int.parse(parts[2]), int.parse(parts[0]), int.parse(parts[1]));
          } else {
            continue;
          }
        } else {
          continue;
        }

        // Only count expenses from current month
        if (date.year == now.year && date.month == now.month) {
          total += double.tryParse(item.price) ?? 0;
        }
      } catch (e) {
        continue;
      }
    }
    return total;
  }

  double calculateSuggestedDaily() {
    double monthBudget = getMonthBudget();
    double monthExpenses = getMonthExpenses();
    int remainingDays = getRemainingDaysInMonth();

    // Suggested daily = remaining budget / remaining days
    double remainingBudget = monthBudget - monthExpenses;
    if (remainingDays <= 0) return 0;
    return remainingBudget / remainingDays;
  }

  String _formatDateForComparison(DateTime date) {
    return "${date.month}/${date.day}/${date.year}";
  }

  bool _matchesDate(String itemDate, DateTime targetDate) {
    try {
      DateTime date;
      if (itemDate.contains('-')) {
        date = DateTime.parse(itemDate);
      } else if (itemDate.contains('/')) {
        List<String> parts = itemDate.split('/');
        if (parts.length == 3) {
          date = DateTime(
              int.parse(parts[2]), int.parse(parts[0]), int.parse(parts[1]));
        } else {
          return false;
        }
      } else {
        return false;
      }
      return date.year == targetDate.year &&
          date.month == targetDate.month &&
          date.day == targetDate.day;
    } catch (e) {
      return false;
    }
  }

  double getTodayExpenses() {
    double total = 0;
    DateTime targetDate = widget.selectedDate ?? DateTime.now();

    // If viewing today, use expenseTodayBox, otherwise filter from history
    if (widget.selectedDate == null ||
        (targetDate.year == DateTime.now().year &&
            targetDate.month == DateTime.now().month &&
            targetDate.day == DateTime.now().day)) {
      // Viewing today - use expenseTodayBox
      for (var item in expenseTodayBox.values) {
        if (item.category != 'Income' &&
            item.category != 'Transfer' &&
            !SettingsPage.isLuxuryCategory(item.category)) {
          total += double.tryParse(item.price) ?? 0;
        }
      }
    } else {
      // Viewing past date - filter from history
      for (var item in expenseTodayHistoryBox.values) {
        if (_matchesDate(item.date, targetDate) &&
            item.category != 'Income' &&
            item.category != 'Transfer' &&
            !SettingsPage.isLuxuryCategory(item.category)) {
          total += double.tryParse(item.price) ?? 0;
        }
      }
    }
    return total;
  }

  void calculateRecommended() {
    double dailyBudget = calculateSuggestedDaily();
    if (dailyBudget > 0) {
      recBudgetToday = dailyBudget;
      saveRecBudget(recBudgetToday);
    }
  }

  void saveBudgetHandler() {
    double monthBudget = double.tryParse(monthBudgetController.text) ?? 0;
    double luxuryBudget = double.tryParse(luxuryBudgetController.text) ?? 0;

    saveMonthBudget(monthBudget);
    saveLuxuryBudget(luxuryBudget);
    // Store the original luxury budget for month-end reset
    box.put("OriginalLuxuryBudget", luxuryBudget);
    saveTotalBudget(monthBudget);
    calculateRecommended();
  }

  void showEditBudgetModal(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Pre-fill with current values
    monthBudgetController.text = getMonthBudget().round().toString();
    luxuryBudgetController.text = getLuxuryBudget().round().toString();

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
        child: Container(
          decoration: BoxDecoration(
            color: isDark ? Color(0xFF1E1E1E) : Colors.white,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Padding(
            padding: EdgeInsets.all(screenWidth * 0.06),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Edit Budget',
                  style: GoogleFonts.poppins(
                    fontSize: screenWidth * 0.045,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                SizedBox(height: screenWidth * 0.05),

                // Month Budget Input
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Month Budget',
                      style: GoogleFonts.poppins(
                        fontSize: screenWidth * 0.035,
                        fontWeight: FontWeight.w500,
                        color: isDark ? Colors.grey[400] : Colors.grey[700],
                      ),
                    ),
                    SizedBox(height: screenWidth * 0.02),
                    TextField(
                      controller: monthBudgetController,
                      keyboardType: TextInputType.number,
                      style: GoogleFonts.poppins(
                        fontSize: screenWidth * 0.04,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Enter amount',
                        hintStyle: GoogleFonts.poppins(
                          color: isDark ? Colors.grey[500] : Colors.grey[400],
                          fontSize: screenWidth * 0.04,
                        ),
                        prefixIcon: Padding(
                          padding: EdgeInsets.only(
                              left: screenWidth * 0.04,
                              right: screenWidth * 0.01),
                          child: Text(
                            'P',
                            style: GoogleFonts.poppins(
                              color: isDark ? Colors.white : Colors.black87,
                              fontSize: screenWidth * 0.04,
                            ),
                          ),
                        ),
                        prefixIconConstraints:
                            BoxConstraints(minWidth: 0, minHeight: 0),
                        filled: true,
                        fillColor: isDark ? Colors.grey[800] : Colors.grey[100],
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

                SizedBox(height: screenWidth * 0.04),

                // Luxury Budget Input
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Luxury Budget',
                      style: GoogleFonts.poppins(
                        fontSize: screenWidth * 0.035,
                        fontWeight: FontWeight.w500,
                        color: isDark ? Colors.grey[400] : Colors.grey[700],
                      ),
                    ),
                    SizedBox(height: screenWidth * 0.02),
                    TextField(
                      controller: luxuryBudgetController,
                      keyboardType: TextInputType.number,
                      style: GoogleFonts.poppins(
                        fontSize: screenWidth * 0.04,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Enter amount',
                        hintStyle: GoogleFonts.poppins(
                          color: isDark ? Colors.grey[500] : Colors.grey[400],
                          fontSize: screenWidth * 0.04,
                        ),
                        prefixIcon: Padding(
                          padding: EdgeInsets.only(
                              left: screenWidth * 0.04,
                              right: screenWidth * 0.01),
                          child: Text(
                            'P',
                            style: GoogleFonts.poppins(
                              color: isDark ? Colors.white : Colors.black87,
                              fontSize: screenWidth * 0.04,
                            ),
                          ),
                        ),
                        prefixIconConstraints:
                            BoxConstraints(minWidth: 0, minHeight: 0),
                        filled: true,
                        fillColor: isDark ? Colors.grey[800] : Colors.grey[100],
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

                SizedBox(height: screenWidth * 0.06),

                // Save Button
                GestureDetector(
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  void loadData() {
    String currentMonth = getCurrentMonth();

    // Check if month has changed - reset luxury budget if it has
    if (savedMonth == "null") {
      saveMonthToday(currentMonth);
      // Store original luxury budget on first load if not already set
      double originalLuxury = box.get("OriginalLuxuryBudget", defaultValue: 0.0);
      if (originalLuxury == 0.0) {
        double currentLuxury = getLuxuryBudget();
        if (currentLuxury > 0) {
          // Set original to current (assuming it hasn't been spent yet on first load)
          box.put("OriginalLuxuryBudget", currentLuxury);
        }
      }
    } else if (savedMonth != "null" && savedMonth != currentMonth) {
      // Month has changed - reset luxury budget to original value
      double originalLuxuryBudget =
          box.get("OriginalLuxuryBudget", defaultValue: 0.0);
      if (originalLuxuryBudget > 0) {
        saveLuxuryBudget(originalLuxuryBudget);
      }
      saveMonthToday(currentMonth);
    }

    // Check if day has changed - reset daily expenses (but NOT luxury budget)
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
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
                            widget.selectedDate == null ||
                                    (widget.selectedDate!.year ==
                                            DateTime.now().year &&
                                        widget.selectedDate!.month ==
                                            DateTime.now().month &&
                                        widget.selectedDate!.day ==
                                            DateTime.now().day)
                                ? 'REMAINING FOR TODAY'
                                : 'REMAINING FOR SELECTED DAY',
                            style: TextStyle(
                              fontWeight: FontWeight.w300,
                              color: Colors.white,
                              fontSize: screenWidth * 0.035,
                            ),
                          ),
                          Text(
                            'P ${(calculateSuggestedDaily() - getTodayExpenses()).round().toString()}',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              fontSize: screenWidth * 0.11,
                            ),
                          ),
                          SizedBox(height: screenWidth * 0.005),
                          Row(
                            children: [
                              Text(
                                'Suggested Daily: ',
                                style: TextStyle(
                                  fontWeight: FontWeight.w300,
                                  color: Colors.white.withOpacity(0.8),
                                  fontSize: screenWidth * 0.035,
                                ),
                              ),
                              Text(
                                'P ${calculateSuggestedDaily().round().toString()}',
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
                        showEditBudgetModal(context);
                      },
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: screenWidth * 0.05),
            // Stats container
            Container(
              padding: EdgeInsets.all(screenWidth * 0.045),
              decoration: BoxDecoration(
                color: isDark ? Colors.grey[850] : Colors.white,
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
                          color: isDark ? Colors.grey[400] : Colors.grey[600],
                          fontSize: screenWidth * 0.035,
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            'P ${(getMonthBudget() - getTotalExpenses()).round().toString()}',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: (getMonthBudget() - getTotalExpenses()) < 0
                                  ? Colors.red[400]
                                  : (isDark ? Colors.white : Colors.black87),
                              fontSize: screenWidth * 0.035,
                            ),
                          ),
                          Text(
                            ' / ${getMonthBudget().round().toString()}',
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
                          color: isDark ? Colors.grey[400] : Colors.grey[600],
                          fontSize: screenWidth * 0.035,
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            'P ${getLuxuryBudget().round().toString()}',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: isDark ? Colors.white : Colors.black87,
                              fontSize: screenWidth * 0.035,
                            ),
                          ),
                          Text(
                            ' / ${getOriginalLuxuryBudget().round().toString()}',
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
                    color: isDark ? Colors.grey[700] : Colors.grey[300],
                  ),
                  SizedBox(height: screenWidth * 0.025),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total Expenses:',
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          color: isDark ? Colors.grey[400] : Colors.grey[600],
                          fontSize: screenWidth * 0.035,
                        ),
                      ),
                      Text(
                        'P ${getTotalExpenses().round().toString()}',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: isDark ? Colors.white : Colors.black87,
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
