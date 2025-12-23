import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/transaction_repository.dart';
import '../../data/repositories/wallet_repository.dart';
import '../data/models/transaction_category.dart';
import '../../../../../core/data/services/supabase_service.dart';
import 'featurea_event.dart';
import 'featurea_state.dart';

class FeatureaBloc extends Bloc<FeatureaEvent, FeatureaState> {
  final TransactionRepository _transactionRepository;
  final WalletRepository _walletRepository;

  /// Expose wallet repository for bottom sheet picker
  WalletRepository get walletRepository => _walletRepository;

  FeatureaBloc({
    required TransactionRepository transactionRepository,
    required WalletRepository walletRepository,
  }) : _transactionRepository = transactionRepository,
       _walletRepository = walletRepository,
       super(FeatureaState.initial()) {
    on<LoadWallets>(_onLoadWallets);
    on<ToggleTransactionType>(_onToggleTransactionType);
    on<UpdateAmount>(_onUpdateAmount);
    on<SelectExpenseCategory>(_onSelectExpenseCategory);
    on<SelectIncomeSource>(_onSelectIncomeSource);
    on<UpdateNote>(_onUpdateNote);
    on<SelectWallet>(_onSelectWallet);
    on<SelectWalletById>(_onSelectWalletById);
    on<SaveTransaction>(_onSaveTransaction);
    on<ResetForm>(_onResetForm);
  }

  Future<void> _onLoadWallets(
    LoadWallets event,
    Emitter<FeatureaState> emit,
  ) async {
    try {
      print('FEATUREA_DEBUG: Loading wallets...');
      final wallets = await _walletRepository.getWallets();
      print('FEATUREA_DEBUG: Loaded ${wallets.length} wallets');

      if (wallets.isNotEmpty) {
        // Check if preselected wallet ID is provided
        dynamic selectedWallet;
        if (event.preselectedWalletId != null) {
          selectedWallet = wallets.firstWhere(
            (w) => w.id == event.preselectedWalletId,
            orElse: () => wallets.first,
          );
        } else {
          // Default to belanja wallet
          selectedWallet = wallets.firstWhere(
            (w) => w.type.name == 'belanja',
            orElse: () => wallets.first,
          );
        }

        print(
          'FEATUREA_DEBUG: Selected wallet: ${selectedWallet.id} - ${selectedWallet.name}',
        );

        // Set income mode if forced
        final isIncome = event.forceIncomeMode ?? state.isIncome;

        emit(
          state.copyWith(
            selectedWalletId: selectedWallet.id,
            selectedWalletName: selectedWallet.name,
            isIncome: isIncome,
          ),
        );
      } else {
        print('FEATUREA_DEBUG: No wallets found!');
        emit(
          state.copyWith(
            errorMessage: 'Tidak ada dompet ditemukan. Silakan login ulang.',
          ),
        );
      }
    } catch (e, stack) {
      print('FEATUREA_DEBUG: Error loading wallets: $e');
      print('FEATUREA_DEBUG: Stack: $stack');
      emit(state.copyWith(errorMessage: 'Gagal memuat dompet: $e'));
    }
  }

  void _onToggleTransactionType(
    ToggleTransactionType event,
    Emitter<FeatureaState> emit,
  ) {
    emit(
      state.copyWith(
        isIncome: event.isIncome,
        clearExpenseCategory: event.isIncome,
        clearIncomeSource: !event.isIncome,
      ),
    );
  }

  void _onUpdateAmount(UpdateAmount event, Emitter<FeatureaState> emit) {
    emit(state.copyWith(amount: event.amount));
  }

  void _onSelectExpenseCategory(
    SelectExpenseCategory event,
    Emitter<FeatureaState> emit,
  ) {
    emit(state.copyWith(selectedExpenseCategory: event.category));
  }

  void _onSelectIncomeSource(
    SelectIncomeSource event,
    Emitter<FeatureaState> emit,
  ) {
    emit(state.copyWith(selectedIncomeSource: event.source));
  }

  void _onUpdateNote(UpdateNote event, Emitter<FeatureaState> emit) {
    emit(state.copyWith(note: event.note));
  }

  void _onSelectWallet(SelectWallet event, Emitter<FeatureaState> emit) {
    emit(state.copyWith(selectedWallet: event.wallet));
  }

  void _onSelectWalletById(
    SelectWalletById event,
    Emitter<FeatureaState> emit,
  ) {
    emit(
      state.copyWith(
        selectedWalletId: event.walletId,
        selectedWalletName: event.walletName,
      ),
    );
  }

  Future<void> _onSaveTransaction(
    SaveTransaction event,
    Emitter<FeatureaState> emit,
  ) async {
    if (!state.isValid) return;

    emit(state.copyWith(isLoading: true, clearError: true));

    try {
      final userId = SupabaseService.currentUserId;
      if (userId == null) throw Exception('User belum login');

      // Get title from category
      String title;
      if (state.isIncome) {
        title = state.selectedIncomeSource?.displayName ?? 'Pemasukan';
      } else {
        title = state.selectedExpenseCategory?.displayName ?? 'Pengeluaran';
      }

      // Get wallet ID - must be a valid UUID
      final walletId = state.selectedWalletId;
      if (walletId == null || walletId.isEmpty) {
        throw Exception('Pilih dompet terlebih dahulu');
      }

      // Create transaction using repository
      if (state.isIncome) {
        await _transactionRepository.createIncome(
          walletId: walletId,
          title: title,
          amount: state.amount.toDouble(),
          description: state.note.isEmpty ? null : state.note,
        );
      } else {
        await _transactionRepository.createExpense(
          walletId: walletId,
          title: title,
          amount: state.amount.toDouble(),
          description: state.note.isEmpty ? null : state.note,
        );
      }

      // Mark as success - listener will handle navigation
      emit(state.copyWith(isLoading: false, isSuccess: true));
    } catch (e) {
      emit(
        state.copyWith(isLoading: false, errorMessage: 'Gagal menyimpan: $e'),
      );
    }
  }

  void _onResetForm(ResetForm event, Emitter<FeatureaState> emit) {
    emit(FeatureaState.initial());
  }
}
