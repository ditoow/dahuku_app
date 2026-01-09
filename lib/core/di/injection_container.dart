import 'package:get_it/get_it.dart';

// Core services
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../services/offline_mode_service.dart';
import '../services/sync_service.dart';
import '../data/services/connectivity_service.dart';

// Models
import '../../features/dashboard/data/models/transaction_model.dart';
import '../../features/dashboard/data/models/wallet_model.dart';
import '../../features/dashboard/data/models/category_model.dart';
import '../../features/dashboard/data/models/dashboard_summary.dart';
import '../../features/analytics/data/models/savings_debt_model.dart';
import '../../features/account/data/models/user_model.dart';
import '../../features/account/data/models/settings_model.dart';

// Feature: Auth
import '../../features/boardingfeature/auth/data/repositories/auth_repository.dart';
import '../../features/boardingfeature/auth/data/services/auth_service.dart';
import '../../features/boardingfeature/auth/bloc/auth_bloc.dart';

// Feature: Account
import '../../features/account/data/repositories/account_repository.dart';
import '../../features/account/data/services/account_service.dart';
import '../../features/account/data/services/backup_service.dart';
import '../../features/account/data/services/local_storage_service.dart';
import '../../features/account/bloc/account_bloc.dart';
import '../../features/account/bloc/offline_mode_cubit.dart';

// Feature: Dashboard
import '../../features/dashboard/data/repositories/wallet_repository.dart';
import '../../features/dashboard/data/repositories/transaction_repository.dart';
import '../../features/dashboard/data/services/wallet_service.dart';
import '../../features/dashboard/data/services/transaction_service.dart';
import '../../features/dashboard/bloc/dashboard_bloc.dart';
import '../../features/dashboard/bloc/wallet_bloc.dart';
import '../../features/dashboard/bloc/transaction_bloc.dart';

// Feature: Pindah Uang
import '../../features/dashboard/pindah_uang/data/services/transfer_service.dart';
import '../../features/dashboard/pindah_uang/data/repositories/transfer_repository.dart';
import '../../features/dashboard/pindah_uang/bloc/pindah_uang_bloc.dart';

// Feature: Questionnaire
import '../../features/boardingfeature/questionnaire/data/repositories/questionnaire_repository.dart';
import '../../features/boardingfeature/questionnaire/data/services/questionnaire_service.dart';
import '../../features/boardingfeature/questionnaire/bloc/questionnaire_bloc.dart';

// Feature: Analytics
import '../../features/analytics/bloc/analytics_bloc.dart';
import '../../features/analytics/bloc/savings_debt_bloc.dart';
import '../../features/analytics/data/services/savings_debt_service.dart';
import '../../features/analytics/data/repositories/savings_debt_repository.dart';

// Feature: Education (Comics)
import '../../features/education/data/services/comic_service.dart';
import '../../features/education/data/repositories/comic_repository.dart';
import '../../features/education/bloc/comic_bloc.dart';

final GetIt sl = GetIt.instance;

/// Initialize all dependencies
Future<void> initializeDependencies() async {
  // ==================
  // CORE SERVICES
  // ==================
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => OfflineModeService(sl()));

  sl.registerLazySingleton(
    () => SyncService(
      transactionRepository: sl(),
      walletRepository: sl(),
      savingsDebtRepository: sl(),
      accountRepository: sl(),
    ),
  );

  sl.registerLazySingleton<ConnectivityService>(() => ConnectivityService());

  // ==================
  // FEATURE: AUTH
  // ==================
  sl.registerLazySingleton<AuthService>(() => AuthService());
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepository(authService: sl()),
  );
  sl.registerFactory<AuthBloc>(() => AuthBloc(repository: sl()));

  // ==================
  // FEATURE: ACCOUNT
  // ==================
  sl.registerLazySingleton<AccountService>(() => AccountService());
  sl.registerLazySingleton<BackupService>(() => BackupService());
  sl.registerLazySingleton<LocalStorageService>(() => LocalStorageService());
  sl.registerLazySingleton<AccountRepository>(
    () => AccountRepository(
      accountService: sl(),
      backupService: sl(),
      localStorageService: sl(),
      userBox: sl(),
      settingsBox: sl(),
      offlineModeService: sl(),
    ),
    instanceName: null,
  );
  sl.registerFactory<AccountBloc>(() => AccountBloc(sl()));
  sl.registerFactory<OfflineModeCubit>(
    () => OfflineModeCubit(sl(), sl(), sl(), sl()),
  );

  // ==================
  // FEATURE: DASHBOARD
  // ==================
  // Hive Boxes
  sl.registerLazySingleton<Box<TransactionModel>>(
    () => Hive.box<TransactionModel>('transactions_box'),
  );
  sl.registerLazySingleton<Box<TransactionModel>>(
    () => Hive.box<TransactionModel>('pending_sync_box'),
    instanceName: 'pending_box',
  );
  sl.registerLazySingleton<Box<WalletModel>>(
    () => Hive.box<WalletModel>('wallets_box'),
  );
  sl.registerLazySingleton<Box<CategoryModel>>(
    () => Hive.box<CategoryModel>('categories_box'),
  );
  sl.registerLazySingleton<Box<DashboardSummary>>(
    () => Hive.box<DashboardSummary>('summary_box'),
  );
  sl.registerLazySingleton<Box<SavingsGoalModel>>(
    () => Hive.box<SavingsGoalModel>('savings_box'),
  );
  sl.registerLazySingleton<Box<DebtModel>>(
    () => Hive.box<DebtModel>('debts_box'),
  );
  sl.registerLazySingleton<Box<UserModel>>(
    () => Hive.box<UserModel>('user_box'),
  );
  sl.registerLazySingleton<Box<SettingsModel>>(
    () => Hive.box<SettingsModel>('settings_box'),
  );

  sl.registerLazySingleton<WalletService>(() => WalletService());
  sl.registerLazySingleton<TransactionService>(() => TransactionService());
  sl.registerLazySingleton<WalletRepository>(
    () => WalletRepository(
      walletService: sl(),
      box: sl(),
      offlineModeService: sl(),
    ),
  );
  sl.registerLazySingleton<TransactionRepository>(
    () => TransactionRepository(
      transactionService: sl(),
      box: sl(),
      pendingBox: sl(instanceName: 'pending_box'),
      summaryBox: sl(),
      walletRepository: sl(),
      offlineModeService: sl(),
    ),
  );
  sl.registerFactory<DashboardBloc>(
    () => DashboardBloc(
      walletRepository: sl(),
      transactionRepository: sl(),
      questionnaireRepository: sl(),
    ),
  );
  sl.registerFactory<WalletBloc>(() => WalletBloc(repository: sl()));
  sl.registerFactory<TransactionBloc>(() => TransactionBloc(repository: sl()));

  // ==================
  // FEATURE: PINDAH UANG
  // ==================
  sl.registerLazySingleton<TransferService>(() => TransferService());
  sl.registerLazySingleton<TransferRepository>(() => TransferRepository(sl()));
  sl.registerFactory<PindahUangBloc>(() => PindahUangBloc(sl()));

  // ==================
  // FEATURE: QUESTIONNAIRE
  // ==================
  sl.registerLazySingleton<QuestionnaireService>(() => QuestionnaireService());
  sl.registerLazySingleton<QuestionnaireRepository>(
    () => QuestionnaireRepository(questionnaireService: sl()),
  );
  sl.registerFactory<QuestionnaireBloc>(
    () => QuestionnaireBloc(repository: sl()),
  );

  // ==================
  // FEATURE: ANALYTICS
  // ==================
  sl.registerFactory<AnalyticsBloc>(
    () => AnalyticsBloc(transactionRepository: sl(), walletRepository: sl()),
  );
  sl.registerLazySingleton<SavingsDebtService>(() => SavingsDebtService());
  sl.registerLazySingleton<SavingsDebtRepository>(
    () => SavingsDebtRepository(
      service: sl(),
      savingsBox: sl(),
      debtBox: sl(),
      offlineModeService: sl(),
    ),
  );
  sl.registerFactory<SavingsDebtBloc>(() => SavingsDebtBloc(sl()));

  // ==================
  // FEATURE: EDUCATION (COMICS)
  // ==================
  sl.registerLazySingleton<ComicService>(() => ComicService());
  sl.registerLazySingleton<ComicRepository>(() => ComicRepository(sl()));
  sl.registerFactory<ComicBloc>(() => ComicBloc(repository: sl()));
}
