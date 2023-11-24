import 'package:flutter/material.dart';
import 'package:badyet/screens/About.dart';


class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}
class _SettingsPageState extends State<SettingsPage> {
  bool isDarkModeEnabled = false;
  String selectedCurrency = 'USD';
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        
      ),
      body: ListView(
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
          buildSettingItem(
            icon: Icons.attach_money,
            name: 'Currency',
            button: DropdownButton<String>(
              value: selectedCurrency,
              onChanged: (String? newValue) {
                setState(() {
                  selectedCurrency = newValue!;
                });
                //sdnjasnansjs para mag ilis karensi
              },
              items: <String>['USD', 'EUR', 'GBP', 'JPY', 'PHP']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
          buildSettingItem(
            icon: Icons.info,
            name: 'About',
            button: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AboutPage()),
                );
              },
              child: Icon(Icons.arrow_forward),
            ),
          ),
        ],
      ),
    );
  }
}
Widget buildSettingItem({required IconData icon, required String name, required Widget button}) {
    return ListTile(
      leading: Icon(icon),
      title: Text(name),
      trailing: button,
    );
  }
