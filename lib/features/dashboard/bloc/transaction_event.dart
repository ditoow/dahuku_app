import 'package:equatable/equatable.dart';
import '../data/models/transaction_model.dart';

/// Transaction events
abstract class TransactionEvent extends Equatable {
  const TransactionEvent();

  @override
  List<Object?> get props => [];
}

/// Load transactions with optional filters
class TransactionLoadRequested extends TransactionEvent {
  final int? limit;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? walletId;
  final TransactionType? type;

  const TransactionLoadRequested({
    this.limit,
    this.startDate,
    this.endDate,
    this.walletId,
    this.type,
  });

  @override
  List<Object?> get props => [limit, startDate, endDate, walletId, type];
}

/// Create income transaction
class TransactionCreateIncomeRequested extends TransactionEvent {
  final String walletId;
  final String title;
  final double amount;
  final String? description;
  final String? categoryId;
  final DateTime? date;

  const TransactionCreateIncomeRequested({
    required this.walletId,
    required this.title,
    required this.amount,
    this.description,
    this.categoryId,
    this.date,
  });

  @override
  List<Object?> get props => [
    walletId,
    title,
    amount,
    description,
    categoryId,
    date,
  ];
}

/// Create expense transaction
class TransactionCreateExpenseRequested extends TransactionEvent {
  final String walletId;
  final String title;
  final double amount;
  final String? description;
  final String? categoryId;
  final DateTime? date;

  const TransactionCreateExpenseRequested({
    required this.walletId,
    required this.title,
    required this.amount,
    this.description,
    this.categoryId,
    this.date,
  });

  @override
  List<Object?> get props => [
    walletId,
    title,
    amount,
    description,
    categoryId,
    date,
  ];
}

/// Create transfer transaction
class TransactionCreateTransferRequested extends TransactionEvent {
  final String fromWalletId;
  final String toWalletId;
  final String title;
  final double amount;
  final String? description;
  final DateTime? date;

  const TransactionCreateTransferRequested({
    required this.fromWalletId,
    required this.toWalletId,
    required this.title,
    required this.amount,
    this.description,
    this.date,
  });

  @override
  List<Object?> get props => [
    fromWalletId,
    toWalletId,
    title,
    amount,
    description,
    date,
  ];
}

/// Delete transaction
class TransactionDeleteRequested extends TransactionEvent {
  final String id;

  const TransactionDeleteRequested(this.id);

  @override
  List<Object?> get props => [id];
}
