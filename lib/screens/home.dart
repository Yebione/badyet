import 'package:badyet/widgets/header.dart';
import 'package:badyet/widgets/HomeExpenseView.dart';
import 'package:badyet/widgets/RemBudget.dart';
import 'package:badyet/widgets/AddButton.dart';
import 'package:badyet/widgets/BottomNavbar.dart';
import 'package:badyet/widgets/noExpense.dart';
import 'package:badyet/widgets/Accounts.dart';
import 'package:badyet/widgets/WelcomeModal.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:flutter/material.dart';

class badyetHome extends StatefulWidget {
  const badyetHome({super.key});

  @override
  State<badyetHome> createState() => _badyetHome();
}

class _badyetHome extends State<badyetHome> {
  Set<int> selectedAccountIndices = {};
  List<Map<String, dynamic>> accountsList = [];
  DateTime? selectedDate;

  void onAccountSelectionChanged(Set<int> selectedIndices, List<Map<String, dynamic>> accounts) {
    setState(() {
      selectedAccountIndices = selectedIndices;
      accountsList = accounts;
    });
  }

  void onDateChanged(DateTime date) {
    setState(() {
      selectedDate = date;
    });
  }

  List<String> getSelectedAccountNames() {
    if (selectedAccountIndices.isEmpty) return [];
    return selectedAccountIndices
        .where((i) => i < accountsList.length)
        .map((i) => accountsList[i]['name'] as String)
        .toList();
  }

  @override
  void initState() {
    super.initState();
    // Check if welcome modal should be shown on first launch
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final box = Hive.box('Budget');
      bool hasSeenWelcome = box.get('hasSeenWelcome', defaultValue: false);
      if (!hasSeenWelcome) {
        WelcomeModal.showWelcomeModal(context);
        box.put('hasSeenWelcome', true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Center(
          child: Builder(
            builder: (BuildContext context) {
              double screenWidth = MediaQuery.of(context).size.width;
              double decider = 2;

              return Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        left: screenWidth * 0.07,
                        right: screenWidth * 0.07,
                        top: 70),
                    child: Column(
                      children: [
                        Header(
                          selectedDate: selectedDate,
                          onDateChanged: onDateChanged,
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        RemBudget(selectedDate: selectedDate),
                        SizedBox(
                          height: 20,
                        ),
                        Accounts(onSelectionChanged: onAccountSelectionChanged),
                        SizedBox(
                          height: 20,
                        ),
                        decider == 1 ? NoExpense() : ExpenseContainer(
                          selectedAccountNames: getSelectedAccountNames(),
                          selectedDate: selectedDate,
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: AddExpenseButton(
        selectedAccount: selectedAccountIndices.length == 1 && accountsList.isNotEmpty
            ? accountsList[selectedAccountIndices.first]['name']
            : null,
        selectedDate: selectedDate,
      ),
      bottomNavigationBar: BottomNavbar(),
    );
  }
}
