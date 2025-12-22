import 'package:equatable/equatable.dart';

/// Model respon kuesioner
class QuestionnaireModel extends Equatable {
  final String? id;
  final String? userId;

  // Saldo awal dompet
  final double initialBelanja;
  final double initialTabungan;
  final double initialDarurat;

  // Informasi hutang
  final bool hasDebt;
  final double? debtAmount;
  final String? debtType;

  final DateTime? completedAt;

  const QuestionnaireModel({
    this.id,
    this.userId,
    this.initialBelanja = 0,
    this.initialTabungan = 0,
    this.initialDarurat = 0,
    this.hasDebt = false,
    this.debtAmount,
    this.debtType,
    this.completedAt,
  });

  /// Buat dari JSON (response Supabase - Indonesia)
  factory QuestionnaireModel.fromJson(Map<String, dynamic> json) {
    return QuestionnaireModel(
      id: json['id'] as String?,
      userId: json['id_pengguna'] as String?,
      initialBelanja: (json['saldo_awal_belanja'] as num?)?.toDouble() ?? 0,
      initialTabungan: (json['saldo_awal_tabungan'] as num?)?.toDouble() ?? 0,
      initialDarurat: (json['saldo_awal_darurat'] as num?)?.toDouble() ?? 0,
      hasDebt: json['punya_hutang'] as bool? ?? false,
      debtAmount: (json['jumlah_hutang'] as num?)?.toDouble(),
      debtType: json['tipe_hutang'] as String?,
      completedAt: json['selesai_pada'] != null
          ? DateTime.parse(json['selesai_pada'] as String)
          : null,
    );
  }

  /// Konversi ke JSON untuk Supabase (nama kolom Indonesia)
  Map<String, dynamic> toJson() {
    return {
      'saldo_awal_belanja': initialBelanja,
      'saldo_awal_tabungan': initialTabungan,
      'saldo_awal_darurat': initialDarurat,
      'punya_hutang': hasDebt,
      'jumlah_hutang': debtAmount,
      'tipe_hutang': debtType,
      'selesai_pada': DateTime.now().toIso8601String(),
    };
  }

  /// Total saldo awal
  double get totalInitialBalance =>
      initialBelanja + initialTabungan + initialDarurat;

  /// Copy dengan perubahan
  QuestionnaireModel copyWith({
    String? id,
    String? userId,
    double? initialBelanja,
    double? initialTabungan,
    double? initialDarurat,
    bool? hasDebt,
    double? debtAmount,
    String? debtType,
    DateTime? completedAt,
  }) {
    return QuestionnaireModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      initialBelanja: initialBelanja ?? this.initialBelanja,
      initialTabungan: initialTabungan ?? this.initialTabungan,
      initialDarurat: initialDarurat ?? this.initialDarurat,
      hasDebt: hasDebt ?? this.hasDebt,
      debtAmount: debtAmount ?? this.debtAmount,
      debtType: debtType ?? this.debtType,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    userId,
    initialBelanja,
    initialTabungan,
    initialDarurat,
    hasDebt,
    debtAmount,
    debtType,
    completedAt,
  ];
}
