// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'savings_debt_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SavingsGoalModelAdapter extends TypeAdapter<SavingsGoalModel> {
  @override
  final int typeId = 6;

  @override
  SavingsGoalModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SavingsGoalModel(
      id: fields[0] as String,
      userId: fields[1] as String,
      nama: fields[2] as String,
      deskripsi: fields[3] as String?,
      jumlahTarget: fields[4] as double,
      terkumpul: fields[5] as double,
      icon: fields[6] as String,
      warna: fields[7] as String,
      tanggalTarget: fields[8] as DateTime?,
      selesai: fields[9] as bool,
      dibuatPada: fields[10] as DateTime?,
      diperbaruiPada: fields[11] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, SavingsGoalModel obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.nama)
      ..writeByte(3)
      ..write(obj.deskripsi)
      ..writeByte(4)
      ..write(obj.jumlahTarget)
      ..writeByte(5)
      ..write(obj.terkumpul)
      ..writeByte(6)
      ..write(obj.icon)
      ..writeByte(7)
      ..write(obj.warna)
      ..writeByte(8)
      ..write(obj.tanggalTarget)
      ..writeByte(9)
      ..write(obj.selesai)
      ..writeByte(10)
      ..write(obj.dibuatPada)
      ..writeByte(11)
      ..write(obj.diperbaruiPada);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SavingsGoalModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DebtModelAdapter extends TypeAdapter<DebtModel> {
  @override
  final int typeId = 7;

  @override
  DebtModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DebtModel(
      id: fields[0] as String,
      userId: fields[1] as String,
      nama: fields[2] as String,
      jenis: fields[3] as String,
      jumlahAwal: fields[4] as double,
      sisaHutang: fields[5] as double,
      bungaPersen: fields[6] as double,
      tanggalJatuhTempo: fields[7] as DateTime?,
      lunas: fields[8] as bool,
      dibuatPada: fields[9] as DateTime?,
      diperbaruiPada: fields[10] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, DebtModel obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.nama)
      ..writeByte(3)
      ..write(obj.jenis)
      ..writeByte(4)
      ..write(obj.jumlahAwal)
      ..writeByte(5)
      ..write(obj.sisaHutang)
      ..writeByte(6)
      ..write(obj.bungaPersen)
      ..writeByte(7)
      ..write(obj.tanggalJatuhTempo)
      ..writeByte(8)
      ..write(obj.lunas)
      ..writeByte(9)
      ..write(obj.dibuatPada)
      ..writeByte(10)
      ..write(obj.diperbaruiPada);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DebtModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
