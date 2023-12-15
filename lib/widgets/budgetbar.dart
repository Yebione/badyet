import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';

class budgetBar extends StatefulWidget {
  const budgetBar({super.key});

  @override
  State<budgetBar> createState() => _budgetBar();
}

class _budgetBar extends State<budgetBar> {
  double getTotalAddedBudget() {
    return Hive.box('Budget').get("TotalBudgetAdded", defaultValue: 0.0);
  }

  double getExpensesWeek() {
    return Hive.box('Budget').get("TotalExpensesWeek", defaultValue: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box>(
        valueListenable: Hive.box('Budget').listenable(),
        builder: (context, box, _) {
          double bar = getExpensesWeek();
          if (bar == 0) {
            bar = 0;
          } else {
            bar = getExpensesWeek() / getTotalAddedBudget();
          }

          return Column(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 10,
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  child: LinearProgressIndicator(
                    value: bar,
                    valueColor:
                        const AlwaysStoppedAnimation<Color>(Color(0xFF3478D7)),
                    backgroundColor: const Color(0xffD6D6D6),
                  ),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "PHP: ${getExpensesWeek().round().toString()}",
                    style: GoogleFonts.poppins(
                        fontSize: 12, fontStyle: FontStyle.italic),
                  ),
                  Text(
                    "PHP: ${getTotalAddedBudget().round().toString()}",
                    style: GoogleFonts.poppins(
                        fontSize: 12, fontStyle: FontStyle.italic),
                  )
                ],
              )
            ],
          );
        });
  }
}
