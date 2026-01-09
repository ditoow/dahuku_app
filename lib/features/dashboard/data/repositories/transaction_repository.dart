import 'package:flutter/foundation.dart'; // For debugPrint
import 'package:hive_flutter/hive_flutter.dart';
import '../../../../core/services/offline_mode_service.dart';
import '../../../../core/data/repositories/base_repository.dart';
import '../models/transaction_model.dart';
import '../models/dashboard_summary.dart';

import '../repositories/wallet_repository.dart'; // Import WalletRepository
import '../services/transaction_service.dart';

/// Repository for transaction operations
class TransactionRepository extends BaseRepository {
  final TransactionService transactionService;
  final Box<TransactionModel> box;
  final Box<TransactionModel> pendingBox;
  final Box<DashboardSummary> summaryBox;
  final WalletRepository
  walletRepository; // Replace walletsBox with WalletRepository
  final OfflineModeService offlineModeService;

  TransactionRepository({
    required this.transactionService,
    required this.box,
    required this.pendingBox,
    required this.summaryBox,
    required this.walletRepository,
    required this.offlineModeService,
  });

  /// Get all transactions with optional filters
  Future<List<TransactionModel>> getTransactions({
    int? limit,
    DateTime? startDate,
    DateTime? endDate,
    String? walletId,
    TransactionType? type,
  }) async {
    if (offlineModeService.isOfflineMode) {
      var transactions = box.values.toList();

      // Apply Filters Locally
      if (walletId != null) {
        transactions = transactions
            .where((t) => t.walletId == walletId)
            .toList();
      }
      if (type != null) {
        transactions = transactions.where((t) => t.type == type).toList();
      }
      if (startDate != null) {
        transactions = transactions
            .where((t) => t.transactionDate.isAfter(startDate))
            .toList();
      }
      if (endDate != null) {
        transactions = transactions
            .where(
              (t) => t.transactionDate.isBefore(endDate.add(Duration(days: 1))),
            )
            .toList();
      }

      // Sort by date desc
      transactions.sort(
        (a, b) => b.transactionDate.compareTo(a.transactionDate),
      );

      if (limit != null && transactions.length > limit) {
        transactions = transactions.sublist(0, limit);
      }
      return transactions;
    }

    try {
      final transactions = await transactionService.getTransactions(
        limit: limit,
        startDate: startDate,
        endDate: endDate,
        walletId: walletId,
        type: type,
      );

      // Cache transactions
      for (var transaction in transactions) {
        if (transaction.id.isNotEmpty) {
          await box.put(transaction.id, transaction);
        }
      }
      return transactions;
    } catch (e) {
      // Fallback to cache on error
      return box.values.toList();
    }
  }

  /// Get recent transactions
  Future<List<TransactionModel>> getRecentTransactions({int limit = 5}) async {
    if (offlineModeService.isOfflineMode) {
      return getTransactions(limit: limit);
    }

    try {
      final transactions = await transactionService.getRecentTransactions(
        limit: limit,
      );

      // Cache transactions
      for (var transaction in transactions) {
        if (transaction.id.isNotEmpty) {
          await box.put(transaction.id, transaction);
        }
      }
      return transactions;
    } catch (e) {
      return getTransactions(limit: limit);
    }
  }

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
  }) async {
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

    return _createWithFallback(
      transaction,
      () => transactionService.createTransaction(transaction),
      () async {
        await _updateLocalWalletBalance(walletId, amount, isIncome: true);
      },
    );
  }

  /// Create expense transaction
  Future<TransactionModel> createExpense({
    required String walletId,
    required String title,
    required double amount,
    String? description,
    String? categoryId,
    DateTime? date,
  }) async {
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

    return _createWithFallback(
      transaction,
      () => transactionService.createTransaction(transaction),
      () async {
        await _updateLocalWalletBalance(walletId, amount, isIncome: false);
      },
    );
  }

  /// Create transfer between wallets
  Future<TransactionModel> createTransfer({
    required String fromWalletId,
    required String toWalletId,
    required String title,
    required double amount,
    String? description,
    DateTime? date,
  }) async {
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

    return _createWithFallback(
      transaction,
      () => transactionService.createTransaction(transaction),
      () async {
        await _updateLocalWalletBalance(fromWalletId, amount, isIncome: false);
        await _updateLocalWalletBalance(toWalletId, amount, isIncome: true);
      },
    );
  }

  /// Update transaction
  Future<TransactionModel> updateTransaction(TransactionModel transaction) =>
      transactionService.updateTransaction(transaction);

  /// Delete transaction
  Future<void> deleteTransaction(String id) =>
      transactionService.deleteTransaction(id);

  /// Sync pending transactions
  Future<void> syncPendingTransactions() async {
    print('🔄 SYNC: Starting syncPendingTransactions');
    print('🔄 SYNC: Pending count = ${pendingBox.length}');
    if (pendingBox.isEmpty) {
      print('🔄 SYNC: No pending transactions, skipping');
      return;
    }

    final pendingTransactions = pendingBox.toMap();
    print('🔄 SYNC: Processing ${pendingTransactions.length} transactions');

    for (var entry in pendingTransactions.entries) {
      final key = entry.key;
      final transaction = entry.value;
      print(
        '🔄 SYNC: Syncing tx: ${transaction.title}, amount: ${transaction.amount}',
      );

      try {
        // Create transaction in Supabase
        // NOTE: Supabase trigger 'perbarui_saldo_dompet' auto-updates wallet balance
        final syncedTx = await transactionService.createTransaction(
          transaction.copyWith(id: ''),
        );
        print('🔄 SYNC: ✅ Transaction created on server: ${syncedTx.id}');

        // Remove from pending and temp cache
        await pendingBox.delete(key);
        await box.delete(transaction.id);

        // Add real synced transaction to cache
        await box.put(syncedTx.id, syncedTx);
        print('🔄 SYNC: ✅ Cleaned up pending entry');
      } catch (e) {
        print('🔄 SYNC: ❌ Failed to sync: $e');
      }
    }
    print('🔄 SYNC: Completed');
  }

  // NOTE: _syncWalletBalance was removed because Supabase trigger
  // 'perbarui_saldo_dompet' auto-updates wallet balance on transaction insert.

  /// Get dashboard summary
  Future<DashboardSummary> getDashboardSummary() async {
    if (offlineModeService.isOfflineMode) {
      if (summaryBox.isNotEmpty) {
        return summaryBox.getAt(0)!;
      }
      return DashboardSummary.empty();
    }

    try {
      final summary = await transactionService.getDashboardSummary();
      await summaryBox.put('cached_summary', summary);
      return summary;
    } catch (e) {
      if (summaryBox.isNotEmpty) {
        return summaryBox.get('cached_summary') ?? DashboardSummary.empty();
      }
      return DashboardSummary.empty();
    }
  }

  /// Get weekly expense
  Future<double> getWeeklyExpense() async {
    if (offlineModeService.isOfflineMode) {
      final now = DateTime.now();
      final startOfWeek = now.subtract(const Duration(days: 7));
      return box.values
          .where(
            (t) =>
                t.type == TransactionType.expense &&
                t.transactionDate.isAfter(startOfWeek),
          )
          .fold<double>(
            0.0,
            (previousValue, element) => previousValue + element.amount,
          );
    }

    try {
      return await transactionService.getWeeklyExpense();
    } catch (e) {
      // Fallback
      final now = DateTime.now();
      final startOfWeek = now.subtract(const Duration(days: 7));
      return box.values
          .where(
            (t) =>
                t.type == TransactionType.expense &&
                t.transactionDate.isAfter(startOfWeek),
          )
          .fold<double>(
            0.0,
            (previousValue, element) => previousValue + element.amount,
          );
    }
  }

  /// Helper to update wallet balance locally
  Future<void> _updateLocalWalletBalance(
    String walletId,
    double amount, {
    required bool isIncome,
  }) async {
    // Access box directly from WalletRepository
    final walletsBox = walletRepository.box;
    final wallet = walletsBox.get(walletId);
    if (wallet != null) {
      final oldBalance = wallet.balance;
      final newBalance = isIncome
          ? wallet.balance + amount
          : wallet.balance - amount;
      final updatedWallet = wallet.copyWith(balance: newBalance);
      await walletsBox.put(walletId, updatedWallet);
      debugPrint(
        '=== LOCAL_UPDATE: ${wallet.name} balance: $oldBalance -> $newBalance ===',
      );
    }
  }

  /// Helper to handle online/offline fallback
  Future<TransactionModel> _createWithFallback(
    TransactionModel transaction,
    Future<TransactionModel> Function() onlineAction,
    Future<void> Function() onOfflineSuccess,
  ) async {
    // Helper to save offline
    Future<TransactionModel> saveOffline() async {
      final tempId =
          'TEMP_${DateTime.now().millisecondsSinceEpoch}_${transaction.hashCode}';
      final offlineTx = transaction.copyWith(id: tempId);
      await box.put(tempId, offlineTx);
      await pendingBox.add(offlineTx);
      print('📴 OFFLINE: Saved to pendingBox, count: ${pendingBox.length}');
      print('📴 OFFLINE: Tx: ${offlineTx.title}, amount: ${offlineTx.amount}');
      await onOfflineSuccess();
      return offlineTx;
    }

    if (offlineModeService.isOfflineMode) {
      print('📴 OFFLINE: Mode is ON, saving offline');
      return saveOffline();
    }

    try {
      return await onlineAction();
    } catch (e) {
      print('📴 OFFLINE: Online failed ($e), saving offline');
      return saveOffline();
    }
  }
}
