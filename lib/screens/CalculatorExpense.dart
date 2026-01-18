import 'package:badyet/ExpenseItemClass.dart';
import 'package:badyet/ExpenseTodayHistoryBox.dart';
import 'package:badyet/ExpensesTodayBox.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'dart:math';

class CalculatorExpensePage extends StatefulWidget {
  final String? initialAccount;

  const CalculatorExpensePage({super.key, this.initialAccount});

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
    selectedAccount = widget.initialAccount ?? (accountNames.isNotEmpty ? accountNames.first : 'Cash');
    selectedAccountTo = accountNames.length > 1 ? accountNames[1] : (accountNames.isNotEmpty ? accountNames.first : 'Cash');
  }

  List<String> _getAccountNames() {
    List<dynamic> stored = Hive.box('Budget').get('accounts', defaultValue: [
      {'name': 'Cash', 'accNo': '', 'balance': 0.0}
    ]);
    return stored.map((e) => (e as Map)['name'] as String).toList();
  }

  List<String> get accounts => _getAccountNames();

  final List<String> categories = [
    'Food & Drinks',
    'Shopping',
    'Housing',
    'Transportation',
    'Vehicle',
    'Life & Entertainment',
    'Communication, PC',
    'Financial Expenses',
    'Investments',
    'Income',
    'Others'
  ];

  final box = Hive.box('Budget');

  String generateKey(int len) {
    var r = Random();
    const chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
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

  void _onClear() {
    setState(() {
      _display = '0';
      _currentOperation = '';
      _firstOperand = 0;
      _shouldResetDisplay = false;
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

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
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
              'Select Account',
              style: GoogleFonts.poppins(
                fontSize: screenWidth * 0.045,
                fontWeight: FontWeight.w600,
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
                        color: isSelected ? Colors.grey[100] : Colors.transparent,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            account,
                            style: GoogleFonts.poppins(
                              fontSize: screenWidth * 0.04,
                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                              color: isSelected ? Color.fromRGBO(52, 119, 216, 1) : Colors.black87,
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

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
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
              'Transfer To',
              style: GoogleFonts.poppins(
                fontSize: screenWidth * 0.045,
                fontWeight: FontWeight.w600,
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
                        color: isSelected ? Colors.grey[100] : Colors.transparent,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            account,
                            style: GoogleFonts.poppins(
                              fontSize: screenWidth * 0.04,
                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                              color: isSelected ? Color.fromRGBO(52, 119, 216, 1) : Colors.black87,
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

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
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
              'Select Category',
              style: GoogleFonts.poppins(
                fontSize: screenWidth * 0.045,
                fontWeight: FontWeight.w600,
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
                        color: isSelected ? Colors.grey[100] : Colors.transparent,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            category,
                            style: GoogleFonts.poppins(
                              fontSize: screenWidth * 0.04,
                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                              color: isSelected ? Color.fromRGBO(52, 119, 216, 1) : Colors.black87,
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

  void _updateAccountBalance(String accountName, double amount, bool isAdd) {
    List<dynamic> stored = box.get('accounts', defaultValue: [
      {'name': 'Cash', 'accNo': '', 'balance': 0.0}
    ]);
    List<Map<String, dynamic>> accounts = stored.map((e) => Map<String, dynamic>.from(e)).toList();

    for (int i = 0; i < accounts.length; i++) {
      if (accounts[i]['name'] == accountName) {
        double currentBalance = (accounts[i]['balance'] as num).toDouble();
        accounts[i]['balance'] = isAdd ? currentBalance + amount : currentBalance - amount;
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

    DateTime today = DateTime.now();
    String dateStr = "${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}";
    String description = _descriptionController.text.isEmpty
        ? selectedCategory
        : _descriptionController.text;

    // Save to Hive boxes (not for transfers)
    if (_transactionType != 'transfer') {
      String category = _transactionType == 'income' ? 'Income' : selectedCategory;
      expenseTodayBox.put(
        "key_${generateKey(15)}",
        ExpenseItemClass(dateStr, category, description, _display),
      );
      expenseTodayHistoryBox.put(
        "key_${generateKey(15)}",
        ExpenseItemClass(dateStr, category, description, _display),
      );
    }

    // Update budget
    double currentBudget = box.get("RecBudgetToday", defaultValue: 0.0);
    double totalExpensesWeek = box.get("TotalExpensesWeek", defaultValue: 0.0);

    if (_transactionType == 'income') {
      // Add to account balance
      _updateAccountBalance(selectedAccount, amount, true);
      box.put("RecBudgetToday", currentBudget + amount);
    } else if (_transactionType == 'expense') {
      // Subtract from account balance
      _updateAccountBalance(selectedAccount, amount, false);
      box.put("RecBudgetToday", currentBudget - amount);
      box.put("TotalExpensesWeek", totalExpensesWeek + amount);
    } else if (_transactionType == 'transfer') {
      // Subtract from source, add to destination
      _updateAccountBalance(selectedAccount, amount, false);
      _updateAccountBalance(selectedAccountTo, amount, true);
    }

    Navigator.pop(context);
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  Widget _buildCalcButton(String text, {Color? color, Color? textColor, VoidCallback? onPressed, double? height}) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool isOperator = ['+', '-', '×', '÷', '='].contains(text);

    return Expanded(
      child: Padding(
        padding: EdgeInsets.all(screenWidth * 0.01),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onPressed,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              height: height ?? screenWidth * 0.13,
              decoration: BoxDecoration(
                color: color ?? (isOperator ? Color.fromRGBO(52, 119, 216, 0.1) : Colors.grey[100]),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  text,
                  style: GoogleFonts.poppins(
                    fontSize: screenWidth * 0.055,
                    fontWeight: FontWeight.w500,
                    color: textColor ?? (isOperator ? Color.fromRGBO(52, 119, 216, 1) : Colors.black87),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFlexButton(String text, {Color? color, Color? textColor, VoidCallback? onPressed, bool isGradient = false}) {
    double screenWidth = MediaQuery.of(context).size.width;
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
                color: isGradient ? null : (color ?? (isOperator ? Colors.grey[300] : Colors.grey[100])),
                gradient: isGradient ? LinearGradient(
                  colors: [
                    Color.fromRGBO(52, 119, 216, 1),
                    Color.fromRGBO(81, 218, 96, 1),
                  ],
                ) : null,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  text,
                  style: GoogleFonts.poppins(
                    fontSize: screenWidth * 0.055,
                    fontWeight: FontWeight.w500,
                    color: isGradient ? Colors.white : (textColor ?? (isOperator ? Colors.grey[700] : Colors.black87)),
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

    return Scaffold(
      backgroundColor: Colors.white,
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
                      color: Colors.grey[600],
                    ),
                  ),
                  Text(
                    _transactionType == 'expense' ? 'Add Expense' : (_transactionType == 'income' ? 'Add Income' : 'Transfer'),
                    style: GoogleFonts.poppins(
                      fontSize: screenWidth * 0.045,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  IconButton(
                    onPressed: _saveExpense,
                    icon: Icon(
                      Icons.check_rounded,
                      size: screenWidth * 0.08,
                      color: Colors.grey[600],
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
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _transactionType = 'expense'),
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: screenWidth * 0.025),
                          decoration: BoxDecoration(
                            color: _transactionType == 'expense' ? Colors.white : Colors.transparent,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: _transactionType == 'expense' ? [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 4,
                              ),
                            ] : null,
                          ),
                          child: Center(
                            child: Text(
                              'Expense',
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w500,
                                color: _transactionType == 'expense' ? Colors.red[400] : Colors.grey[600],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _transactionType = 'income'),
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: screenWidth * 0.025),
                          decoration: BoxDecoration(
                            color: _transactionType == 'income' ? Colors.white : Colors.transparent,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: _transactionType == 'income' ? [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 4,
                              ),
                            ] : null,
                          ),
                          child: Center(
                            child: Text(
                              'Income',
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w500,
                                color: _transactionType == 'income' ? Color.fromRGBO(34, 139, 34, 1) : Colors.grey[600],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _transactionType = 'transfer'),
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: screenWidth * 0.025),
                          decoration: BoxDecoration(
                            color: _transactionType == 'transfer' ? Colors.white : Colors.transparent,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: _transactionType == 'transfer' ? [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 4,
                              ),
                            ] : null,
                          ),
                          child: Center(
                            child: Text(
                              'Transfer',
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w500,
                                color: _transactionType == 'transfer' ? Color.fromRGBO(52, 119, 216, 1) : Colors.grey[600],
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
                    color: Colors.white,
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
                            _transactionType == 'expense' ? '-' : (_transactionType == 'income' ? '+' : '<->'),
                            style: GoogleFonts.poppins(
                              fontSize: screenWidth * 0.08,
                              fontWeight: FontWeight.w300,
                              color: _transactionType == 'expense' ? Colors.red[400] : (_transactionType == 'income' ? Color.fromRGBO(34, 139, 34, 1) : Color.fromRGBO(52, 119, 216, 1)),
                            ),
                          ),
                          Spacer(),
                          Text(
                            _display,
                            style: GoogleFonts.poppins(
                              fontSize: screenWidth * 0.1,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF2F2F2F),
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
                          color: Colors.grey[100],
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
                                  color: Colors.black87,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Icon(
                              Icons.keyboard_arrow_down_rounded,
                              color: Colors.grey[600],
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
                      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
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
                          color: Colors.grey[100],
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
                                  color: Colors.black87,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Icon(
                              Icons.keyboard_arrow_down_rounded,
                              color: Colors.grey[600],
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
                style: GoogleFonts.poppins(fontSize: screenWidth * 0.038),
                decoration: InputDecoration(
                  hintText: 'Description',
                  hintStyle: GoogleFonts.poppins(
                    color: Colors.grey[500],
                    fontSize: screenWidth * 0.038,
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
                                _buildFlexButton('7', onPressed: () => _onNumberPress('7')),
                                _buildFlexButton('8', onPressed: () => _onNumberPress('8')),
                                _buildFlexButton('9', onPressed: () => _onNumberPress('9')),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Row(
                              children: [
                                _buildFlexButton('4', onPressed: () => _onNumberPress('4')),
                                _buildFlexButton('5', onPressed: () => _onNumberPress('5')),
                                _buildFlexButton('6', onPressed: () => _onNumberPress('6')),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Row(
                              children: [
                                _buildFlexButton('1', onPressed: () => _onNumberPress('1')),
                                _buildFlexButton('2', onPressed: () => _onNumberPress('2')),
                                _buildFlexButton('3', onPressed: () => _onNumberPress('3')),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Row(
                              children: [
                                _buildFlexButton('.', onPressed: () => _onNumberPress('.')),
                                _buildFlexButton('0', onPressed: () => _onNumberPress('0')),
                                _buildFlexButton('⌫',
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
                          _buildFlexButton('÷', onPressed: () => _onOperationPress('÷')),
                          _buildFlexButton('×', onPressed: () => _onOperationPress('×')),
                          _buildFlexButton('-', onPressed: () => _onOperationPress('-')),
                          _buildFlexButton('+', onPressed: () => _onOperationPress('+')),
                          _buildFlexButton('=',
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
