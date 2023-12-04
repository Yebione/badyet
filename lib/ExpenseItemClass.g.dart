// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ExpenseItemClass.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ExpenseItemClassAdapter extends TypeAdapter<ExpenseItemClass> {
  @override
  final int typeId = 1;

  @override
  ExpenseItemClass read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ExpenseItemClass(
      fields[0] as String,
      fields[1] as String,
      fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ExpenseItemClass obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.category)
      ..writeByte(1)
      ..write(obj.type)
      ..writeByte(2)
      ..write(obj.price);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExpenseItemClassAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
