import 'package:get_it/get_it.dart';

// Core services
import '../data/services/connectivity_service.dart';

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

// Feature: Dashboard
import '../../features/dashboard/data/repositories/wallet_repository.dart';
import '../../features/dashboard/data/repositories/transaction_repository.dart';
import '../../features/dashboard/data/services/wallet_service.dart';
import '../../features/dashboard/data/services/transaction_service.dart';
import '../../features/dashboard/bloc/dashboard_bloc.dart';
import '../../features/dashboard/bloc/wallet_bloc.dart';
import '../../features/dashboard/bloc/transaction_bloc.dart';

// Feature: Questionnaire
import '../../features/boardingfeature/questionnaire/data/repositories/questionnaire_repository.dart';
import '../../features/boardingfeature/questionnaire/data/services/questionnaire_service.dart';
import '../../features/boardingfeature/questionnaire/bloc/questionnaire_bloc.dart';

final GetIt sl = GetIt.instance;

/// Initialize all dependencies
Future<void> initializeDependencies() async {
  // ==================
  // CORE SERVICES
  // ==================
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
    ),
  );
  sl.registerFactory<AccountBloc>(() => AccountBloc(sl()));

  // ==================
  // FEATURE: DASHBOARD
  // ==================
  sl.registerLazySingleton<WalletService>(() => WalletService());
  sl.registerLazySingleton<TransactionService>(() => TransactionService());
  sl.registerLazySingleton<WalletRepository>(
    () => WalletRepository(walletService: sl()),
  );
  sl.registerLazySingleton<TransactionRepository>(
    () => TransactionRepository(transactionService: sl()),
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
  // FEATURE: QUESTIONNAIRE
  // ==================
  sl.registerLazySingleton<QuestionnaireService>(() => QuestionnaireService());
  sl.registerLazySingleton<QuestionnaireRepository>(
    () => QuestionnaireRepository(questionnaireService: sl()),
  );
  sl.registerFactory<QuestionnaireBloc>(
    () => QuestionnaireBloc(repository: sl()),
  );
}
