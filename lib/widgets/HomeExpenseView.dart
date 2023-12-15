import 'package:badyet/ExpenseItemClass.dart';
import 'package:badyet/ExpenseTodayHistoryBox.dart';
import 'package:badyet/ExpensesTodayBox.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'dart:math';

class ExpenseContainer extends StatefulWidget {
  const ExpenseContainer({super.key});

  @override
  State<ExpenseContainer> createState() => _ExpenseContainer();
}

DateTime today = DateTime.now();
String dateStr = "${today.month}-${today.day}-${today.year}";
String selectedCategory = 'Food & Drinks';
List<String> categories = [
  'Food & Drinks',
  'Shopping',
  'Housing',
  'Transportation',
  'Vehicle',
  'Life & Entertainment',
  'Communication, PC',
  'Financial Expenses',
  'Investments',
  'Others'
];
void toast(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(text),
  ));
}

final box = Hive.box('Budget');
double recBudgetToday =
    Hive.box('Budget').get("RecBudgetToday", defaultValue: 0.0);
double totalBudget = Hive.box('Budget').get("TotalBudget", defaultValue: 0.0);
double totalExpensesWeek =
    Hive.box('Budget').get("TotalExpensesWeek", defaultValue: 0.0);
double sumExpensesToday =
    Hive.box('Budget').get("SumExpensesToday", defaultValue: 0.0);
double sum = 0.0;
void saveTotalBudget(double value) {
  box.put("TotalBudget", value);
}

void saveRecBudget(double value) {
  box.put("RecBudgetToday", value);
}

void saveTotalExpensesWeek(double value) {
  box.put("TotalExpensesWeek", value);
}

void getSumExpensesToday() {
  sum = 0.0;
  for (var object in expenseTodayBox.values) {
    sum += double.parse(object.price);
  }
}

double getRecBudgetToday() {
  return box.get("RecBudgetToday", defaultValue: 0.0);
}

double getTotalBudget() {
  return box.get("TotalBudget");
}

double getTotalExpensesWeek() {
  return box.get("TotalExpensesWeek", defaultValue: 0.0);
}

String generateKey(int len) {
  var r = Random();
  const chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  return List.generate(len, (index) => chars[r.nextInt(chars.length)]).join();
}

void showDialogExpense(BuildContext context, TextEditingController type,
    TextEditingController amount) {
  showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text("Add Expense"),
            content: Column(
              children: [
                const Text('Please Select a Category:'),
                DropdownButton<String>(
                  value: selectedCategory,
                  items: categories.map((String item) {
                    return DropdownMenuItem<String>(
                      value: item,
                      child: Text(item),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedCategory = newValue!;
                    });
                  },
                ),
                TextField(
                  controller: type,
                  autofocus: true,
                  decoration: const InputDecoration(hintText: 'Type'),
                ),
                TextField(
                  controller: amount,
                  autofocus: true,
                  decoration: const InputDecoration(hintText: 'Amount'),
                ),
              ],
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel')),
              TextButton(
                  onPressed: () {
                    setState(() {
                      expenseTodayBox.put(
                          "key_${generateKey(15)}",
                          ExpenseItemClass(dateStr, selectedCategory, type.text,
                              amount.text));
                      expenseTodayHistoryBox.put(
                          "key_${generateKey(15)}",
                          ExpenseItemClass(dateStr, selectedCategory, type.text,
                              amount.text));
                      saveRecBudget(
                          getRecBudgetToday() - double.parse(amount.text));
                      saveTotalBudget(
                          getTotalBudget() - double.parse(amount.text));
                      saveTotalExpensesWeek(
                          getTotalExpensesWeek() + double.parse(amount.text));
                      getSumExpensesToday();
                    });
                    Navigator.of(context).pop();
                  },
                  child: const Text('Add')),
            ],
          );
        },
      );
    },
  );
}

class _ExpenseContainer extends State<ExpenseContainer> {
  final TextEditingController addTypeController = TextEditingController();
  final TextEditingController addPriceController = TextEditingController();

  @override
  dispose() {
    addTypeController.dispose();
    addPriceController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    getSumExpensesToday();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Container(
      margin: const EdgeInsets.only(top: 35),
      padding: const EdgeInsets.only(top: 30, left: 30, right: 35),
      width: screenWidth,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: const Color.fromARGB(71, 192, 192, 192),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Expenses Today",
                    style: GoogleFonts.poppins(
                        color: Colors.grey[850],
                        fontSize: screenWidth / 22,
                        fontWeight: FontWeight.bold),
                  ),
                  ValueListenableBuilder<Box>(
                      valueListenable: Hive.box('Budget').listenable(),
                      builder: (context, box, widget) {
                        return Text(
                          "PHP ${sum.round().toString()}",
                          textAlign: TextAlign.left,
                          style: GoogleFonts.poppins(
                              color: Colors.grey[850],
                              fontSize: screenWidth / 24),
                        );
                      })
                ],
              ),
              IconButton(
                  icon: Icon(
                    Icons.add_circle_rounded,
                    size: screenWidth * 0.07,
                  ),
                  onPressed: () {
                    showDialogExpense(
                        context, addTypeController, addPriceController);
                  }),
            ],
          ),
          const SizedBox(height: 16), // Adjust the height as needed
          const Divider(
            height: 2, // You can adjust the height of the divider
            color: Color.fromARGB(201, 48, 48, 48),
          ),
          ValueListenableBuilder<Box>(
            valueListenable: expenseTodayBox.listenable(),
            builder: (context, box, _) {
              return ListView.builder(
                key: UniqueKey(),
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: expenseTodayBox.length,
                itemBuilder: (context, index) {
                  ExpenseItemClass? item = expenseTodayBox.getAt(index);
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.monetization_on_rounded,
                          size: screenWidth / 12),
                      SizedBox(width: screenWidth / 22),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item!.category,
                            style: TextStyle(
                              fontSize: screenWidth * 0.042,
                              fontWeight: FontWeight.w900,
                            ),
                            textAlign: TextAlign.left,
                          ),
                          Text(
                            item.type,
                            style: TextStyle(
                              fontSize: screenWidth * 0.03,
                            ),
                          ),
                        ],
                      ),
                      Expanded(
                        child: Text(
                          "- PHP ${item.price}",
                          textAlign: TextAlign.right,
                          style: GoogleFonts.poppins(
                            fontSize: screenWidth * 0.037,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          ),
          const SizedBox(
            height: 25,
          )
        ],
      ),
    );
  }
}
