// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_summary.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DashboardSummaryAdapter extends TypeAdapter<DashboardSummary> {
  @override
  final int typeId = 5;

  @override
  DashboardSummary read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DashboardSummary(
      totalBalance: fields[0] as double,
      weeklyExpense: fields[1] as double,
      monthlyBudget: fields[2] as double,
      monthlySpent: fields[3] as double,
    );
  }

  @override
  void write(BinaryWriter writer, DashboardSummary obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.totalBalance)
      ..writeByte(1)
      ..write(obj.weeklyExpense)
      ..writeByte(2)
      ..write(obj.monthlyBudget)
      ..writeByte(3)
      ..write(obj.monthlySpent);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DashboardSummaryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
