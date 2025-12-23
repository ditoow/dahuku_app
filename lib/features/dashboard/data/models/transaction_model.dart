import 'package:equatable/equatable.dart';

/// Tipe transaksi
enum TransactionType { income, expense, transfer }

/// Model transaksi untuk Supabase
class TransactionModel extends Equatable {
  final String id;
  final String userId;
  final String walletId;
  final String? categoryId;
  final String title;
  final String? description;
  final double amount;
  final TransactionType type;
  final String? targetWalletId;
  final String? recurringId;
  final DateTime transactionDate;
  final DateTime? createdAt;
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
