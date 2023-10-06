import 'package:badyet/screens/Header.dart';
import 'package:badyet/screens/RemBudget.dart';
import 'package:badyet/screens/AddButton.dart';
import 'package:badyet/screens/BottomNavbar.dart';
import 'package:flutter/material.dart';

class badyetHome extends StatelessWidget {
  const badyetHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          margin: EdgeInsets.only(top: 100.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Header(), //for Header 
              RemBudget(),
            ],
          ),
        ),
      ),
     
      floatingActionButton: AddExpenseButton(), // For Add Expense Button
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomNavbar(), // For Bottom Navigation

    );
  }
}
