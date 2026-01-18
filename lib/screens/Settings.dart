import 'package:badyet/main.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late bool isDarkModeEnabled;

  @override
  void initState() {
    super.initState();
    isDarkModeEnabled = Hive.box('Budget').get('isDarkMode', defaultValue: false);
  }

  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(
          left: screenWidth * 0.07,
          right: screenWidth * 0.07,
          top: 55,
        ),
        child: Column(
          children: [
            Row(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                ),
                SizedBox(
                  width: 15,
                ),
                Text(
                  "Settings",
                  style: GoogleFonts.poppins(
                      color: isDark ? Colors.white : Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      decoration: TextDecoration.none),
                ),
              ],
            ),
            SizedBox(height: screenWidth * 0.18),
            Center(
              child: Container(
                height: screenWidth * 0.25,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/badyet.png'),
                  ),
                ),
              ),
            ),
            SizedBox(height: screenWidth * 0.05),
            Center(
              child: Text(
                "Version 2.0.0",
                style: GoogleFonts.poppins(fontSize: screenWidth * 0.05),
              ),
            ),
            SizedBox(height: screenWidth * 0.15),
            Expanded(
              child: ListView(
                children: [
                  buildSettingItem(
                    icon: Icons.brightness_4,
                    name: 'Dark Mode',
                    isDark: isDark,
                    button: Switch(
                      value: isDarkModeEnabled,
                      activeColor: Color.fromRGBO(52, 119, 216, 1),
                      onChanged: (value) {
                        setState(() {
                          isDarkModeEnabled = value;
                        });
                        MyApp.of(context)?.toggleDarkMode(value);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget buildSettingItem(
    {required IconData icon, required String name, required Widget button, required bool isDark}) {
  return ListTile(
    leading: Icon(icon, color: isDark ? Colors.white70 : Colors.black87),
    title: Text(
      name,
      style: TextStyle(color: isDark ? Colors.white : Colors.black),
    ),
    trailing: button,
  );
}
