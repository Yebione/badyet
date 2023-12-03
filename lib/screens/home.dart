import 'package:badyet/widgets/AiTips.dart';
import 'package:badyet/widgets/ExpenseItem.dart';
import 'package:badyet/widgets/Header.dart';
import 'package:badyet/widgets/HomeExpenseView.dart';
import 'package:badyet/widgets/RemBudget.dart';
import 'package:badyet/widgets/AddButton.dart';
import 'package:badyet/widgets/BottomNavbar.dart';
import 'package:badyet/widgets/budgetbar.dart';
import 'package:badyet/widgets/noExpense.dart';

import 'package:flutter/material.dart';

class badyetHome extends StatefulWidget {
  const badyetHome({super.key});

  @override
  State<badyetHome> createState() => _badyetHome();
}

class _badyetHome extends State<badyetHome> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double decider = 2;
    return Scaffold(
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
                            top: 50),
                        child: Column(
                          children: [
                            Header(),
                            SizedBox(
                              height: 40,
                            ),
                            RemBudget(),
                            SizedBox(
                              height: 20,
                            ),
                            budgetBar(),
                            decider == 1 ? noExpense() : ExpenseContainer(),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
          floatingActionButtonLocation:FloatingActionButtonLocation.centerDocked,
          floatingActionButton: AddExpenseButton (),
          bottomNavigationBar: BottomNavbar(),
        
        );

  }
}
