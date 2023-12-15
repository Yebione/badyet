import 'package:hive_flutter/hive_flutter.dart';

part 'ExpenseItemClass.g.dart';

@HiveType(typeId: 1)
class ExpenseItemClass {
  @HiveField(0)
  String date = "";
  @HiveField(1)
  String category = "";
  @HiveField(2)
  String type = "";
  @HiveField(3)
  String price = "0";

  ExpenseItemClass(this.date, this.category, this.type, this.price);
  ExpenseItemClass.empty() {
    date = "";
    category = "";
    type = "";
    price = "0";
  }
}
