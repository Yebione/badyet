import 'package:flutter/material.dart';

class BottomNavbar extends StatelessWidget {
  const BottomNavbar({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return BottomAppBar(
      padding: EdgeInsets.only(
        bottom: screenWidth * 0.02,
      ),
      height: screenWidth / 5.8,
      color: Colors.white54,
      shape: const CircularNotchedRectangle(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  '/analytics',
                );
              },
              icon: Icon(
                Icons.analytics_outlined,
                size: screenWidth * 0.07,
              )),
          SizedBox(
            width: screenWidth / 3.5,
          ),
          IconButton(
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  '/settings',
                );
              },
              icon: Icon(
                Icons.settings,
                size: screenWidth * 0.07,
              )),
        ],
      ),
    );
  }
}
