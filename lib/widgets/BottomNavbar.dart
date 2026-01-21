import 'package:flutter/material.dart';

class BottomNavbar extends StatelessWidget {
  const BottomNavbar({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BottomAppBar(
      padding: EdgeInsets.only(
        bottom: screenWidth * 0.02,
      ),
      height: screenWidth / 5.8,
      color: isDark ? Color(0xFF1E1E1E) : Colors.white,
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
                color: isDark ? Colors.grey[400] : Colors.grey[700],
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
                color: isDark ? Colors.grey[400] : Colors.grey[700],
              )),
        ],
      ),
    );
  }
}
