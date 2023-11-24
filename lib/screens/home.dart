import 'package:badyet/screens/AiTips.dart';
import 'package:badyet/screens/ExpenseItem.dart';
import 'package:badyet/screens/Header.dart';
import 'package:badyet/screens/HomeExpenseView.dart';
import 'package:badyet/screens/RemBudget.dart';
import 'package:badyet/screens/AddButton.dart';
import 'package:badyet/screens/BottomNavbar.dart';
import 'package:flutter/material.dart';

class badyetHome extends StatelessWidget {
  const badyetHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            margin: EdgeInsets.only(top: 30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Header(),
                RemBudget(),
                Container(
                  margin: EdgeInsets.only(right: 30, left: 30, bottom: 20),
                  child: Column(
                    children: [
                      Container(
                        width: 365,
                        height: 10,
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          child: LinearProgressIndicator(
                            value: 0.7,
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Color(0xFF3478D7)),
                            backgroundColor: Color(0xffD6D6D6),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Php. 2,250.00",
                            style: TextStyle(
                                fontSize: 12, fontStyle: FontStyle.italic),
                          ),
                          Text(
                            "Php. 3,000.00",
                            style: TextStyle(
                                fontSize: 12, fontStyle: FontStyle.italic),
                          )
                        ],
                      )
                    ],
                  ),
                ),
                AiTips(),
                ExpenseContainer(),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: AddExpenseButton(),
      // For Add Expense Button
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomNavbar(), // For Bottom Navigation
    );
  }
}
