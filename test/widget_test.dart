// import 'package:badyet/ExpenseHistoryBox.dart';
// import 'package:badyet/ExpenseHistoryClass.dart';
// import 'package:badyet/ExpenseItemClass.dart';
// import 'package:badyet/ExpensesTodayBox.dart';
// import 'package:badyet/screens/History.dart';
// import 'package:badyet/screens/HistoryScaf.dart';
// import 'package:badyet/screens/home.dart';
// import 'package:flutter/material.dart';
// import 'package:badyet/screens/Settings.dart';
// import 'package:badyet/screens/About.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:hive_flutter/hive_flutter.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Hive.initFlutter();
//   await Hive.openBox('Budget');
//   Hive.registerAdapter(ExpenseItemClassAdapter());
//   Hive.registerAdapter(ExpenseHistoryClassAdapter());
//   expenseTodayBox = await Hive.openBox<ExpenseItemClass>("ExpensesToday");
//   expenseHistoryBox = await Hive.openBox<ExpenseHistoryClass>("ExpenseHistory");
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Badyet',
//       routes: {
//         '/settings': (BuildContext ctx) => const SettingsPage(),
//         '/about': (BuildContext ctx) => const AboutPage(),
//         '/history': (BuildContext ctx) => const HistoryPage(),
//         '/historytemp': (BuildContext ctx) => const HistoryPage(),
//       },
//       theme: ThemeData(
//         textTheme: GoogleFonts.poppinsTextTheme(
//           Theme.of(context).textTheme,
//         ),
//       ),
//       debugShowCheckedModeBanner: false,
//       home: const badyetHome(),
//     );
//   }
// }
// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:badyet/main.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}
