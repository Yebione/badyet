import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool isDarkModeEnabled = false;

  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
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
                    color: Colors.black,
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
                      color: Colors.black,
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
                    button: Switch(
                      value: isDarkModeEnabled,
                      onChanged: (value) {
                        setState(() {
                          isDarkModeEnabled = value;
                        });
                        // snasndfsanfjan para mag itom
                      },
                    ),
                  ),
                  SizedBox(
                    height: screenWidth * 0.03,
                  ),
                  buildSettingItem(
                      icon: Icons.info,
                      name: 'About',
                      button: IconButton(
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              '/about',
                            );
                          },
                          icon: Icon(Icons.arrow_forward))),
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
    {required IconData icon, required String name, required Widget button}) {
  return ListTile(
    leading: Icon(icon),
    title: Text(name),
    trailing: button,
  );
}
