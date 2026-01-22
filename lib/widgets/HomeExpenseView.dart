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
  final box = Hive.box('Budget');

  List<String> get categories {
    List<dynamic> stored = box.get('categories', defaultValue: [
      'Income',
      'Food & Drinks',
      'Bills & Subscription',
      'Vehicle',
      'Luxury - Shopping',
      'Luxury - Social',
      'Others'
    ]);
    return stored.cast<String>();
  }

  List<String> get accounts {
    List<dynamic> stored = box.get('accounts', defaultValue: [
      {'name': 'Cash', 'accNo': '', 'balance': 0.0}
    ]);
    return stored.map((e) => (e as Map)['name'] as String).toList();
  }

  void _updateExpenseItem(ExpenseItemClass oldItem, ExpenseItemClass newItem) {
    DateTime targetDate = widget.selectedDate ?? DateTime.now();
    bool isToday = targetDate.year == DateTime.now().year && 
                   targetDate.month == DateTime.now().month && 
                   targetDate.day == DateTime.now().day;

    // Update in expenseTodayBox if it's today
    if (isToday) {
      for (var key in expenseTodayBox.keys) {
        ExpenseItemClass? item = expenseTodayBox.get(key);
        if (item != null &&
            item.date == oldItem.date &&
            item.category == oldItem.category &&
            item.type == oldItem.type &&
            item.price == oldItem.price &&
            item.account == oldItem.account) {
          expenseTodayBox.put(key, newItem);
          break;
        }
      }
    }

    // Always update in expenseTodayHistoryBox
    for (var key in expenseTodayHistoryBox.keys) {
      ExpenseItemClass? item = expenseTodayHistoryBox.get(key);
      if (item != null &&
          item.date == oldItem.date &&
          item.category == oldItem.category &&
          item.type == oldItem.type &&
          item.price == oldItem.price &&
          item.account == oldItem.account) {
        expenseTodayHistoryBox.put(key, newItem);
        break;
      }
    }

    // Budget will be recalculated automatically by RemBudget widget
    // when it detects changes in the expense boxes
  }

  void _showEditExpenseModal(BuildContext context, ExpenseItemClass item) {
    double screenWidth = MediaQuery.of(context).size.width;

    final descriptionController = TextEditingController(text: item.type);
    final priceController = TextEditingController(text: item.price);
    String selectedCategory = item.category;
    String selectedAccount = item.account;
    String selectedAccountTo = '';
    
    // For transfers, parse the "from -> to" format
    if (item.category == 'Transfer' && item.type.contains('->')) {
      List<String> parts = item.type.split('->');
      if (parts.length == 2) {
        selectedAccount = item.account; // Source account
        selectedAccountTo = parts[1].trim(); // Destination account
      }
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) {
          final modalIsDark = Theme.of(context).brightness == Brightness.dark;
          return Container(
            height: MediaQuery.of(context).size.height * 0.85,
            decoration: BoxDecoration(
              color: modalIsDark ? Color(0xFF1E1E1E) : Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
            ),
            child: Column(
              children: [
              SizedBox(height: screenWidth * 0.03),
              Container(
                width: screenWidth * 0.1,
                height: 4,
                decoration: BoxDecoration(
                  color: modalIsDark ? Colors.grey[700] : Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              SizedBox(height: screenWidth * 0.04),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Edit Transaction',
                      style: GoogleFonts.poppins(
                        fontSize: screenWidth * 0.045,
                        fontWeight: FontWeight.w600,
                        color: modalIsDark ? Colors.white : Colors.black87,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(
                        Icons.close_rounded,
                        color: modalIsDark ? Colors.white : Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(screenWidth * 0.06),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Description
                      Text(
                        'Description',
                        style: GoogleFonts.poppins(
                          fontSize: screenWidth * 0.038,
                          fontWeight: FontWeight.w500,
                          color: modalIsDark ? Colors.white : Colors.black87,
                        ),
                      ),
                      SizedBox(height: screenWidth * 0.02),
                      TextField(
                        controller: descriptionController,
                        style: GoogleFonts.poppins(
                          fontSize: screenWidth * 0.035,
                          color: modalIsDark ? Colors.white : Colors.black87,
                        ),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: modalIsDark ? Colors.grey[800] : Colors.grey[100],
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: modalIsDark ? Colors.grey[700]! : Colors.grey[300]!,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: Color.fromRGBO(52, 119, 216, 1),
                            ),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.04,
                            vertical: screenWidth * 0.035,
                          ),
                        ),
                      ),
                      SizedBox(height: screenWidth * 0.04),

                      // Price
                      Text(
                        'Amount',
                        style: GoogleFonts.poppins(
                          fontSize: screenWidth * 0.038,
                          fontWeight: FontWeight.w500,
                          color: modalIsDark ? Colors.white : Colors.black87,
                        ),
                      ),
                      SizedBox(height: screenWidth * 0.02),
                      TextField(
                        controller: priceController,
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                        style: GoogleFonts.poppins(
                          fontSize: screenWidth * 0.035,
                          color: modalIsDark ? Colors.white : Colors.black87,
                        ),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: modalIsDark ? Colors.grey[800] : Colors.grey[100],
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: modalIsDark ? Colors.grey[700]! : Colors.grey[300]!,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: Color.fromRGBO(52, 119, 216, 1),
                            ),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.04,
                            vertical: screenWidth * 0.035,
                          ),
                        ),
                      ),
                      SizedBox(height: screenWidth * 0.04),

                      // Category (only if not Transfer or Income)
                      if (item.category != 'Transfer' && item.category != 'Income') ...[
                        Text(
                          'Category',
                          style: GoogleFonts.poppins(
                            fontSize: screenWidth * 0.038,
                            fontWeight: FontWeight.w500,
                            color: modalIsDark ? Colors.white : Colors.black87,
                          ),
                        ),
                        SizedBox(height: screenWidth * 0.02),
                        Container(
                          decoration: BoxDecoration(
                            color: modalIsDark ? Colors.grey[800] : Colors.grey[100],
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: modalIsDark ? Colors.grey[700]! : Colors.grey[300]!,
                            ),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: selectedCategory,
                              isExpanded: true,
                              dropdownColor: modalIsDark ? Color(0xFF1E1E1E) : Colors.white,
                              style: GoogleFonts.poppins(
                                fontSize: screenWidth * 0.035,
                                color: modalIsDark ? Colors.white : Colors.black87,
                              ),
                              items: categories
                                  .where((cat) => cat != 'Income' && cat != 'Transfer')
                                  .map((category) => DropdownMenuItem(
                                        value: category,
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: screenWidth * 0.04,
                                          ),
                                          child: Text(category),
                                        ),
                                      ))
                                  .toList(),
                              onChanged: (value) {
                                if (value != null) {
                                  setModalState(() {
                                    selectedCategory = value;
                                  });
                                }
                              },
                            ),
                          ),
                        ),
                        SizedBox(height: screenWidth * 0.04),
                      ],

                      // Account (for expenses and income)
                      if (item.category != 'Transfer') ...[
                        Text(
                          'Account',
                          style: GoogleFonts.poppins(
                            fontSize: screenWidth * 0.038,
                            fontWeight: FontWeight.w500,
                            color: modalIsDark ? Colors.white : Colors.black87,
                          ),
                        ),
                        SizedBox(height: screenWidth * 0.02),
                        Container(
                          decoration: BoxDecoration(
                            color: modalIsDark ? Colors.grey[800] : Colors.grey[100],
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: modalIsDark ? Colors.grey[700]! : Colors.grey[300]!,
                            ),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: selectedAccount.isEmpty && accounts.isNotEmpty
                                  ? accounts.first
                                  : selectedAccount,
                              isExpanded: true,
                              dropdownColor: modalIsDark ? Color(0xFF1E1E1E) : Colors.white,
                              style: GoogleFonts.poppins(
                                fontSize: screenWidth * 0.035,
                                color: modalIsDark ? Colors.white : Colors.black87,
                              ),
                              items: accounts.map((account) => DropdownMenuItem(
                                    value: account,
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: screenWidth * 0.04,
                                      ),
                                      child: Text(account),
                                    ),
                                  )).toList(),
                              onChanged: (value) {
                                if (value != null) {
                                  setModalState(() {
                                    selectedAccount = value;
                                  });
                                }
                              },
                            ),
                          ),
                        ),
                        SizedBox(height: screenWidth * 0.04),
                      ],

                      // Transfer accounts (from -> to)
                      if (item.category == 'Transfer') ...[
                        Text(
                          'From Account',
                          style: GoogleFonts.poppins(
                            fontSize: screenWidth * 0.038,
                            fontWeight: FontWeight.w500,
                            color: modalIsDark ? Colors.white : Colors.black87,
                          ),
                        ),
                        SizedBox(height: screenWidth * 0.02),
                        Container(
                          decoration: BoxDecoration(
                            color: modalIsDark ? Colors.grey[800] : Colors.grey[100],
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: modalIsDark ? Colors.grey[700]! : Colors.grey[300]!,
                            ),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: selectedAccount.isEmpty && accounts.isNotEmpty
                                  ? accounts.first
                                  : selectedAccount,
                              isExpanded: true,
                              dropdownColor: modalIsDark ? Color(0xFF1E1E1E) : Colors.white,
                              style: GoogleFonts.poppins(
                                fontSize: screenWidth * 0.035,
                                color: modalIsDark ? Colors.white : Colors.black87,
                              ),
                              items: accounts.map((account) => DropdownMenuItem(
                                    value: account,
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: screenWidth * 0.04,
                                      ),
                                      child: Text(account),
                                    ),
                                  )).toList(),
                              onChanged: (value) {
                                if (value != null) {
                                  setModalState(() {
                                    selectedAccount = value;
                                  });
                                }
                              },
                            ),
                          ),
                        ),
                        SizedBox(height: screenWidth * 0.04),
                        Text(
                          'To Account',
                          style: GoogleFonts.poppins(
                            fontSize: screenWidth * 0.038,
                            fontWeight: FontWeight.w500,
                            color: modalIsDark ? Colors.white : Colors.black87,
                          ),
                        ),
                        SizedBox(height: screenWidth * 0.02),
                        Container(
                          decoration: BoxDecoration(
                            color: modalIsDark ? Colors.grey[800] : Colors.grey[100],
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: modalIsDark ? Colors.grey[700]! : Colors.grey[300]!,
                            ),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: selectedAccountTo.isEmpty && accounts.isNotEmpty
                                  ? accounts.first
                                  : selectedAccountTo,
                              isExpanded: true,
                              dropdownColor: modalIsDark ? Color(0xFF1E1E1E) : Colors.white,
                              style: GoogleFonts.poppins(
                                fontSize: screenWidth * 0.035,
                                color: modalIsDark ? Colors.white : Colors.black87,
                              ),
                              items: accounts.map((account) => DropdownMenuItem(
                                    value: account,
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: screenWidth * 0.04,
                                      ),
                                      child: Text(account),
                                    ),
                                  )).toList(),
                              onChanged: (value) {
                                if (value != null) {
                                  setModalState(() {
                                    selectedAccountTo = value;
                                  });
                                }
                              },
                            ),
                          ),
                        ),
                        SizedBox(height: screenWidth * 0.04),
                      ],
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(screenWidth * 0.06),
                child: Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => Navigator.pop(context),
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: screenWidth * 0.035),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(
                              color: modalIsDark ? Colors.grey[700]! : Colors.grey[300]!,
                            ),
                          ),
                        ),
                        child: Text(
                          'Cancel',
                          style: GoogleFonts.poppins(
                            color: modalIsDark ? Colors.grey[400] : Colors.grey[600],
                            fontWeight: FontWeight.w500,
                            fontSize: screenWidth * 0.035,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: screenWidth * 0.03),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [
                              Color.fromRGBO(52, 119, 216, 1),
                              Color.fromRGBO(81, 218, 96, 1),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: TextButton(
                          onPressed: () {
                            String description = descriptionController.text.trim();
                            String price = priceController.text.trim();
                            
                            if (description.isEmpty || price.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Please fill in all fields')),
                              );
                              return;
                            }

                            // Build the new item
                            String newType = description;
                            String newCategory = item.category;
                            String newAccount = selectedAccount;
                            
                            // For transfers, update the type to include "from -> to"
                            if (item.category == 'Transfer') {
                              newType = '$selectedAccount -> $selectedAccountTo';
                            } else if (item.category != 'Transfer' && item.category != 'Income') {
                              // Allow category change for expenses
                              newCategory = selectedCategory;
                            }

                            ExpenseItemClass updatedItem = ExpenseItemClass(
                              item.date,
                              newCategory,
                              newType,
                              price,
                              newAccount,
                            );

                            _updateExpenseItem(item, updatedItem);
                            Navigator.pop(context);
                            setState(() {}); // Refresh the UI
                          },
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: screenWidth * 0.035),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            'Save',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: screenWidth * 0.035,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
        },
      ),
    );
  }

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
                  child: GestureDetector(
                    onTap: () => _showEditExpenseModal(context, item),
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
