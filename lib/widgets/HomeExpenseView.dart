import 'package:badyet/ExpenseItemClass.dart';
import 'package:badyet/ExpensesTodayBox.dart';
import 'package:badyet/ExpenseTodayHistoryBox.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ExpenseContainer extends StatefulWidget {
  final List<String> selectedAccountNames;
  final DateTime? selectedDate;

  const ExpenseContainer({super.key, this.selectedAccountNames = const [], this.selectedDate});

  @override
  State<ExpenseContainer> createState() => _ExpenseContainer();
}

class _ExpenseContainer extends State<ExpenseContainer> {
  bool _matchesDate(String itemDate, DateTime targetDate) {
    try {
      DateTime date;
      if (itemDate.contains('-')) {
        date = DateTime.parse(itemDate);
      } else if (itemDate.contains('/')) {
        List<String> parts = itemDate.split('/');
        if (parts.length == 3) {
          date = DateTime(int.parse(parts[2]), int.parse(parts[0]), int.parse(parts[1]));
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

  List<ExpenseItemClass> getFilteredItems() {
    DateTime targetDate = widget.selectedDate ?? DateTime.now();
    bool isToday = targetDate.year == DateTime.now().year && 
                   targetDate.month == DateTime.now().month && 
                   targetDate.day == DateTime.now().day;
    
    List<ExpenseItemClass> items;
    
    // If viewing today, use expenseTodayBox, otherwise filter from history
    if (widget.selectedDate == null || isToday) {
      items = expenseTodayBox.values.toList();
    } else {
      // Viewing past date - filter from history by date
      items = expenseTodayHistoryBox.values
          .where((item) => _matchesDate(item.date, targetDate))
          .toList();
    }

    // If no accounts selected or all accounts selected, show all
    if (widget.selectedAccountNames.isEmpty) {
      return items;
    }

    // Filter by selected accounts
    return items.where((item) {
      // Check if item's account matches selected accounts
      if (widget.selectedAccountNames.contains(item.account) || item.account.isEmpty) {
        return true;
      }
      
      // For transfers, also check if destination account matches
      if (item.category == 'Transfer' && item.type.contains('->')) {
        List<String> parts = item.type.split('->');
        if (parts.length == 2) {
          String toAccount = parts[1].trim();
          if (widget.selectedAccountNames.contains(toAccount)) {
            return true;
          }
        }
      }
      
      return false;
    }).toList();
  }

  double getCashflowToday() {
    double total = 0.0;
    bool allAccountsSelected = widget.selectedAccountNames.isEmpty;
    
    for (var object in getFilteredItems()) {
      double amount = double.tryParse(object.price) ?? 0.0;
      
      if (object.category == 'Income') {
        total += amount;
      } else if (object.category == 'Transfer') {
        // Transfers are neutral when all accounts selected, otherwise + or - based on account
        if (!allAccountsSelected && widget.selectedAccountNames.length == 1) {
          String selectedAccount = widget.selectedAccountNames.first;
          // Check if this account is the source (minus) or destination (plus)
          if (object.account == selectedAccount) {
            // This account is the source, so it's a minus
            total -= amount;
          } else if (object.type.contains('->')) {
            // Parse the "from -> to" format
            List<String> parts = object.type.split('->');
            if (parts.length == 2) {
              String toAccount = parts[1].trim();
              if (toAccount == selectedAccount) {
                // This account is the destination, so it's a plus
                total += amount;
              }
            }
          }
        }
        // If all accounts selected, transfers don't affect total (neutral)
      } else {
        total -= amount;
      }
    }
    return total;
  }

  Color getCategoryColor(String category) {
    switch (category) {
      case 'Food & Drinks':
        return Color(0xFFFF6B6B); // Red
      case 'Bills & Subscription':
        return Color(0xFF5E9FD9); // Blue
      case 'Vehicle':
        return Color(0xFF98D8C8); // Seafoam
      case 'Luxury - Shopping':
        return Color(0xFF9B59B6); // Purple
      case 'Luxury - Social':
        return Color(0xFFE91E63); // Pink
      case 'Income':
        return Color(0xFF228B22); // Green
      case 'Transfer':
        return Color(0xFF3477D8); // Blue (brand color)
      default:
        return Color(0xFFB0B0B0); // Gray (Others)
    }
  }

  IconData getCategoryIcon(String category) {
    switch (category) {
      case 'Food & Drinks':
        return Icons.restaurant_rounded;
      case 'Bills & Subscription':
        return Icons.receipt_long_rounded;
      case 'Vehicle':
        return Icons.local_gas_station_rounded;
      case 'Luxury - Shopping':
        return Icons.shopping_bag_rounded;
      case 'Luxury - Social':
        return Icons.celebration_rounded;
      case 'Income':
        return Icons.attach_money_rounded;
      case 'Transfer':
        return Icons.swap_horiz_rounded;
      default:
        return Icons.category_rounded; // Others
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    final isDark = Theme.of(context).brightness == Brightness.dark;
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
                  color: isDark ? Colors.white : Colors.grey[850],
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
                        color: isPositive ? (isDark ? Color(0xFF81C784) : Color.fromRGBO(34, 139, 34, 1)) : Colors.red[400],
                        fontSize: screenWidth * 0.04,
                        fontWeight: FontWeight.w600),
                  );
                })
          ],
        ),
        SizedBox(height: screenWidth * 0.03),
        Divider(
          height: 1,
          color: isDark ? Colors.grey[700] : Colors.grey[300],
        ),
        ValueListenableBuilder<Box<ExpenseItemClass>>(
          valueListenable: expenseTodayBox.listenable(),
          builder: (context, box, _) {
            List<ExpenseItemClass> filteredItems = getFilteredItems().reversed.toList();

            if (filteredItems.isEmpty) {
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
                        widget.selectedDate == null || 
                        (widget.selectedDate!.year == DateTime.now().year && 
                         widget.selectedDate!.month == DateTime.now().month && 
                         widget.selectedDate!.day == DateTime.now().day)
                            ? 'No transactions today'
                            : 'No transactions',
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
              itemCount: filteredItems.length,
              itemBuilder: (context, index) {
                ExpenseItemClass item = filteredItems[index];

                String category = item.category;
                String type = item.type;
                String price = item.price;
                bool isIncome = category == 'Income';
                bool isTransfer = category == 'Transfer';
                bool allAccountsSelected = widget.selectedAccountNames.isEmpty;
                
                // Determine transfer sign based on account selection
                String transferSign = '';
                Color transferColor = Color(0xFF3477D8);
                if (isTransfer) {
                  if (allAccountsSelected) {
                    transferSign = 'P $price'; // Neutral when all accounts selected
                    transferColor = Color(0xFF3477D8); // Blue
                  } else if (widget.selectedAccountNames.length == 1) {
                    String selectedAccount = widget.selectedAccountNames.first;
                    // Check if this account is the source (minus) or destination (plus)
                    if (item.account == selectedAccount) {
                      transferSign = "- P $price"; // Source account
                      transferColor = Colors.red[400]!;
                    } else if (type.contains('->')) {
                      List<String> parts = type.split('->');
                      if (parts.length == 2) {
                        String toAccount = parts[1].trim();
                        if (toAccount == selectedAccount) {
                          transferSign = "+ P $price"; // Destination account
                          transferColor = isDark ? Color(0xFF81C784) : Color.fromRGBO(34, 139, 34, 1);
                        } else {
                          transferSign = 'P $price'; // Not involved in this transfer
                          transferColor = Color(0xFF3477D8);
                        }
                      } else {
                        transferSign = 'P $price';
                        transferColor = Color(0xFF3477D8);
                      }
                    } else {
                      transferSign = 'P $price';
                      transferColor = Color(0xFF3477D8);
                    }
                  } else {
                    transferSign = 'P $price';
                    transferColor = Color(0xFF3477D8);
                  }
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
                              ? (isDark ? Color(0xFF81C784).withOpacity(0.15) : Color.fromRGBO(34, 139, 34, 0.1))
                              : isTransfer
                                  ? Color(0xFF3477D8).withOpacity(0.15)
                                  : getCategoryColor(category).withOpacity(0.15),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          isIncome ? Icons.trending_up_rounded : getCategoryIcon(category),
                          size: screenWidth * 0.06,
                          color: isIncome
                              ? (isDark ? Color(0xFF81C784) : Color.fromRGBO(34, 139, 34, 1))
                              : isTransfer
                                  ? Color(0xFF3477D8)
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
                                color: isDark ? Colors.white : Colors.black87,
                              ),
                            ),
                            Text(
                              type,
                              style: GoogleFonts.poppins(
                                fontSize: screenWidth * 0.03,
                                color: isDark ? Colors.grey[400] : Colors.grey[500],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        isTransfer ? transferSign : (isIncome ? "+ P $price" : "- P $price"),
                        style: GoogleFonts.poppins(
                          fontSize: screenWidth * 0.038,
                          fontWeight: FontWeight.w500,
                          color: isTransfer 
                              ? transferColor
                              : (isIncome 
                                  ? (isDark ? Color(0xFF81C784) : Color.fromRGBO(34, 139, 34, 1)) 
                                  : Colors.red[400]),
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
