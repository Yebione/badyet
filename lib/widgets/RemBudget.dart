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
    return Container(
        alignment: Alignment.topLeft, // Align to the top-left
        padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.06, vertical: screenWidth * 0.02),
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
        child: ValueListenableBuilder<Box>(
          valueListenable: Hive.box('Budget').listenable(),
          builder: (context, box, _) {
            return Row(
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
                      ),
                    ),
                    Text(
                      'PHP ${getRecBudgetToday().round().toString()}',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        fontSize: screenWidth * 0.09,
                      ),
                    ),
                    SizedBox(
                      height: screenWidth * 0.02,
                    ),
                  ],
                ),
                IconButton(
                  icon: Icon(Icons.edit_rounded,
                      color: Colors.white, size: screenWidth * 0.084),
                  onPressed: () {
                    addBudget(context);
                  },
                )
              ],
            );
          },
        ));
  }
}
