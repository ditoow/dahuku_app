import 'package:equatable/equatable.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'savings_debt_model.g.dart';

/// Model untuk Target Tabungan (Savings Goal)
@HiveType(typeId: 6)
class SavingsGoalModel extends Equatable {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String userId;
  @HiveField(2)
  final String nama;
  @HiveField(3)
  final String? deskripsi;
  @HiveField(4)
  final double jumlahTarget;
  @HiveField(5)
  final double terkumpul;
  @HiveField(6)
  final String icon;
  @HiveField(7)
  final String warna;
  @HiveField(8)
  final DateTime? tanggalTarget;
  @HiveField(9)
  final bool selesai;
  @HiveField(10)
  final DateTime? dibuatPada;
  @HiveField(11)
  final DateTime? diperbaruiPada;

  const SavingsGoalModel({
    required this.id,
    required this.userId,
    required this.nama,
    this.deskripsi,
    required this.jumlahTarget,
    this.terkumpul = 0,
    this.icon = 'savings',
    this.warna = '#10B981',
    this.tanggalTarget,
    this.selesai = false,
    this.dibuatPada,
    this.diperbaruiPada,
  });

  /// Progress percentage (0.0 - 1.0)
  double get progress =>
      jumlahTarget > 0 ? (terkumpul / jumlahTarget).clamp(0.0, 1.0) : 0.0;

  /// Progress percentage as int (0 - 100)
  int get progressPercent => (progress * 100).round();

  /// Remaining amount to reach goal
  double get remaining => (jumlahTarget - terkumpul).clamp(0, double.infinity);

  factory SavingsGoalModel.fromJson(Map<String, dynamic> json) {
    return SavingsGoalModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      nama: json['nama'] as String,
      deskripsi: json['deskripsi'] as String?,
      jumlahTarget: (json['jumlah_target'] as num).toDouble(),
      terkumpul: (json['terkumpul'] as num?)?.toDouble() ?? 0,
      icon: json['icon'] as String? ?? 'savings',
      warna: json['warna'] as String? ?? '#10B981',
      tanggalTarget: json['tanggal_target'] != null
          ? DateTime.parse(json['tanggal_target'] as String)
          : null,
      selesai: json['selesai'] as bool? ?? false,
      dibuatPada: json['dibuat_pada'] != null
          ? DateTime.parse(json['dibuat_pada'] as String)
          : null,
      diperbaruiPada: json['diperbarui_pada'] != null
          ? DateTime.parse(json['diperbarui_pada'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'nama': nama,
      'deskripsi': deskripsi,
      'jumlah_target': jumlahTarget,
      'terkumpul': terkumpul,
      'icon': icon,
      'warna': warna,
      'tanggal_target': tanggalTarget?.toIso8601String(),
      'selesai': selesai,
    };
  }

  SavingsGoalModel copyWith({double? terkumpul, bool? selesai}) {
    return SavingsGoalModel(
      id: id,
      userId: userId,
      nama: nama,
      deskripsi: deskripsi,
      jumlahTarget: jumlahTarget,
      terkumpul: terkumpul ?? this.terkumpul,
      icon: icon,
      warna: warna,
      tanggalTarget: tanggalTarget,
      selesai: selesai ?? this.selesai,
      dibuatPada: dibuatPada,
      diperbaruiPada: DateTime.now(),
    );
  }

  @override
  List<Object?> get props => [id, nama, jumlahTarget, terkumpul, selesai];
}

/// Model untuk Hutang (Debt)
@HiveType(typeId: 7)
class DebtModel extends Equatable {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String userId;
  @HiveField(2)
  final String nama;
  @HiveField(3)
  final String jenis; // keluarga, rentenir, koperasi, bank, paylater
  @HiveField(4)
  final double jumlahAwal;
  @HiveField(5)
  final double sisaHutang;
  @HiveField(6)
  final double bungaPersen;
  @HiveField(7)
  final DateTime? tanggalJatuhTempo;
  @HiveField(8)
  final bool lunas;
  @HiveField(9)
  final DateTime? dibuatPada;
  @HiveField(10)
  final DateTime? diperbaruiPada;

  const DebtModel({
    required this.id,
    required this.userId,
    required this.nama,
    this.jenis = 'keluarga',
    required this.jumlahAwal,
    required this.sisaHutang,
    this.bungaPersen = 0,
    this.tanggalJatuhTempo,
    this.lunas = false,
    this.dibuatPada,
    this.diperbaruiPada,
  });

  /// Paid percentage (0.0 - 1.0)
  double get paidProgress => jumlahAwal > 0
      ? ((jumlahAwal - sisaHutang) / jumlahAwal).clamp(0.0, 1.0)
      : 0.0;

  /// Total paid amount
  double get totalPaid => jumlahAwal - sisaHutang;

  factory DebtModel.fromJson(Map<String, dynamic> json) {
    return DebtModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      nama: json['nama'] as String,
      jenis: json['jenis'] as String? ?? 'keluarga',
      jumlahAwal: (json['jumlah_awal'] as num).toDouble(),
      sisaHutang: (json['sisa_hutang'] as num).toDouble(),
      bungaPersen: (json['bunga_persen'] as num?)?.toDouble() ?? 0,
      tanggalJatuhTempo: json['tanggal_jatuh_tempo'] != null
          ? DateTime.parse(json['tanggal_jatuh_tempo'] as String)
          : null,
      lunas: json['lunas'] as bool? ?? false,
      dibuatPada: json['dibuat_pada'] != null
          ? DateTime.parse(json['dibuat_pada'] as String)
          : null,
      diperbaruiPada: json['diperbarui_pada'] != null
          ? DateTime.parse(json['diperbarui_pada'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'nama': nama,
      'jenis': jenis,
      'jumlah_awal': jumlahAwal,
      'sisa_hutang': sisaHutang,
      'bunga_persen': bungaPersen,
      'tanggal_jatuh_tempo': tanggalJatuhTempo?.toIso8601String(),
      'lunas': lunas,
    };
  }

  DebtModel copyWith({double? sisaHutang, bool? lunas}) {
    return DebtModel(
      id: id,
      userId: userId,
      nama: nama,
      jenis: jenis,
      jumlahAwal: jumlahAwal,
      sisaHutang: sisaHutang ?? this.sisaHutang,
      bungaPersen: bungaPersen,
      tanggalJatuhTempo: tanggalJatuhTempo,
      lunas: lunas ?? this.lunas,
      dibuatPada: dibuatPada,
      diperbaruiPada: DateTime.now(),
    );
  }

  @override
  List<Object?> get props => [id, nama, jumlahAwal, sisaHutang, lunas];
}

/// Model untuk Setor Tabungan (Savings Deposit)
class SavingsDepositModel extends Equatable {
  final String id;
  final String userId;
  final String targetId;
  final double jumlah;
  final String? catatan;
  final DateTime? dibuatPada;

  const SavingsDepositModel({
    required this.id,
    required this.userId,
    required this.targetId,
    required this.jumlah,
    this.catatan,
    this.dibuatPada,
  });

  factory SavingsDepositModel.fromJson(Map<String, dynamic> json) {
    return SavingsDepositModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      targetId: json['target_id'] as String,
      jumlah: (json['jumlah'] as num).toDouble(),
      catatan: json['catatan'] as String?,
      dibuatPada: json['dibuat_pada'] != null
          ? DateTime.parse(json['dibuat_pada'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'target_id': targetId,
      'jumlah': jumlah,
      'catatan': catatan,
    };
  }

  @override
  List<Object?> get props => [id, targetId, jumlah];
}

/// Model untuk Bayar Hutang (Debt Payment)
class DebtPaymentModel extends Equatable {
  final String id;
  final String userId;
  final String hutangId;
  final double jumlah;
  final String? catatan;
  final DateTime? dibuatPada;

  const DebtPaymentModel({
    required this.id,
    required this.userId,
    required this.hutangId,
    required this.jumlah,
    this.catatan,
    this.dibuatPada,
  });

  factory DebtPaymentModel.fromJson(Map<String, dynamic> json) {
    return DebtPaymentModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      hutangId: json['hutang_id'] as String,
      jumlah: (json['jumlah'] as num).toDouble(),
      catatan: json['catatan'] as String?,
      dibuatPada: json['dibuat_pada'] != null
          ? DateTime.parse(json['dibuat_pada'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'hutang_id': hutangId,
      'jumlah': jumlah,
      'catatan': catatan,
    };
  }

  @override
  List<Object?> get props => [id, hutangId, jumlah];
}
