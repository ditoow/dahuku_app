import 'package:flutter/foundation.dart';
import '../../features/dashboard/data/repositories/transaction_repository.dart';
import '../../features/dashboard/data/repositories/wallet_repository.dart';
import '../../features/analytics/data/repositories/savings_debt_repository.dart';
import '../../features/account/data/repositories/account_repository.dart';

class SyncService {
  final TransactionRepository transactionRepository;
  final WalletRepository walletRepository;
  final SavingsDebtRepository savingsDebtRepository;
  final AccountRepository accountRepository;

  SyncService({
    required this.transactionRepository,
    required this.walletRepository,
    required this.savingsDebtRepository,
    required this.accountRepository,
  });

  /// Sync all data from remote to local cache
  Future<void> syncAllData() async {
    debugPrint('Starting Background Sync...');
    try {
      // 1. Sync User & Settings
      await accountRepository.fetchUser();
      await accountRepository.fetchSettings();

      // 2. Sync Wallets (needed for transactions)
      await walletRepository.getWallets();

      // 3. Sync Transactions (Fetch all without limit/filter to cache everything)
      // Note: In a real large-scale app, we might want to limit this to last 3-6 months
      await transactionRepository.getTransactions(limit: 1000);
      await transactionRepository.getDashboardSummary();
      await transactionRepository.getWeeklyExpense();

      // 4. Sync Savings & Debts
      await savingsDebtRepository.getSavingsGoals();
      await savingsDebtRepository.getDebts();

      debugPrint('Background Sync Completed Successfully');
    } catch (e) {
      debugPrint('Background Sync Failed: $e');
      // Silent failure is okay for background sync
    }
  }
}
