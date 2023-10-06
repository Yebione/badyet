import 'package:badyet/screens/header.dart';
import 'package:flutter/material.dart';
import 'RemBudget.dart';

class badyetHome extends StatelessWidget {
  const badyetHome({super.key});

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          //Floating action button on Scaffold
          onPressed: () {
            //code to execute on button press
          },
          backgroundColor: Colors.transparent,
          shape: CircleBorder(eccentricity: 0.0),
          child: Container(
            width: 80,
            height: 80,
            child: Icon(
              Icons.add,
              size: 40,
            ),
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(colors: [
                  const Color.fromRGBO(53, 122, 213, 1),
                  const Color.fromRGBO(81, 218, 96, 1)
                ])),
          ),
          //icon inside button
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: BottomAppBar(
          //bottom navigation bar on scaffold
          color: const Color.fromRGBO(233, 233, 233, 1),
          //shape of notch
          notchMargin:
              5, //notche margin between floating button and bottom appbar
          child: Row(
            //children inside bottom appbar
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.history,
                  color: Colors.black,
                ),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(
                  Icons.settings,
                  color: Colors.black,
                ),
                onPressed: () {},
              ),
            ],
          ),
        ),
        body: Center(
          child: Container(
            margin: EdgeInsets.only(top: 100.0), // Adjust the value as needed
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Header(),
                // Other widgets in your Column
                RemBudget(),
              ],
            ),
          ),
        ));
  }
}
