import '../../../../core/data/repositories/base_repository.dart';
import '../models/transaction_model.dart';
import '../models/dashboard_summary.dart';
import '../services/transaction_service.dart';

/// Repository for transaction operations
class TransactionRepository extends BaseRepository {
  final TransactionService transactionService;

  TransactionRepository({required this.transactionService});

  /// Get all transactions with optional filters
  Future<List<TransactionModel>> getTransactions({
    int? limit,
    DateTime? startDate,
    DateTime? endDate,
    String? walletId,
    TransactionType? type,
  }) => transactionService.getTransactions(
    limit: limit,
    startDate: startDate,
    endDate: endDate,
    walletId: walletId,
    type: type,
  );

  /// Get recent transactions
  Future<List<TransactionModel>> getRecentTransactions({int limit = 5}) =>
      transactionService.getRecentTransactions(limit: limit);

  /// Get transaction by ID
  Future<TransactionModel?> getTransactionById(String id) =>
      transactionService.getTransactionById(id);

  /// Create income transaction
  Future<TransactionModel> createIncome({
    required String walletId,
    required String title,
    required double amount,
    String? description,
    String? categoryId,
    DateTime? date,
  }) {
    final transaction = TransactionModel(
      id: '',
      userId: userId,
      walletId: walletId,
      categoryId: categoryId,
      title: title,
      description: description,
      amount: amount,
      type: TransactionType.income,
      transactionDate: date ?? DateTime.now(),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    return transactionService.createTransaction(transaction);
  }

  /// Create expense transaction
  Future<TransactionModel> createExpense({
    required String walletId,
    required String title,
    required double amount,
    String? description,
    String? categoryId,
    DateTime? date,
  }) {
    final transaction = TransactionModel(
      id: '',
      userId: userId,
      walletId: walletId,
      categoryId: categoryId,
      title: title,
      description: description,
      amount: amount,
      type: TransactionType.expense,
      transactionDate: date ?? DateTime.now(),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    return transactionService.createTransaction(transaction);
  }

  /// Create transfer between wallets
  Future<TransactionModel> createTransfer({
    required String fromWalletId,
    required String toWalletId,
    required String title,
    required double amount,
    String? description,
    DateTime? date,
  }) {
    final transaction = TransactionModel(
      id: '',
      userId: userId,
      walletId: fromWalletId,
      title: title,
      description: description,
      amount: amount,
      type: TransactionType.transfer,
      targetWalletId: toWalletId,
      transactionDate: date ?? DateTime.now(),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    return transactionService.createTransaction(transaction);
  }

  /// Update transaction
  Future<TransactionModel> updateTransaction(TransactionModel transaction) =>
      transactionService.updateTransaction(transaction);

  /// Delete transaction
  Future<void> deleteTransaction(String id) =>
      transactionService.deleteTransaction(id);

  /// Get dashboard summary
  Future<DashboardSummary> getDashboardSummary() =>
      transactionService.getDashboardSummary();

  /// Get weekly expense
  Future<double> getWeeklyExpense() => transactionService.getWeeklyExpense();
}
