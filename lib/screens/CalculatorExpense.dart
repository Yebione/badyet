import 'package:badyet/ExpenseItemClass.dart';
import 'package:badyet/ExpenseTodayHistoryBox.dart';
import 'package:badyet/ExpensesTodayBox.dart';
import 'package:badyet/screens/Settings.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'dart:math';

class CalculatorExpensePage extends StatefulWidget {
  final String? initialAccount;
  final DateTime? selectedDate;

  const CalculatorExpensePage(
      {super.key, this.initialAccount, this.selectedDate});

  @override
  State<CalculatorExpensePage> createState() => _CalculatorExpensePageState();
}

class _CalculatorExpensePageState extends State<CalculatorExpensePage> {
  String _display = '0';
  String _currentOperation = '';
  double _firstOperand = 0;
  bool _shouldResetDisplay = false;
  String _transactionType = 'expense'; // 'expense', 'income', 'transfer'

  String selectedCategory = 'Food & Drinks';
  late String selectedAccount;
  String selectedAccountTo = 'GCash';
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    List<String> accountNames = _getAccountNames();
    selectedAccount = widget.initialAccount ??
        (accountNames.isNotEmpty ? accountNames.first : 'Cash');
    selectedAccountTo = accountNames.length > 1
        ? accountNames[1]
        : (accountNames.isNotEmpty ? accountNames.first : 'Cash');
  }

  List<String> _getAccountNames() {
    List<dynamic> stored = Hive.box('Budget').get('accounts', defaultValue: [
      {'name': 'Cash', 'accNo': '', 'balance': 0.0}
    ]);
    return stored.map((e) => (e as Map)['name'] as String).toList();
  }

  List<String> get accounts => _getAccountNames();

  final box = Hive.box('Budget');

  static const List<String> defaultCategories = [
    'Food & Drinks',
    'Bills & Subscription',
    'Vehicle',
    'Luxury - Shopping',
    'Luxury - Social',
    'Others'
  ];

  List<String> get categories {
    List<dynamic> stored =
        box.get('categories', defaultValue: defaultCategories);
    return stored.cast<String>();
  }

  String generateKey(int len) {
    var r = Random();
    const chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    return List.generate(len, (index) => chars[r.nextInt(chars.length)]).join();
  }

  void _onNumberPress(String number) {
    setState(() {
      if (_shouldResetDisplay) {
        _display = number;
        _shouldResetDisplay = false;
      } else if (_display == '0' && number != '.') {
        _display = number;
      } else if (number == '.' && _display.contains('.')) {
        // Don't add another decimal
        return;
      } else {
        _display += number;
      }
    });
  }

  void _onOperationPress(String op) {
    setState(() {
      _firstOperand = double.tryParse(_display) ?? 0;
      _currentOperation = op;
      _shouldResetDisplay = true;
    });
  }

  void _onEquals() {
    if (_currentOperation.isEmpty) return;

    double secondOperand = double.tryParse(_display) ?? 0;
    double result = 0;

    setState(() {
      switch (_currentOperation) {
        case '+':
          result = _firstOperand + secondOperand;
          break;
        case '-':
          result = _firstOperand - secondOperand;
          break;
        case '×':
          result = _firstOperand * secondOperand;
          break;
        case '÷':
          if (secondOperand != 0) {
            result = _firstOperand / secondOperand;
          }
          break;
      }

      // Format result to remove unnecessary decimals
      if (result == result.roundToDouble()) {
        _display = result.round().toString();
      } else {
        _display = result.toStringAsFixed(2);
      }
      _currentOperation = '';
      _shouldResetDisplay = true;
    });
  }

  void _onBackspace() {
    setState(() {
      if (_display.length > 1) {
        _display = _display.substring(0, _display.length - 1);
      } else {
        _display = '0';
      }
    });
  }

  void _showAccountModal(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: isDark ? Color(0xFF1E1E1E) : Colors.white,
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
                color: isDark ? Colors.grey[700] : Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: screenWidth * 0.04),
            Text(
              'Select Account',
              style: GoogleFonts.poppins(
                fontSize: screenWidth * 0.045,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
            SizedBox(height: screenWidth * 0.02),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: accounts.length,
                itemBuilder: (context, index) {
                  final account = accounts[index];
                  final isSelected = account == selectedAccount;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedAccount = account;
                      });
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.06,
                        vertical: screenWidth * 0.04,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? (isDark ? Colors.grey[800] : Colors.grey[100])
                            : Colors.transparent,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            account,
                            style: GoogleFonts.poppins(
                              fontSize: screenWidth * 0.04,
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                              color: isSelected
                                  ? Color.fromRGBO(52, 119, 216, 1)
                                  : (isDark ? Colors.white : Colors.black87),
                            ),
                          ),
                          if (isSelected)
                            Icon(
                              Icons.check_rounded,
                              color: Color.fromRGBO(52, 119, 216, 1),
                              size: screenWidth * 0.05,
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: screenWidth * 0.04),
          ],
        ),
      ),
    );
  }

  void _showAccountToModal(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: isDark ? Color(0xFF1E1E1E) : Colors.white,
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
                color: isDark ? Colors.grey[700] : Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: screenWidth * 0.04),
            Text(
              'Transfer To',
              style: GoogleFonts.poppins(
                fontSize: screenWidth * 0.045,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
            SizedBox(height: screenWidth * 0.02),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: accounts.length,
                itemBuilder: (context, index) {
                  final account = accounts[index];
                  final isSelected = account == selectedAccountTo;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedAccountTo = account;
                      });
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.06,
                        vertical: screenWidth * 0.04,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? (isDark ? Colors.grey[800] : Colors.grey[100])
                            : Colors.transparent,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            account,
                            style: GoogleFonts.poppins(
                              fontSize: screenWidth * 0.04,
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                              color: isSelected
                                  ? Color.fromRGBO(52, 119, 216, 1)
                                  : (isDark ? Colors.white : Colors.black87),
                            ),
                          ),
                          if (isSelected)
                            Icon(
                              Icons.check_rounded,
                              color: Color.fromRGBO(52, 119, 216, 1),
                              size: screenWidth * 0.05,
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: screenWidth * 0.04),
          ],
        ),
      ),
    );
  }

  void _showCategoryModal(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: isDark ? Color(0xFF1E1E1E) : Colors.white,
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
                color: isDark ? Colors.grey[700] : Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: screenWidth * 0.04),
            Text(
              'Select Category',
              style: GoogleFonts.poppins(
                fontSize: screenWidth * 0.045,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
            SizedBox(height: screenWidth * 0.02),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index];
                  final isSelected = category == selectedCategory;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedCategory = category;
                      });
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.06,
                        vertical: screenWidth * 0.04,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? (isDark ? Colors.grey[800] : Colors.grey[100])
                            : Colors.transparent,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            category,
                            style: GoogleFonts.poppins(
                              fontSize: screenWidth * 0.04,
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                              color: isSelected
                                  ? Color.fromRGBO(52, 119, 216, 1)
                                  : (isDark ? Colors.white : Colors.black87),
                            ),
                          ),
                          if (isSelected)
                            Icon(
                              Icons.check_rounded,
                              color: Color.fromRGBO(52, 119, 216, 1),
                              size: screenWidth * 0.05,
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: screenWidth * 0.04),
          ],
        ),
      ),
    );
  }

  double _getAccountBalance(String accountName) {
    List<dynamic> stored = box.get('accounts', defaultValue: [
      {'name': 'Cash', 'accNo': '', 'balance': 0.0}
    ]);
    for (var account in stored) {
      if ((account as Map)['name'] == accountName) {
        return (account['balance'] as num).toDouble();
      }
    }
    return 0.0;
  }

  void _updateAccountBalance(String accountName, double amount, bool isAdd) {
    List<dynamic> stored = box.get('accounts', defaultValue: [
      {'name': 'Cash', 'accNo': '', 'balance': 0.0}
    ]);
    List<Map<String, dynamic>> accounts =
        stored.map((e) => Map<String, dynamic>.from(e)).toList();

    for (int i = 0; i < accounts.length; i++) {
      if (accounts[i]['name'] == accountName) {
        double currentBalance = (accounts[i]['balance'] as num).toDouble();
        accounts[i]['balance'] =
            isAdd ? currentBalance + amount : currentBalance - amount;
        break;
      }
    }

    box.put('accounts', accounts);
  }

  void _saveExpense() {
    double amount = double.tryParse(_display) ?? 0;
    if (amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a valid amount')),
      );
      return;
    }

    // Validate sufficient balance for expense or transfer
    if (_transactionType == 'expense' || _transactionType == 'transfer') {
      double currentBalance = _getAccountBalance(selectedAccount);
      if (amount > currentBalance) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Insufficient balance in $selectedAccount')),
        );
        return;
      }
    }

    // For transfer, validate source and destination are different
    if (_transactionType == 'transfer' &&
        selectedAccount == selectedAccountTo) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Source and destination accounts must be different')),
      );
      return;
    }

    DateTime targetDate = widget.selectedDate ?? DateTime.now();
    String dateStr =
        "${targetDate.year}-${targetDate.month.toString().padLeft(2, '0')}-${targetDate.day.toString().padLeft(2, '0')}";
    bool isToday = targetDate.year == DateTime.now().year &&
        targetDate.month == DateTime.now().month &&
        targetDate.day == DateTime.now().day;
    String description = _descriptionController.text.isEmpty
        ? selectedCategory
        : _descriptionController.text;

    // Save to Hive boxes
    if (_transactionType == 'transfer') {
      // Save transfer to both today's cashflow (if today) and history
      String transferDescription = _descriptionController.text.isEmpty
          ? '$selectedAccount -> $selectedAccountTo'
          : _descriptionController.text;

      // Only save to expenseTodayBox if it's today
      if (isToday) {
        expenseTodayBox.put(
          "key_${generateKey(15)}",
          ExpenseItemClass(dateStr, 'Transfer', transferDescription, _display,
              selectedAccount),
        );
      }
      expenseTodayHistoryBox.put(
        "key_${generateKey(15)}",
        ExpenseItemClass(dateStr, 'Transfer', transferDescription, _display,
            selectedAccount),
      );
    } else {
      String category =
          _transactionType == 'income' ? 'Income' : selectedCategory;

      // Only save to expenseTodayBox if it's today
      if (isToday) {
        expenseTodayBox.put(
          "key_${generateKey(15)}",
          ExpenseItemClass(
              dateStr, category, description, _display, selectedAccount),
        );
      }
      expenseTodayHistoryBox.put(
        "key_${generateKey(15)}",
        ExpenseItemClass(
            dateStr, category, description, _display, selectedAccount),
      );
    }

    // Update budget
    DateTime now = DateTime.now();
    bool isCurrentMonth =
        targetDate.year == now.year && targetDate.month == now.month;

    double currentBudget = box.get("RecBudgetToday", defaultValue: 0.0);
    double luxuryBudget = box.get("LuxuryBudget", defaultValue: 0.0);
    double totalExpensesWeek = box.get("TotalExpensesWeek", defaultValue: 0.0);

    bool isLuxury = SettingsPage.isLuxuryCategory(selectedCategory);

    if (_transactionType == 'income') {
      // Add to account balance
      _updateAccountBalance(selectedAccount, amount, true);
      // Only update today's budget if entry is for today
      if (isToday) {
        box.put("RecBudgetToday", currentBudget + amount);
      }
    } else if (_transactionType == 'expense') {
      // Subtract from account balance
      _updateAccountBalance(selectedAccount, amount, false);

      // Deduct from luxury budget if luxury category, otherwise from regular budget
      if (isLuxury) {
        // Luxury budget only deducts if in current month (luxury budget is monthly)
        if (isCurrentMonth) {
          box.put("LuxuryBudget", luxuryBudget - amount);
        }
      } else {
        // Regular budget: only update today's budget if entry is for today
        if (isToday) {
          box.put("RecBudgetToday", currentBudget - amount);
          box.put("TotalExpensesWeek", totalExpensesWeek + amount);
        } else if (isCurrentMonth) {
          // Past entry in current month - recalculate today's recommended budget
          // This will be handled by RemBudget's calculateRecommended when it detects month expenses changed
          // We just need to trigger a recalculation by updating TotalExpensesWeek
          box.put("TotalExpensesWeek", totalExpensesWeek + amount);
        }
      }
    } else if (_transactionType == 'transfer') {
      // Subtract from source, add to destination
      _updateAccountBalance(selectedAccount, amount, false);
      _updateAccountBalance(selectedAccountTo, amount, true);
    }

    // If adding past entry in current month, recalculate today's recommended budget
    if (!isToday &&
        isCurrentMonth &&
        _transactionType == 'expense' &&
        !isLuxury) {
      // Trigger recalculation by calling RemBudget's calculateRecommended
      // We'll do this by reading the month budget and expenses, then recalculating
      double monthBudget = box.get("MonthBudget", defaultValue: 0.0);
      double monthExpenses = 0;
      final currentMonth = DateTime.now();

      // Calculate month expenses from history
      for (var item in expenseTodayHistoryBox.values) {
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
              date = DateTime(int.parse(parts[2]), int.parse(parts[0]),
                  int.parse(parts[1]));
            } else {
              continue;
            }
          } else {
            continue;
          }

          if (date.year == currentMonth.year &&
              date.month == currentMonth.month) {
            monthExpenses += double.tryParse(item.price) ?? 0;
          }
        } catch (e) {
          continue;
        }
      }

      // Recalculate recommended daily budget
      int remainingDays =
          DateTime(currentMonth.year, currentMonth.month + 1, 0).day -
              currentMonth.day +
              1;
      if (remainingDays > 0) {
        double remainingBudget = monthBudget - monthExpenses;
        double recommendedDaily = remainingBudget / remainingDays;
        if (recommendedDaily > 0) {
          box.put("RecBudgetToday", recommendedDaily);
        }
      }
    }

    Navigator.pop(context);
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  Widget _buildFlexButton(String text,
      {Color? color,
      Color? textColor,
      VoidCallback? onPressed,
      bool isGradient = false}) {
    double screenWidth = MediaQuery.of(context).size.width;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    bool isOperator = ['+', '-', '×', '÷'].contains(text);

    return Expanded(
      child: Padding(
        padding: EdgeInsets.all(screenWidth * 0.01),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onPressed,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              decoration: BoxDecoration(
                color: isGradient
                    ? null
                    : (color ??
                        (isOperator
                            ? (isDark ? Colors.grey[700] : Colors.grey[300])
                            : (isDark ? Colors.grey[800] : Colors.grey[100]))),
                gradient: isGradient
                    ? LinearGradient(
                        colors: [
                          Color.fromRGBO(52, 119, 216, 1),
                          Color.fromRGBO(81, 218, 96, 1),
                        ],
                      )
                    : null,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  text,
                  style: GoogleFonts.poppins(
                    fontSize: screenWidth * 0.055,
                    fontWeight: FontWeight.w500,
                    color: isGradient
                        ? Colors.white
                        : (textColor ??
                            (isOperator
                                ? (isDark ? Colors.grey[300] : Colors.grey[700])
                                : (isDark ? Colors.white : Colors.black87))),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? Color(0xFF121212) : Colors.white,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar with X and Check
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.04,
                vertical: screenWidth * 0.02,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(
                      Icons.close_rounded,
                      size: screenWidth * 0.08,
                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                    ),
                  ),
                  Text(
                    _transactionType == 'expense'
                        ? 'Add Expense'
                        : (_transactionType == 'income'
                            ? 'Add Income'
                            : 'Transfer'),
                    style: GoogleFonts.poppins(
                      fontSize: screenWidth * 0.045,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                  IconButton(
                    onPressed: _saveExpense,
                    icon: Icon(
                      Icons.check_rounded,
                      size: screenWidth * 0.08,
                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),

            // Expense/Income/Transfer Toggle
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
              child: Container(
                padding: EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: isDark ? Colors.grey[800] : Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () =>
                            setState(() => _transactionType = 'expense'),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: screenWidth * 0.025),
                          decoration: BoxDecoration(
                            color: _transactionType == 'expense'
                                ? (isDark ? Colors.grey[700] : Colors.white)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: _transactionType == 'expense'
                                ? [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.05),
                                      blurRadius: 4,
                                    ),
                                  ]
                                : null,
                          ),
                          child: Center(
                            child: Text(
                              'Expense',
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w500,
                                color: _transactionType == 'expense'
                                    ? Colors.red[400]
                                    : (isDark
                                        ? Colors.grey[400]
                                        : Colors.grey[600]),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () =>
                            setState(() => _transactionType = 'income'),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: screenWidth * 0.025),
                          decoration: BoxDecoration(
                            color: _transactionType == 'income'
                                ? (isDark ? Colors.grey[700] : Colors.white)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: _transactionType == 'income'
                                ? [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.05),
                                      blurRadius: 4,
                                    ),
                                  ]
                                : null,
                          ),
                          child: Center(
                            child: Text(
                              'Income',
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w500,
                                color: _transactionType == 'income'
                                    ? (isDark
                                        ? Color(0xFF81C784)
                                        : Color.fromRGBO(34, 139, 34, 1))
                                    : (isDark
                                        ? Colors.grey[400]
                                        : Colors.grey[600]),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () =>
                            setState(() => _transactionType = 'transfer'),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: screenWidth * 0.025),
                          decoration: BoxDecoration(
                            color: _transactionType == 'transfer'
                                ? (isDark ? Colors.grey[700] : Colors.white)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: _transactionType == 'transfer'
                                ? [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.05),
                                      blurRadius: 4,
                                    ),
                                  ]
                                : null,
                          ),
                          child: Center(
                            child: Text(
                              'Transfer',
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w500,
                                color: _transactionType == 'transfer'
                                    ? Color.fromRGBO(52, 119, 216, 1)
                                    : (isDark
                                        ? Colors.grey[400]
                                        : Colors.grey[600]),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: screenWidth * 0.02),

            // Amount Display
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(2.5), // Border thickness
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomLeft,
                    end: Alignment.topRight,
                    colors: [
                      Color.fromRGBO(52, 119, 216, 1),
                      Color.fromRGBO(81, 218, 96, 1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    vertical: screenWidth * 0.04,
                    horizontal: screenWidth * 0.04,
                  ),
                  decoration: BoxDecoration(
                    color: isDark ? Color(0xFF1E1E1E) : Colors.white,
                    borderRadius: BorderRadius.circular(17.5),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        _currentOperation.isNotEmpty
                            ? '${_firstOperand.toStringAsFixed(_firstOperand == _firstOperand.roundToDouble() ? 0 : 2)} $_currentOperation'
                            : '',
                        style: GoogleFonts.poppins(
                          fontSize: screenWidth * 0.04,
                          color: Colors.grey[400],
                        ),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            _transactionType == 'expense'
                                ? '-'
                                : (_transactionType == 'income' ? '+' : '>'),
                            style: GoogleFonts.poppins(
                              fontSize: screenWidth * 0.08,
                              fontWeight: FontWeight.w300,
                              color: _transactionType == 'expense'
                                  ? Colors.red[400]
                                  : (_transactionType == 'income'
                                      ? (isDark
                                          ? Color(0xFF81C784)
                                          : Color.fromRGBO(34, 139, 34, 1))
                                      : Color.fromRGBO(52, 119, 216, 1)),
                            ),
                          ),
                          Spacer(),
                          Text(
                            _display,
                            style: GoogleFonts.poppins(
                              fontSize: screenWidth * 0.1,
                              fontWeight: FontWeight.w700,
                              color: isDark ? Colors.white : Color(0xFF2F2F2F),
                            ),
                          ),
                          SizedBox(width: screenWidth * 0.02),
                          Text(
                            'PHP',
                            style: GoogleFonts.poppins(
                              fontSize: screenWidth * 0.05,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            SizedBox(height: screenWidth * 0.02),

            // Account & Category Selectors (or Account From/To for Transfer)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
              child: Row(
                children: [
                  // Account Selector (left) - "From" for transfer
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _showAccountModal(context),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.03,
                          vertical: screenWidth * 0.035,
                        ),
                        decoration: BoxDecoration(
                          color: isDark ? Colors.grey[800] : Colors.grey[100],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                selectedAccount,
                                style: GoogleFonts.poppins(
                                  fontSize: screenWidth * 0.035,
                                  color: isDark ? Colors.white : Colors.black87,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Icon(
                              Icons.keyboard_arrow_down_rounded,
                              color:
                                  isDark ? Colors.grey[400] : Colors.grey[600],
                              size: screenWidth * 0.05,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Arrow for transfer, spacing for others
                  if (_transactionType == 'transfer')
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
                      child: Icon(
                        Icons.arrow_forward_rounded,
                        color: Color.fromRGBO(52, 119, 216, 1),
                        size: screenWidth * 0.05,
                      ),
                    )
                  else
                    SizedBox(width: screenWidth * 0.02),
                  // Category Selector (right) or Account To for transfer
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _transactionType == 'transfer'
                          ? _showAccountToModal(context)
                          : _showCategoryModal(context),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.03,
                          vertical: screenWidth * 0.035,
                        ),
                        decoration: BoxDecoration(
                          color: isDark ? Colors.grey[800] : Colors.grey[100],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                _transactionType == 'transfer'
                                    ? selectedAccountTo
                                    : selectedCategory,
                                style: GoogleFonts.poppins(
                                  fontSize: screenWidth * 0.035,
                                  color: isDark ? Colors.white : Colors.black87,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Icon(
                              Icons.keyboard_arrow_down_rounded,
                              color:
                                  isDark ? Colors.grey[400] : Colors.grey[600],
                              size: screenWidth * 0.05,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: screenWidth * 0.02),

            // Description Input
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
              child: TextField(
                controller: _descriptionController,
                style: GoogleFonts.poppins(
                  fontSize: screenWidth * 0.038,
                  color: isDark ? Colors.white : Colors.black87,
                ),
                decoration: InputDecoration(
                  hintText: 'Description',
                  hintStyle: GoogleFonts.poppins(
                    color: Colors.grey[500],
                    fontSize: screenWidth * 0.038,
                  ),
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
            ),

            SizedBox(height: screenWidth * 0.02),

            // Calculator Keypad
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  left: screenWidth * 0.04,
                  right: screenWidth * 0.04,
                  bottom: screenWidth * 0.06,
                ),
                child: Row(
                  children: [
                    // Numbers grid (3 columns x 4 rows)
                    Expanded(
                      flex: 3,
                      child: Column(
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                _buildFlexButton('7',
                                    onPressed: () => _onNumberPress('7')),
                                _buildFlexButton('8',
                                    onPressed: () => _onNumberPress('8')),
                                _buildFlexButton('9',
                                    onPressed: () => _onNumberPress('9')),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Row(
                              children: [
                                _buildFlexButton('4',
                                    onPressed: () => _onNumberPress('4')),
                                _buildFlexButton('5',
                                    onPressed: () => _onNumberPress('5')),
                                _buildFlexButton('6',
                                    onPressed: () => _onNumberPress('6')),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Row(
                              children: [
                                _buildFlexButton('1',
                                    onPressed: () => _onNumberPress('1')),
                                _buildFlexButton('2',
                                    onPressed: () => _onNumberPress('2')),
                                _buildFlexButton('3',
                                    onPressed: () => _onNumberPress('3')),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Row(
                              children: [
                                _buildFlexButton('.',
                                    onPressed: () => _onNumberPress('.')),
                                _buildFlexButton('0',
                                    onPressed: () => _onNumberPress('0')),
                                _buildFlexButton(
                                  '⌫',
                                  color: Colors.grey[200],
                                  textColor: Colors.grey[600],
                                  onPressed: _onBackspace,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Operators column (1 column x 5 rows)
                    Expanded(
                      flex: 1,
                      child: Column(
                        children: [
                          _buildFlexButton('÷',
                              onPressed: () => _onOperationPress('÷')),
                          _buildFlexButton('×',
                              onPressed: () => _onOperationPress('×')),
                          _buildFlexButton('-',
                              onPressed: () => _onOperationPress('-')),
                          _buildFlexButton('+',
                              onPressed: () => _onOperationPress('+')),
                          _buildFlexButton(
                            '=',
                            isGradient: true,
                            onPressed: _onEquals,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
