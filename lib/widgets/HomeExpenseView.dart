import 'package:badyet/ExpenseItemClass.dart';
import 'package:badyet/ExpenseTodayHistoryBox.dart';
import 'package:badyet/ExpensesTodayBox.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ExpenseContainer extends StatefulWidget {
  final List<String> selectedAccountNames;

  const ExpenseContainer({super.key, this.selectedAccountNames = const []});

  @override
  State<ExpenseContainer> createState() => _ExpenseContainer();
}

class _ExpenseContainer extends State<ExpenseContainer> {
  double getCashflowToday() {
    double total = 0.0;
    for (var object in expenseTodayBox.values) {
      double amount = double.tryParse(object.price) ?? 0.0;
      if (object.category == 'Income') {
        total += amount;
      } else {
        total -= amount;
      }
    }
    return total;
  }

  Color getCategoryColor(String category) {
    switch (category) {
      case 'Food & Drinks':
        return Color(0xFFFF6B6B);
      case 'Shopping':
        return Color(0xFF4ECDC4);
      case 'Transportation':
        return Color(0xFFFFE66D);
      case 'Housing':
        return Color(0xFF95E1D3);
      case 'Life & Entertainment':
        return Color(0xFFDDA0DD);
      case 'Communication, PC':
        return Color(0xFF87CEEB);
      case 'Financial Expenses':
        return Color(0xFFFFB347);
      case 'Vehicle':
        return Color(0xFF98D8C8);
      case 'Investments':
        return Color(0xFF7B68EE);
      case 'Income':
        return Color(0xFF228B22);
      default:
        return Color(0xFFB0B0B0);
    }
  }

  IconData getCategoryIcon(String category) {
    switch (category) {
      case 'Food & Drinks':
        return Icons.restaurant_rounded;
      case 'Shopping':
        return Icons.shopping_bag_rounded;
      case 'Transportation':
        return Icons.directions_car_rounded;
      case 'Housing':
        return Icons.home_rounded;
      case 'Life & Entertainment':
        return Icons.movie_rounded;
      case 'Communication, PC':
        return Icons.phone_android_rounded;
      case 'Financial Expenses':
        return Icons.account_balance_rounded;
      case 'Vehicle':
        return Icons.local_gas_station_rounded;
      case 'Investments':
        return Icons.trending_up_rounded;
      case 'Income':
        return Icons.attach_money_rounded;
      default:
        return Icons.category_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: screenWidth * 0.05),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Today's Cashflow",
              style: GoogleFonts.poppins(
                  color: Colors.grey[850],
                  fontSize: screenWidth * 0.045,
                  fontWeight: FontWeight.w600),
            ),
            ValueListenableBuilder<Box<ExpenseItemClass>>(
                valueListenable: expenseTodayBox.listenable(),
                builder: (context, box, widget) {
                  double total = getCashflowToday();
                  bool isPositive = total >= 0;
                  return Text(
                    "${isPositive ? '+' : '-'} P ${total.abs().toStringAsFixed(0)}",
                    style: GoogleFonts.poppins(
                        color: isPositive ? Color.fromRGBO(34, 139, 34, 1) : Colors.red[400],
                        fontSize: screenWidth * 0.04,
                        fontWeight: FontWeight.w600),
                  );
                })
          ],
        ),
        SizedBox(height: screenWidth * 0.03),
        Divider(
          height: 1,
          color: Colors.grey[300],
        ),
        ValueListenableBuilder<Box<ExpenseItemClass>>(
          valueListenable: expenseTodayBox.listenable(),
          builder: (context, box, _) {
            if (expenseTodayBox.isEmpty) {
              return Padding(
                padding: EdgeInsets.symmetric(vertical: screenWidth * 0.1),
                child: Center(
                  child: Column(
                    children: [
                      Icon(
                        Icons.receipt_long_rounded,
                        size: screenWidth * 0.15,
                        color: Colors.grey[300],
                      ),
                      SizedBox(height: screenWidth * 0.03),
                      Text(
                        'No transactions today',
                        style: GoogleFonts.poppins(
                          color: Colors.grey[400],
                          fontSize: screenWidth * 0.035,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            return ListView.builder(
              key: UniqueKey(),
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: expenseTodayBox.length,
              itemBuilder: (context, index) {
                ExpenseItemClass? item = expenseTodayBox.getAt(expenseTodayBox.length - 1 - index);
                if (item == null) return SizedBox();

                String category = item.category;
                String type = item.type;
                String price = item.price;
                bool isIncome = category == 'Income';

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
                              : getCategoryColor(category).withOpacity(0.15),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          isIncome ? Icons.trending_up_rounded : getCategoryIcon(category),
                          size: screenWidth * 0.06,
                          color: isIncome
                              ? Color.fromRGBO(34, 139, 34, 1)
                              : getCategoryColor(category),
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
