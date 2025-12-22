import 'package:flutter_bloc/flutter_bloc.dart';
import 'dashboard_event.dart';
import 'dashboard_state.dart';
import '../data/repositories/wallet_repository.dart';
import '../data/repositories/transaction_repository.dart';
import '../../boardingfeature/questionnaire/data/repositories/questionnaire_repository.dart';

/// Dashboard BLoC - manages dashboard data state
class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final WalletRepository walletRepository;
  final TransactionRepository transactionRepository;
  final QuestionnaireRepository questionnaireRepository;

  DashboardBloc({
    required this.walletRepository,
    required this.transactionRepository,
    required this.questionnaireRepository,
  }) : super(const DashboardState()) {
    on<DashboardLoadRequested>(_onLoadRequested);
    on<DashboardRefreshRequested>(_onRefreshRequested);
  }

  Future<void> _onLoadRequested(
    DashboardLoadRequested event,
    Emitter<DashboardState> emit,
  ) async {
    emit(state.copyWith(status: DashboardStatus.loading));
    print('DASHBOARD_DEBUG: Load requested');

    try {
      var wallets = await walletRepository.getWallets();
      print('DASHBOARD_DEBUG: Initial wallets count: ${wallets.length}');

      // HEALING MECHANISM: If wallets are empty, try to create them from questionnaire data
      if (wallets.isEmpty) {
        print('DASHBOARD_DEBUG: Wallets empty, attempting healing...');
        try {
          final questionnaire = await questionnaireRepository.getResponse();
          print(
            'DASHBOARD_DEBUG: Questionnaire response found: ${questionnaire != null}',
          );

          if (questionnaire != null) {
            print(
              'DASHBOARD_DEBUG: Creating wallets from questionnaire data...',
            );
            await walletRepository.createInitialWallets(
              belanjaBalance: questionnaire.initialBelanja,
              tabunganBalance: questionnaire.initialTabungan,
              daruratBalance: questionnaire.initialDarurat,
            );
          } else {
            print(
              'DASHBOARD_DEBUG: No questionnaire data, creating default 0-balance wallets...',
            );
            // Default fallback if no questionnaire data found
            await walletRepository.createInitialWallets(
              belanjaBalance: 0,
              tabunganBalance: 0,
              daruratBalance: 0,
            );
          }
          // Fetch again after creation
          wallets = await walletRepository.getWallets();
          print(
            'DASHBOARD_DEBUG: Final wallets count after healing: ${wallets.length}',
          );
        } catch (e, stack) {
          print('DASHBOARD_DEBUG: Healing failed: $e\n$stack');
          // Ignore error during auto-creation attempt
        }
      }

      final transactions = await transactionRepository.getRecentTransactions(
        limit: 5,
      );
      final summary = await transactionRepository.getDashboardSummary();

      emit(
        state.copyWith(
          status: DashboardStatus.success,
          wallets: wallets,
          recentTransactions: transactions,
          summary: summary,
        ),
      );
    } catch (e, stack) {
      print('DASHBOARD_DEBUG: Dashboard load failed: $e\n$stack');
      emit(
        state.copyWith(
          status: DashboardStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onRefreshRequested(
    DashboardRefreshRequested event,
    Emitter<DashboardState> emit,
  ) async {
    // Don't show loading indicator on refresh
    try {
      final wallets = await walletRepository.getWallets();
      final transactions = await transactionRepository.getRecentTransactions(
        limit: 5,
      );
      final summary = await transactionRepository.getDashboardSummary();

      emit(
        state.copyWith(
          status: DashboardStatus.success,
          wallets: wallets,
          recentTransactions: transactions,
          summary: summary,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: DashboardStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
