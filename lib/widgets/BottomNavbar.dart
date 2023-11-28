import 'package:flutter/material.dart';

class BottomNavbar extends StatelessWidget {
  const BottomNavbar({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      //bottom navigation bar on scaffold
      color: const Color.fromRGBO(233, 233, 233, 1),
      //shape of notch
      notchMargin: 5,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(
                  Icons.history,
                  color: Colors.black,
                ),
<<<<<<< HEAD
<<<<<<< HEAD
=======

>>>>>>> f771542 (merge conflict resolved)
=======

>>>>>>> 825662952b6b326e129fd05e42c4264565b4bbcb
                onPressed: () {
                  Navigator.pushNamed(context, '/history');
                },
              ),
            
            ],
          ),
          IconButton(
            icon: Icon(
              Icons.settings,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.pushNamed(context, '/settings');
            },
          ),
        ],
      ),
    );
  }
}
