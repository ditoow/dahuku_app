import 'package:equatable/equatable.dart';
import '../data/models/transaction_model.dart';

/// Transaction state status
enum TransactionStatus { initial, loading, success, failure }

/// Transaction state
class TransactionState extends Equatable {
  final TransactionStatus status;
  final List<TransactionModel> transactions;
  final String? errorMessage;

  const TransactionState({
    this.status = TransactionStatus.initial,
    this.transactions = const [],
    this.errorMessage,
  });

  /// Get transactions by type
  List<TransactionModel> getByType(TransactionType type) =>
      transactions.where((t) => t.type == type).toList();

  /// Total income
  double get totalIncome =>
      getByType(TransactionType.income).fold(0.0, (sum, t) => sum + t.amount);

  /// Total expense
  double get totalExpense =>
      getByType(TransactionType.expense).fold(0.0, (sum, t) => sum + t.amount);

  TransactionState copyWith({
    TransactionStatus? status,
    List<TransactionModel>? transactions,
    String? errorMessage,
  }) {
    return TransactionState(
      status: status ?? this.status,
      transactions: transactions ?? this.transactions,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, transactions, errorMessage];
}
