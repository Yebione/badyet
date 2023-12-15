import 'package:badyet/DatesBox.dart';
import 'package:badyet/ExpenseItemClass.dart';
import 'package:badyet/ExpenseTodayHistoryBox.dart';
import 'package:badyet/screens/Help.dart';
import 'package:badyet/screens/History.dart';
import 'package:badyet/screens/HistoryScaf.dart';
import 'package:badyet/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:badyet/screens/Settings.dart';
import 'package:badyet/screens/About.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'ExpensesTodayBox.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('Budget');
  Hive.registerAdapter(ExpenseItemClassAdapter());
  expenseTodayBox = await Hive.openBox<ExpenseItemClass>("ExpensesToday");
  expenseTodayHistoryBox =
      await Hive.openBox<ExpenseItemClass>("ExpensesTodayHistory");
  datesBox = await Hive.openBox<String>("Dates");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Badyet',
      routes: {
        '/settings': (BuildContext ctx) => SettingsPage(),
        '/about': (BuildContext ctx) => AboutPage(),
        '/history': (BuildContext ctx) => HistoryPage(),
        '/historytemp': (BuildContext ctx) => LatestHistory(),
        '/help': (BuildContext ctx) => Help(),
      },
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: const badyetHome(),
    );
  }
}
