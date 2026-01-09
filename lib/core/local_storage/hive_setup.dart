import 'package:hive_flutter/hive_flutter.dart';
import '../../features/dashboard/data/models/transaction_model.dart';
import '../../features/dashboard/data/models/wallet_model.dart';
import '../../features/dashboard/data/models/category_model.dart';
import '../../features/dashboard/data/models/dashboard_summary.dart';
import '../../features/analytics/data/models/savings_debt_model.dart';
import '../../features/account/data/models/user_model.dart';
import '../../features/account/data/models/settings_model.dart';

class HiveSetup {
  static Future<void> init() async {
    await Hive.initFlutter();

    // Register Adapters
    Hive.registerAdapter(TransactionModelAdapter());
    Hive.registerAdapter(TransactionTypeAdapter());
    Hive.registerAdapter(WalletModelAdapter());
    Hive.registerAdapter(WalletTypeAdapter());
    Hive.registerAdapter(CategoryModelAdapter());
    Hive.registerAdapter(DashboardSummaryAdapter());
    Hive.registerAdapter(SavingsGoalModelAdapter());
    Hive.registerAdapter(DebtModelAdapter());
    Hive.registerAdapter(UserModelAdapter());
    Hive.registerAdapter(SettingsModelAdapter());

    // Open Boxes
    await Hive.openBox<TransactionModel>('transactions_box');
    await Hive.openBox<WalletModel>('wallets_box');
    await Hive.openBox<CategoryModel>('categories_box');
    await Hive.openBox<TransactionModel>('pending_sync_box');
    await Hive.openBox<DashboardSummary>('summary_box');
    await Hive.openBox<SavingsGoalModel>('savings_box');
    await Hive.openBox<DebtModel>('debts_box');
    await Hive.openBox<UserModel>('user_box');
    await Hive.openBox<SettingsModel>('settings_box');
  }

  /// Clear all user data from Hive boxes (call on logout)
  static Future<void> clearAllUserData() async {
    print('🗑️ HIVE: Clearing all user data...');

    // Clear all boxes to prevent data mixing between accounts
    await Hive.box<TransactionModel>('transactions_box').clear();
    await Hive.box<WalletModel>('wallets_box').clear();
    await Hive.box<CategoryModel>('categories_box').clear();
    await Hive.box<TransactionModel>('pending_sync_box').clear();
    await Hive.box<DashboardSummary>('summary_box').clear();
    await Hive.box<SavingsGoalModel>('savings_box').clear();
    await Hive.box<DebtModel>('debts_box').clear();
    await Hive.box<UserModel>('user_box').clear();
    await Hive.box<SettingsModel>('settings_box').clear();

    print('🗑️ HIVE: All user data cleared');
  }
}
