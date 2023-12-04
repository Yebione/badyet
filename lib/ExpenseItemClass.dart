import 'package:hive_flutter/hive_flutter.dart';

part 'ExpenseItemClass.g.dart';

@HiveType(typeId: 1)
class ExpenseItemClass {
  @HiveField(0)
  String category = "";
  @HiveField(1)
  String type = "";
  @HiveField(2)
  String price = "0";

  ExpenseItemClass(this.category, this.type, this.price);
  ExpenseItemClass.empty() {
    category = "";
    type = "";
    price = "0";
  }
}
