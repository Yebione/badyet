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

  // Mock data for display
  final List<Map<String, dynamic>> mockCashflow = [
    {'category': 'Food & Drinks', 'type': 'Lunch at Jollibee', 'price': '150.00', 'isIncome': false},
    {'category': 'Income', 'type': 'Salary', 'price': '15,000.00', 'isIncome': true},
    {'category': 'Transportation', 'type': 'Grab to work', 'price': '85.00', 'isIncome': false},
    {'category': 'Shopping', 'type': 'Groceries', 'price': '520.00', 'isIncome': false},
  ];

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: screenWidth * 0.05),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Today's Cashflow",
              style: GoogleFonts.poppins(
                  color: Colors.grey[850],
                  fontSize: screenWidth * 0.045,
                  fontWeight: FontWeight.w600),
            ),
            ValueListenableBuilder<Box>(
                valueListenable: Hive.box('Budget').listenable(),
                builder: (context, box, widget) {
                  return Text(
                    "P ${sum.round().toString()}",
                    textAlign: TextAlign.left,
                    style: GoogleFonts.poppins(
                        color: Colors.grey[600],
                        fontSize: screenWidth * 0.035),
                  );
                })
          ],
        ),
        SizedBox(height: screenWidth * 0.03),
        Divider(
          height: 1,
          color: Colors.grey[300],
        ),
        ValueListenableBuilder<Box>(
          valueListenable: expenseTodayBox.listenable(),
          builder: (context, box, _) {
            // Use mock data if no real data exists
            final bool useMock = expenseTodayBox.isEmpty;
            final int itemCount = useMock ? mockCashflow.length : expenseTodayBox.length;

            return ListView.builder(
              key: UniqueKey(),
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: itemCount,
              itemBuilder: (context, index) {
                String category;
                String type;
                String price;
                bool isIncome;

                if (useMock) {
                  category = mockCashflow[index]['category']!;
                  type = mockCashflow[index]['type']!;
                  price = mockCashflow[index]['price']!;
                  isIncome = mockCashflow[index]['isIncome'] ?? false;
                } else {
                  ExpenseItemClass? item = expenseTodayBox.getAt(index);
                  category = item!.category;
                  type = item.type;
                  price = item.price;
                  isIncome = false; // Real data defaults to expense
                }

                return Padding(
                  padding: EdgeInsets.only(
                    top: index == 0 ? 0 : screenWidth * 0.035,
                    bottom: screenWidth * 0.035,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.all(screenWidth * 0.025),
                        decoration: BoxDecoration(
                          color: isIncome
                              ? Color.fromRGBO(34, 139, 34, 0.1)
                              : Colors.red.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          isIncome ? Icons.trending_up_rounded : Icons.trending_down_rounded,
                          size: screenWidth * 0.06,
                          color: isIncome
                              ? Color.fromRGBO(34, 139, 34, 1)
                              : Colors.red[400],
                        ),
                      ),
                      SizedBox(width: screenWidth * 0.04),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              category,
                              style: GoogleFonts.poppins(
                                fontSize: screenWidth * 0.038,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              type,
                              style: GoogleFonts.poppins(
                                fontSize: screenWidth * 0.03,
                                color: Colors.grey[500],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        isIncome ? "+ P $price" : "- P $price",
                        style: GoogleFonts.poppins(
                          fontSize: screenWidth * 0.038,
                          fontWeight: FontWeight.w500,
                          color: isIncome ? Color.fromRGBO(34, 139, 34, 1) : Colors.red[400],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
        SizedBox(height: screenWidth * 0.05),
      ],
    );
  }
}
