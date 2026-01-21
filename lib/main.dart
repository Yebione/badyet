import 'package:badyet/DatesBox.dart';
import 'package:badyet/ExpenseItemClass.dart';
import 'package:badyet/ExpenseTodayHistoryBox.dart';
import 'package:badyet/screens/History.dart';
import 'package:badyet/screens/HistoryScaf.dart';
import 'package:badyet/screens/home.dart';
import 'package:badyet/screens/CalculatorExpense.dart';
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

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  static _MyAppState? of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>();

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isDarkMode = false;

  @override
  void initState() {
    super.initState();
    _isDarkMode = Hive.box('Budget').get('isDarkMode', defaultValue: false);
  }

  bool get isDarkMode => _isDarkMode;

  void toggleDarkMode(bool value) {
    setState(() {
      _isDarkMode = value;
      Hive.box('Budget').put('isDarkMode', value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Badyet',
      routes: {
        '/settings': (BuildContext ctx) => SettingsPage(),
        '/about': (BuildContext ctx) => AboutPage(),
        '/history': (BuildContext ctx) => HistoryPage(),
        '/historytemp': (BuildContext ctx) => LatestHistory(),
        '/analytics': (BuildContext ctx) => LatestHistory(),
        '/calculator': (BuildContext ctx) => CalculatorExpensePage(),
      },
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.white,
        textTheme: GoogleFonts.poppinsTextTheme(
          ThemeData.light().textTheme,
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Color(0xFF121212),
        textTheme: GoogleFonts.poppinsTextTheme(
          ThemeData.dark().textTheme,
        ),
      ),
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      debugShowCheckedModeBanner: false,
      home: const badyetHome(),
    );
  }
}
