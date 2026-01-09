import 'package:equatable/equatable.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'transaction_model.g.dart';

/// Tipe transaksi
@HiveType(typeId: 3)
enum TransactionType {
  @HiveField(0)
  income,
  @HiveField(1)
  expense,
  @HiveField(2)
  transfer,
}

/// Model transaksi untuk Supabase
@HiveType(typeId: 0)
class TransactionModel extends Equatable {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String userId;
  @HiveField(2)
  final String walletId;
  @HiveField(3)
  final String? categoryId;
  @HiveField(4)
  final String title;
  @HiveField(5)
  final String? description;
  @HiveField(6)
  final double amount;
  @HiveField(7)
  final TransactionType type;
  @HiveField(8)
  final String? targetWalletId;
  @HiveField(9)
  final String? recurringId;
  @HiveField(10)
  final DateTime transactionDate;
  @HiveField(11)
  final DateTime? createdAt;
  @HiveField(12)
  final DateTime? updatedAt;

  const TransactionModel({
    required this.id,
    required this.userId,
    required this.walletId,
    this.categoryId,
    required this.title,
    this.description,
    required this.amount,
    required this.type,
    this.targetWalletId,
    this.recurringId,
    required this.transactionDate,
    this.createdAt,
    this.updatedAt,
  });

  /// Buat dari JSON (response Supabase - Indonesia)
  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'] as String,
      userId: json['id_pengguna'] as String,
      walletId: json['id_dompet'] as String,
      categoryId: json['id_kategori'] as String?,
      title: json['judul'] as String,
      description: json['deskripsi'] as String?,
      amount: (json['jumlah'] as num).toDouble(),
      type: _parseType(json['tipe'] as String),
      targetWalletId: json['id_dompet_tujuan'] as String?,
      recurringId: json['id_transaksi_berulang'] as String?,
      transactionDate: DateTime.parse(json['tanggal_transaksi'] as String),
      createdAt: json['dibuat_pada'] != null
          ? DateTime.parse(json['dibuat_pada'] as String)
          : null,
      updatedAt: json['diperbarui_pada'] != null
          ? DateTime.parse(json['diperbarui_pada'] as String)
          : null,
    );
  }

  /// Parse tipe dari nilai database Indonesia
  static TransactionType _parseType(String value) {
    switch (value) {
      case 'pemasukan':
        return TransactionType.income;
      case 'pengeluaran':
        return TransactionType.expense;
      case 'transfer':
        return TransactionType.transfer;
      default:
        return TransactionType.expense;
    }
  }

  /// Konversi tipe ke nilai database Indonesia
  String _typeToDb() {
    switch (type) {
      case TransactionType.income:
        return 'pemasukan';
      case TransactionType.expense:
        return 'pengeluaran';
      case TransactionType.transfer:
        return 'transfer';
    }
  }

  /// Konversi ke JSON untuk Supabase (nama kolom Indonesia)
  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{
      'id_pengguna': userId,
      'id_dompet': walletId,
      'id_kategori': categoryId,
      'judul': title,
      'deskripsi': description,
      'jumlah': amount,
      'tipe': _typeToDb(),
      'id_dompet_tujuan': targetWalletId,
      'id_transaksi_berulang': recurringId,
      'tanggal_transaksi': transactionDate.toIso8601String().split('T').first,
    };

    // Only include id if it's not empty (for updates)
    if (id.isNotEmpty) {
      json['id'] = id;
    }

    return json;
  }

  /// Copy dengan perubahan
  TransactionModel copyWith({
    String? id,
    String? userId,
    String? walletId,
    String? categoryId,
    String? title,
    String? description,
    double? amount,
    TransactionType? type,
    String? targetWalletId,
    String? recurringId,
    DateTime? transactionDate,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return TransactionModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      walletId: walletId ?? this.walletId,
      categoryId: categoryId ?? this.categoryId,
      title: title ?? this.title,
      description: description ?? this.description,
      amount: amount ?? this.amount,
      type: type ?? this.type,
      targetWalletId: targetWalletId ?? this.targetWalletId,
      recurringId: recurringId ?? this.recurringId,
      transactionDate: transactionDate ?? this.transactionDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    userId,
    walletId,
    categoryId,
    title,
    description,
    amount,
    type,
    targetWalletId,
    recurringId,
    transactionDate,
    createdAt,
    updatedAt,
  ];
}
