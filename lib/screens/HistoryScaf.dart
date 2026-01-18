import 'package:badyet/ExpenseItemClass.dart';
import 'package:badyet/ExpenseTodayHistoryBox.dart';
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

  final List<String> months = [
    "January", "February", "March", "April", "May", "June",
    "July", "August", "September", "October", "November", "December"
  ];

  List<Map<String, dynamic>> _getTransactionsFromHive() {
    List<Map<String, dynamic>> transactions = [];

    for (var item in expenseTodayHistoryBox.values) {
      transactions.add({
        'date': item.date,
        'category': item.category,
        'type': item.type,
        'price': double.tryParse(item.price) ?? 0.0,
        'isIncome': item.category == 'Income',
      });
    }

    return transactions;
  }

  List<Map<String, dynamic>> _getFilteredTransactions() {
    List<Map<String, dynamic>> all = _getTransactionsFromHive();

    // Filter by selected month
    return all.where((t) {
      try {
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

        return date.year == _selectedMonth.year && date.month == _selectedMonth.month;
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

  Color _getCategoryColor(String category) {
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
      default:
        return Color(0xFFB0B0B0);
    }
  }

  IconData _getCategoryIcon(String category) {
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

    return Scaffold(
      backgroundColor: Colors.grey[50],
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
                          color: Colors.grey[700],
                        ),
                      ),
                      Expanded(
                        child: Text(
                          'Analytics',
                          style: GoogleFonts.poppins(
                            fontSize: screenWidth * 0.055,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(width: screenWidth * 0.12),
                    ],
                  ),
                ),

                // Month Selector
                Container(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
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

                // Summary Card
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
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
                      padding: EdgeInsets.all(screenWidth * 0.05),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(17.5),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              Text(
                                'Income',
                                style: GoogleFonts.poppins(
                                  fontSize: screenWidth * 0.032,
                                  color: Colors.grey[500],
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'P ${_getTotalIncome(filteredTransactions).toStringAsFixed(0)}',
                                style: GoogleFonts.poppins(
                                  fontSize: screenWidth * 0.045,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF2F2F2F),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            width: 1,
                            height: screenWidth * 0.12,
                            color: Colors.grey[300],
                          ),
                          Column(
                            children: [
                              Text(
                                'Expenses',
                                style: GoogleFonts.poppins(
                                  fontSize: screenWidth * 0.032,
                                  color: Colors.grey[500],
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'P ${_getTotalExpenses(filteredTransactions).toStringAsFixed(0)}',
                                style: GoogleFonts.poppins(
                                  fontSize: screenWidth * 0.045,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF2F2F2F),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            width: 1,
                            height: screenWidth * 0.12,
                            color: Colors.grey[300],
                          ),
                          Column(
                            children: [
                              Text(
                                'Balance',
                                style: GoogleFonts.poppins(
                                  fontSize: screenWidth * 0.032,
                                  color: Colors.grey[500],
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'P ${(_getTotalIncome(filteredTransactions) - _getTotalExpenses(filteredTransactions)).toStringAsFixed(0)}',
                                style: GoogleFonts.poppins(
                                  fontSize: screenWidth * 0.045,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF2F2F2F),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                SizedBox(height: screenWidth * 0.05),

                // View Toggle
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
                            onTap: () => setState(() => _currentView = 0),
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: screenWidth * 0.03),
                              decoration: BoxDecoration(
                                color: _currentView == 0 ? Colors.white : Colors.transparent,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: _currentView == 0 ? [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 4,
                                  ),
                                ] : null,
                              ),
                              child: Center(
                                child: Text(
                                  'Cashflow',
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w500,
                                    color: _currentView == 0 ? Color.fromRGBO(52, 119, 216, 1) : Colors.grey[600],
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
                                color: _currentView == 1 ? Colors.white : Colors.transparent,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: _currentView == 1 ? [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 4,
                                  ),
                                ] : null,
                              ),
                              child: Center(
                                child: Text(
                                  'Categories',
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w500,
                                    color: _currentView == 1 ? Color.fromRGBO(52, 119, 216, 1) : Colors.grey[600],
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
    if (transactions.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.receipt_long_rounded,
              size: screenWidth * 0.2,
              color: Colors.grey[300],
            ),
            SizedBox(height: screenWidth * 0.04),
            Text(
              'No transactions this month',
              style: GoogleFonts.poppins(
                color: Colors.grey[400],
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
                      color: Colors.grey[700],
                    ),
                  ),
                  Text(
                    '${dayCashflow >= 0 ? '+' : ''}P ${dayCashflow.toStringAsFixed(0)}',
                    style: GoogleFonts.poppins(
                      fontSize: screenWidth * 0.038,
                      fontWeight: FontWeight.w600,
                      color: dayCashflow >= 0 ? Color.fromRGBO(34, 139, 34, 1) : Colors.red[400],
                    ),
                  ),
                ],
              ),
            ),
            // Transactions
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
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

                  return Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.04,
                      vertical: screenWidth * 0.035,
                    ),
                    decoration: BoxDecoration(
                      border: isLast ? null : Border(
                        bottom: BorderSide(color: Colors.grey[100]!, width: 1),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(screenWidth * 0.025),
                          decoration: BoxDecoration(
                            color: _getCategoryColor(t['category']).withOpacity(0.15),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            _getCategoryIcon(t['category']),
                            size: screenWidth * 0.055,
                            color: _getCategoryColor(t['category']),
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
                                ),
                              ),
                              Text(
                                t['type'],
                                style: GoogleFonts.poppins(
                                  fontSize: screenWidth * 0.03,
                                  color: Colors.grey[500],
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
                            color: t['isIncome'] == true ? Color.fromRGBO(34, 139, 34, 1) : Colors.red[400],
                          ),
                        ),
                      ],
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
              color: Colors.white,
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
                            color: _getCategoryColor(entry.key),
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
                            color: _getCategoryColor(entry.key),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        SizedBox(width: screenWidth * 0.015),
                        Text(
                          entry.key,
                          style: GoogleFonts.poppins(
                            fontSize: screenWidth * 0.028,
                            color: Colors.grey[600],
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
                color: Colors.white,
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
                      color: _getCategoryColor(entry.key).withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      _getCategoryIcon(entry.key),
                      size: screenWidth * 0.06,
                      color: _getCategoryColor(entry.key),
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
                          ),
                        ),
                        SizedBox(height: screenWidth * 0.015),
                        // Progress bar
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: percentage / 100,
                            backgroundColor: Colors.grey[200],
                            valueColor: AlwaysStoppedAnimation<Color>(_getCategoryColor(entry.key)),
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
                        ),
                      ),
                      Text(
                        '${percentage.toStringAsFixed(1)}%',
                        style: GoogleFonts.poppins(
                          fontSize: screenWidth * 0.03,
                          color: Colors.grey[500],
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
