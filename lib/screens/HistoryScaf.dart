import 'package:badyet/ExpenseItemClass.dart';
import 'package:badyet/ExpenseTodayHistoryBox.dart';
import 'package:badyet/ExpensesTodayBox.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';

class LatestHistory extends StatefulWidget {
  const LatestHistory({super.key});

  @override
  State<LatestHistory> createState() => _LatestHistoryState();
}

class _LatestHistoryState extends State<LatestHistory> {
  int _currentView = 0; // 0 = Cashflow, 1 = Categories
  DateTime _selectedMonth = DateTime.now();
  int _currentAccountIndex = 0; // For cycling through accounts, 0 = All
  Set<int> _selectedAccountIndices = {}; // Empty means all selected

  final List<String> months = [
    "January", "February", "March", "April", "May", "June",
    "July", "August", "September", "October", "November", "December"
  ];

  List<Map<String, dynamic>> _getAccounts() {
    List<dynamic> stored = Hive.box('Budget').get('accounts', defaultValue: [
      {'name': 'Cash', 'accNo': '', 'balance': 0.0}
    ]);
    return stored.map((e) => Map<String, dynamic>.from(e)).toList();
  }

  List<String> _getAccountNames() {
    return _getAccounts().map((e) => e['name'] as String).toList();
  }

  List<String> _getSelectedAccountNames() {
    List<String> allNames = _getAccountNames();
    if (_selectedAccountIndices.isEmpty) {
      return allNames; // All selected
    }
    return _selectedAccountIndices.map((i) => allNames[i]).toList();
  }

  void _showAccountSelectionModal(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    List<Map<String, dynamic>> accounts = _getAccounts();

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
            // All Accounts option
            GestureDetector(
              onTap: () {
                setState(() => _currentAccountIndex = 0);
                Navigator.pop(context);
              },
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.06,
                  vertical: screenWidth * 0.04,
                ),
                decoration: BoxDecoration(
                  color: _currentAccountIndex == 0
                      ? (isDark ? Colors.grey[800] : Colors.grey[100])
                      : Colors.transparent,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'All Accounts',
                      style: GoogleFonts.poppins(
                        fontSize: screenWidth * 0.04,
                        fontWeight: _currentAccountIndex == 0 ? FontWeight.w600 : FontWeight.w400,
                        color: _currentAccountIndex == 0
                            ? Color.fromRGBO(52, 119, 216, 1)
                            : (isDark ? Colors.white : Colors.black87),
                      ),
                    ),
                    if (_currentAccountIndex == 0)
                      Icon(
                        Icons.check_rounded,
                        color: Color.fromRGBO(52, 119, 216, 1),
                        size: screenWidth * 0.05,
                      ),
                  ],
                ),
              ),
            ),
            // Individual accounts
            ...accounts.asMap().entries.map((entry) {
              int index = entry.key + 1; // +1 because 0 is "All Accounts"
              Map<String, dynamic> account = entry.value;
              bool isSelected = _currentAccountIndex == index;

              return GestureDetector(
                onTap: () {
                  setState(() => _currentAccountIndex = index);
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
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            account['name'],
                            style: GoogleFonts.poppins(
                              fontSize: screenWidth * 0.04,
                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                              color: isSelected
                                  ? Color.fromRGBO(52, 119, 216, 1)
                                  : (isDark ? Colors.white : Colors.black87),
                            ),
                          ),
                          Text(
                            'P ${(account['balance'] as num).toStringAsFixed(0)}',
                            style: GoogleFonts.poppins(
                              fontSize: screenWidth * 0.032,
                              color: isDark ? Colors.grey[500] : Colors.grey[500],
                            ),
                          ),
                        ],
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
            }).toList(),
            SizedBox(height: screenWidth * 0.04),
          ],
        ),
      ),
    );
  }

  double _getCurrentAccountBalance() {
    List<Map<String, dynamic>> accounts = _getAccounts();
    if (_currentAccountIndex == 0) {
      // All accounts - sum all balances
      double total = 0;
      for (var acc in accounts) {
        total += (acc['balance'] as num).toDouble();
      }
      return total;
    } else {
      return (accounts[_currentAccountIndex - 1]['balance'] as num).toDouble();
    }
  }

  String _getCurrentAccountName() {
    if (_currentAccountIndex == 0) {
      return 'All Accounts';
    }
    List<Map<String, dynamic>> accounts = _getAccounts();
    return accounts[_currentAccountIndex - 1]['name'];
  }

  List<Map<String, dynamic>> _getTransactionsFromHive() {
    List<Map<String, dynamic>> transactions = [];

    for (var item in expenseTodayHistoryBox.values) {
      transactions.add({
        'date': item.date,
        'category': item.category,
        'type': item.type,
        'price': double.tryParse(item.price) ?? 0.0,
        'isIncome': item.category == 'Income',
        'account': item.account,
      });
    }

    return transactions;
  }

  List<Map<String, dynamic>> _getFilteredTransactions({bool filterByAccount = true}) {
    List<Map<String, dynamic>> all = _getTransactionsFromHive();
    String? currentAccountName = filterByAccount && _currentAccountIndex > 0
        ? _getCurrentAccountName()
        : null;

    // Filter by selected month and optionally by account
    return all.where((t) {
      try {
        // Exclude transfers when "All Accounts" is selected
        if (_currentAccountIndex == 0 && t['category'] == 'Transfer') {
          return false;
        }

        // Try parsing the date - handle different formats
        DateTime date;
        String dateStr = t['date'];

        // Try common date formats
        if (dateStr.contains('-')) {
          date = DateTime.parse(dateStr);
        } else if (dateStr.contains('/')) {
          List<String> parts = dateStr.split('/');
          if (parts.length == 3) {
            date = DateTime(int.parse(parts[2]), int.parse(parts[0]), int.parse(parts[1]));
          } else {
            return false;
          }
        } else {
          return false;
        }

        bool matchesMonth = date.year == _selectedMonth.year && date.month == _selectedMonth.month;

        // Filter by account if specified
        if (currentAccountName != null) {
          String transactionAccount = t['account'] ?? '';
          
          // For transfers, only include if the selected account is the source (deducted) account
          if (t['category'] == 'Transfer') {
            return matchesMonth && transactionAccount == currentAccountName;
          }
          
          return matchesMonth && (transactionAccount == currentAccountName || transactionAccount.isEmpty);
        }

        return matchesMonth;
      } catch (e) {
        return false;
      }
    }).toList();
  }

  Map<String, List<Map<String, dynamic>>> _groupByDate(List<Map<String, dynamic>> transactions) {
    Map<String, List<Map<String, dynamic>>> grouped = {};
    for (var t in transactions) {
      String date = t['date'];
      if (!grouped.containsKey(date)) {
        grouped[date] = [];
      }
      grouped[date]!.add(t);
    }
    return grouped;
  }

  double _getDayCashflow(List<Map<String, dynamic>> dayTransactions) {
    double total = 0;
    for (var t in dayTransactions) {
      if (t['isIncome'] == true) {
        total += t['price'];
      } else {
        total -= t['price'];
      }
    }
    return total;
  }

  Map<String, double> _getCategoryTotals(List<Map<String, dynamic>> transactions) {
    Map<String, double> totals = {};
    for (var t in transactions) {
      if (t['isIncome'] != true) {
        String cat = t['category'];
        totals[cat] = (totals[cat] ?? 0) + t['price'];
      }
    }
    return totals;
  }

  double _getTotalExpenses(List<Map<String, dynamic>> transactions) {
    double total = 0;
    for (var t in transactions) {
      if (t['isIncome'] != true) {
        total += t['price'];
      }
    }
    return total;
  }

  double _getTotalIncome(List<Map<String, dynamic>> transactions) {
    double total = 0;
    for (var t in transactions) {
      if (t['isIncome'] == true) {
        total += t['price'];
      }
    }
    return total;
  }

  String _formatDate(String dateStr) {
    try {
      DateTime date;
      if (dateStr.contains('-')) {
        date = DateTime.parse(dateStr);
      } else if (dateStr.contains('/')) {
        List<String> parts = dateStr.split('/');
        if (parts.length == 3) {
          date = DateTime(int.parse(parts[2]), int.parse(parts[0]), int.parse(parts[1]));
        } else {
          return dateStr;
        }
      } else {
        return dateStr;
      }
      List<String> weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
      return '${weekdays[date.weekday - 1]}, ${months[date.month - 1]} ${date.day}';
    } catch (e) {
      return dateStr;
    }
  }

  void _previousMonth() {
    setState(() {
      _selectedMonth = DateTime(_selectedMonth.year, _selectedMonth.month - 1);
    });
  }

  void _nextMonth() {
    setState(() {
      _selectedMonth = DateTime(_selectedMonth.year, _selectedMonth.month + 1);
    });
  }

  Color _getCategoryColor(String category, {bool isDark = false}) {
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
        return isDark ? Color(0xFF81C784) : Color(0xFF228B22); // Green
      case 'Transfer':
        return Color(0xFF3477D8); // Blue (brand color)
      default:
        return Color(0xFFB0B0B0); // Gray (Others)
    }
  }

  IconData _getCategoryIcon(String category) {
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

  ExpenseItemClass? _findExpenseItem(Map<String, dynamic> transaction) {
    // Find the matching ExpenseItemClass in Hive
    double transactionPrice = (transaction['price'] as num).toDouble();
    String transactionDate = transaction['date'] ?? '';
    String transactionCategory = transaction['category'] ?? '';
    String transactionType = transaction['type'] ?? '';
    String transactionAccount = transaction['account'] ?? '';
    
    for (var key in expenseTodayHistoryBox.keys) {
      ExpenseItemClass? item = expenseTodayHistoryBox.get(key);
      if (item != null) {
        double itemPrice = double.tryParse(item.price) ?? 0.0;
        // Compare with tolerance for floating point precision
        bool priceMatches = (itemPrice - transactionPrice).abs() < 0.01;
        
        if (item.date == transactionDate &&
            item.category == transactionCategory &&
            item.type == transactionType &&
            priceMatches &&
            (item.account == transactionAccount || (item.account.isEmpty && transactionAccount.isEmpty))) {
          return item;
        }
      }
    }
    return null;
  }

  void _updateExpenseItem(ExpenseItemClass oldItem, ExpenseItemClass newItem) {
    // Update in expenseTodayHistoryBox
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

    // Also check and update in expenseTodayBox if it exists there
    DateTime itemDate = DateTime.parse(newItem.date);
    bool isToday = itemDate.year == DateTime.now().year &&
                   itemDate.month == DateTime.now().month &&
                   itemDate.day == DateTime.now().day;
    
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
  }

  void _showEditExpenseModal(BuildContext context, Map<String, dynamic> transaction) {
    ExpenseItemClass? item = _findExpenseItem(transaction);
    if (item == null) {
      // Show error message if item not found
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not find transaction to edit'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

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

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? Color(0xFF121212) : Colors.grey[50],
      body: SafeArea(
        child: ValueListenableBuilder<Box<ExpenseItemClass>>(
          valueListenable: expenseTodayHistoryBox.listenable(),
          builder: (context, box, _) {
            List<Map<String, dynamic>> filteredTransactions = _getFilteredTransactions();

            return Column(
              children: [
                // Header
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.04,
                    vertical: screenWidth * 0.03,
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(
                          Icons.arrow_back_ios_rounded,
                          size: screenWidth * 0.06,
                          color: isDark ? Colors.grey[400] : Colors.grey[700],
                        ),
                      ),
                      Expanded(
                        child: Text(
                          'Analytics',
                          style: GoogleFonts.poppins(
                            fontSize: screenWidth * 0.055,
                            fontWeight: FontWeight.w600,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(width: screenWidth * 0.12),
                    ],
                  ),
                ),
                // Subtle divider
                Divider(
                  height: 1,
                  thickness: 1,
                  color: isDark ? Colors.grey[800] : Colors.grey[200],
                ),

                // Month Selector
                Container(
                  padding: EdgeInsets.only(
                    left: screenWidth * 0.06,
                    right: screenWidth * 0.06,
                    top: screenWidth * 0.04,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: _previousMonth,
                        icon: Icon(
                          Icons.chevron_left_rounded,
                          size: screenWidth * 0.08,
                          color: Color.fromRGBO(52, 119, 216, 1),
                        ),
                      ),
                      Text(
                        '${months[_selectedMonth.month - 1]} ${_selectedMonth.year}',
                        style: GoogleFonts.poppins(
                          fontSize: screenWidth * 0.045,
                          fontWeight: FontWeight.w600,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                      IconButton(
                        onPressed: _nextMonth,
                        icon: Icon(
                          Icons.chevron_right_rounded,
                          size: screenWidth * 0.08,
                          color: Color.fromRGBO(52, 119, 216, 1),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: screenWidth * 0.03),

                // Account Balance Card (tappable to select account)
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
                  child: GestureDetector(
                    onTap: () => _showAccountSelectionModal(context),
                    child: Container(
                      padding: EdgeInsets.all(2.5),
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
                          horizontal: screenWidth * 0.05,
                        ),
                        decoration: BoxDecoration(
                          color: isDark ? Color(0xFF1E1E1E) : Colors.white,
                          borderRadius: BorderRadius.circular(17.5),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      _getCurrentAccountName(),
                                      style: GoogleFonts.poppins(
                                        fontSize: screenWidth * 0.035,
                                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                                      ),
                                    ),
                                    SizedBox(width: 4),
                                    Icon(
                                      Icons.swap_horiz_rounded,
                                      size: screenWidth * 0.04,
                                      color: isDark ? Colors.grey[500] : Colors.grey[400],
                                    ),
                                  ],
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'P ${_getCurrentAccountBalance().toStringAsFixed(0)}',
                                  style: GoogleFonts.poppins(
                                    fontSize: screenWidth * 0.07,
                                    fontWeight: FontWeight.w700,
                                    color: isDark ? Colors.white : Color(0xFF2F2F2F),
                                  ),
                                ),
                              ],
                            ),
                            Icon(
                              Icons.keyboard_arrow_down_rounded,
                              size: screenWidth * 0.06,
                              color: isDark ? Colors.grey[500] : Colors.grey[400],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: screenWidth * 0.03),

                // Income & Expenses Summary
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
                  child: Row(
                    children: [
                      // Income
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.all(screenWidth * 0.04),
                          decoration: BoxDecoration(
                            color: isDark ? Color(0xFF1E1E1E) : Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.03),
                                blurRadius: 10,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: (isDark ? Color(0xFF81C784) : Color(0xFF228B22)).withOpacity(0.15),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Icon(
                                      Icons.arrow_downward_rounded,
                                      size: screenWidth * 0.04,
                                      color: isDark ? Color(0xFF81C784) : Color(0xFF228B22),
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    'Income',
                                    style: GoogleFonts.poppins(
                                      fontSize: screenWidth * 0.032,
                                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8),
                              Text(
                                'P ${_getTotalIncome(filteredTransactions).toStringAsFixed(0)}',
                                style: GoogleFonts.poppins(
                                  fontSize: screenWidth * 0.045,
                                  fontWeight: FontWeight.w700,
                                  color: isDark ? Color(0xFF81C784) : Color(0xFF228B22),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: screenWidth * 0.03),
                      // Expenses
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.all(screenWidth * 0.04),
                          decoration: BoxDecoration(
                            color: isDark ? Color(0xFF1E1E1E) : Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.03),
                                blurRadius: 10,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: Colors.red[400]!.withOpacity(0.15),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Icon(
                                      Icons.arrow_upward_rounded,
                                      size: screenWidth * 0.04,
                                      color: Colors.red[400],
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    'Expenses',
                                    style: GoogleFonts.poppins(
                                      fontSize: screenWidth * 0.032,
                                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8),
                              Text(
                                'P ${_getTotalExpenses(filteredTransactions).toStringAsFixed(0)}',
                                style: GoogleFonts.poppins(
                                  fontSize: screenWidth * 0.045,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.red[400],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: screenWidth * 0.04),

                // View Toggle
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
                            onTap: () => setState(() => _currentView = 0),
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: screenWidth * 0.03),
                              decoration: BoxDecoration(
                                color: _currentView == 0 ? (isDark ? Colors.grey[700] : Colors.white) : Colors.transparent,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: Text(
                                  'Cashflow',
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w500,
                                    color: _currentView == 0
                                        ? (isDark ? Colors.white : Color.fromRGBO(52, 119, 216, 1))
                                        : (isDark ? Colors.white.withOpacity(0.4) : Colors.grey[500]),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => setState(() => _currentView = 1),
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: screenWidth * 0.03),
                              decoration: BoxDecoration(
                                color: _currentView == 1 ? (isDark ? Colors.grey[700] : Colors.white) : Colors.transparent,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: Text(
                                  'Categories',
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w500,
                                    color: _currentView == 1
                                        ? (isDark ? Colors.white : Color.fromRGBO(52, 119, 216, 1))
                                        : (isDark ? Colors.white.withOpacity(0.4) : Colors.grey[500]),
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

                SizedBox(height: screenWidth * 0.04),

                // Content
                Expanded(
                  child: _currentView == 0
                      ? _buildCashflowView(screenWidth, filteredTransactions)
                      : _buildCategoriesView(screenWidth, filteredTransactions),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildCashflowView(double screenWidth, List<Map<String, dynamic>> transactions) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (transactions.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.receipt_long_rounded,
              size: screenWidth * 0.2,
              color: isDark ? Colors.grey[600] : Colors.grey[300],
            ),
            SizedBox(height: screenWidth * 0.04),
            Text(
              'No transactions this month',
              style: GoogleFonts.poppins(
                color: isDark ? Colors.grey[500] : Colors.grey[400],
                fontSize: screenWidth * 0.04,
              ),
            ),
          ],
        ),
      );
    }

    Map<String, List<Map<String, dynamic>>> grouped = _groupByDate(transactions);
    List<String> sortedDates = grouped.keys.toList()..sort((a, b) => b.compareTo(a));

    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
      itemCount: sortedDates.length,
      itemBuilder: (context, index) {
        String date = sortedDates[index];
        List<Map<String, dynamic>> dayTransactions = grouped[date]!;
        double dayCashflow = _getDayCashflow(dayTransactions);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date Header
            Container(
              padding: EdgeInsets.symmetric(vertical: screenWidth * 0.03),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _formatDate(date),
                    style: GoogleFonts.poppins(
                      fontSize: screenWidth * 0.038,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.grey[400] : Colors.grey[700],
                    ),
                  ),
                  Text(
                    '${dayCashflow >= 0 ? '+' : ''}P ${dayCashflow.toStringAsFixed(0)}',
                    style: GoogleFonts.poppins(
                      fontSize: screenWidth * 0.038,
                      fontWeight: FontWeight.w600,
                      color: dayCashflow >= 0 ? (isDark ? Color(0xFF81C784) : Color.fromRGBO(34, 139, 34, 1)) : Colors.red[400],
                    ),
                  ),
                ],
              ),
            ),
            // Transactions
            Container(
              decoration: BoxDecoration(
                color: isDark ? Colors.grey[850] : Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 10,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: dayTransactions.asMap().entries.map((entry) {
                  int i = entry.key;
                  Map<String, dynamic> t = entry.value;
                  bool isLast = i == dayTransactions.length - 1;

                  return GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => _showEditExpenseModal(context, t),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.04,
                        vertical: screenWidth * 0.035,
                      ),
                      decoration: BoxDecoration(
                        border: isLast ? null : Border(
                          bottom: BorderSide(color: isDark ? Colors.grey[700]! : Colors.grey[100]!, width: 1),
                        ),
                      ),
                      child: Row(
                        children: [
                        Container(
                          padding: EdgeInsets.all(screenWidth * 0.025),
                          decoration: BoxDecoration(
                            color: _getCategoryColor(t['category'], isDark: isDark).withOpacity(0.15),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            _getCategoryIcon(t['category']),
                            size: screenWidth * 0.055,
                            color: _getCategoryColor(t['category'], isDark: isDark),
                          ),
                        ),
                        SizedBox(width: screenWidth * 0.035),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                t['category'],
                                style: GoogleFonts.poppins(
                                  fontSize: screenWidth * 0.035,
                                  fontWeight: FontWeight.w500,
                                  color: isDark ? Colors.white : Colors.black87,
                                ),
                              ),
                              Text(
                                t['type'],
                                style: GoogleFonts.poppins(
                                  fontSize: screenWidth * 0.03,
                                  color: isDark ? Colors.grey[400] : Colors.grey[500],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          '${t['isIncome'] == true ? '+' : '-'} P ${t['price'].toStringAsFixed(0)}',
                          style: GoogleFonts.poppins(
                            fontSize: screenWidth * 0.035,
                            fontWeight: FontWeight.w500,
                            color: t['isIncome'] == true ? (isDark ? Color(0xFF81C784) : Color.fromRGBO(34, 139, 34, 1)) : Colors.red[400],
                          ),
                        ),
                      ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            SizedBox(height: screenWidth * 0.04),
          ],
        );
      },
    );
  }

  Widget _buildCategoriesView(double screenWidth, List<Map<String, dynamic>> transactions) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    Map<String, double> categoryTotals = _getCategoryTotals(transactions);
    double totalExpenses = _getTotalExpenses(transactions);

    if (categoryTotals.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.pie_chart_outline_rounded,
              size: screenWidth * 0.2,
              color: Colors.grey[300],
            ),
            SizedBox(height: screenWidth * 0.04),
            Text(
              'No expenses this month',
              style: GoogleFonts.poppins(
                color: Colors.grey[400],
                fontSize: screenWidth * 0.04,
              ),
            ),
          ],
        ),
      );
    }

    List<MapEntry<String, double>> sortedCategories = categoryTotals.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
      child: Column(
        children: [
          // Visual Bar Chart
          Container(
            padding: EdgeInsets.all(screenWidth * 0.05),
            decoration: BoxDecoration(
              color: isDark ? Color(0xFF1E1E1E) : Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 10,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Spending by Category',
                  style: GoogleFonts.poppins(
                    fontSize: screenWidth * 0.04,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                SizedBox(height: screenWidth * 0.04),
                // Stacked bar
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    height: screenWidth * 0.06,
                    child: Row(
                      children: sortedCategories.map((entry) {
                        double percentage = entry.value / totalExpenses;
                        return Expanded(
                          flex: (percentage * 100).round().clamp(1, 100),
                          child: Container(
                            color: _getCategoryColor(entry.key, isDark: isDark),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                SizedBox(height: screenWidth * 0.05),
                // Legend
                Wrap(
                  spacing: screenWidth * 0.04,
                  runSpacing: screenWidth * 0.02,
                  children: sortedCategories.map((entry) {
                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: screenWidth * 0.025,
                          height: screenWidth * 0.025,
                          decoration: BoxDecoration(
                            color: _getCategoryColor(entry.key, isDark: isDark),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        SizedBox(width: screenWidth * 0.015),
                        Text(
                          entry.key,
                          style: GoogleFonts.poppins(
                            fontSize: screenWidth * 0.028,
                            color: isDark ? Colors.grey[400] : Colors.grey[600],
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ],
            ),
          ),

          SizedBox(height: screenWidth * 0.05),

          // Category List
          ...sortedCategories.map((entry) {
            double percentage = (entry.value / totalExpenses * 100);
            return Container(
              margin: EdgeInsets.only(bottom: screenWidth * 0.03),
              padding: EdgeInsets.all(screenWidth * 0.04),
              decoration: BoxDecoration(
                color: isDark ? Color(0xFF1E1E1E) : Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 10,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(screenWidth * 0.03),
                    decoration: BoxDecoration(
                      color: _getCategoryColor(entry.key, isDark: isDark).withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      _getCategoryIcon(entry.key),
                      size: screenWidth * 0.06,
                      color: _getCategoryColor(entry.key, isDark: isDark),
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.04),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          entry.key,
                          style: GoogleFonts.poppins(
                            fontSize: screenWidth * 0.038,
                            fontWeight: FontWeight.w500,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                        ),
                        SizedBox(height: screenWidth * 0.015),
                        // Progress bar
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: percentage / 100,
                            backgroundColor: isDark ? Colors.grey[700] : Colors.grey[200],
                            valueColor: AlwaysStoppedAnimation<Color>(_getCategoryColor(entry.key, isDark: isDark)),
                            minHeight: screenWidth * 0.015,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.04),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'P ${entry.value.toStringAsFixed(0)}',
                        style: GoogleFonts.poppins(
                          fontSize: screenWidth * 0.038,
                          fontWeight: FontWeight.w600,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                      Text(
                        '${percentage.toStringAsFixed(1)}%',
                        style: GoogleFonts.poppins(
                          fontSize: screenWidth * 0.03,
                          color: isDark ? Colors.grey[400] : Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }).toList(),

          SizedBox(height: screenWidth * 0.1),
        ],
      ),
    );
  }
}
