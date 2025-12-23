import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/repositories/savings_debt_repository.dart';
import 'savings_debt_event.dart';
import 'savings_debt_state.dart';

/// BLoC untuk mengelola Target Tabungan dan Hutang
class SavingsDebtBloc extends Bloc<SavingsDebtEvent, SavingsDebtState> {
  final SavingsDebtRepository _repository;

  SavingsDebtBloc(this._repository) : super(SavingsDebtState.initial()) {
    on<LoadSavingsDebt>(_onLoadSavingsDebt);
    on<RefreshSavingsDebt>(_onRefreshSavingsDebt);
    on<CreateSavingsGoal>(_onCreateSavingsGoal);
    on<DepositToGoal>(_onDepositToGoal);
    on<DeleteSavingsGoal>(_onDeleteSavingsGoal);
    on<CreateDebt>(_onCreateDebt);
    on<PayDebt>(_onPayDebt);
    on<DeleteDebt>(_onDeleteDebt);
  }

  Future<void> _onLoadSavingsDebt(
    LoadSavingsDebt event,
    Emitter<SavingsDebtState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, clearMessages: true));

    try {
      final goals = await _repository.getActiveSavingsGoals();
      final debts = await _repository.getActiveDebts();

      emit(state.copyWith(isLoading: false, savingsGoals: goals, debts: debts));
    } catch (e) {
      emit(
        state.copyWith(isLoading: false, errorMessage: 'Gagal memuat data: $e'),
      );
    }
  }

  Future<void> _onRefreshSavingsDebt(
    RefreshSavingsDebt event,
    Emitter<SavingsDebtState> emit,
  ) async {
    try {
      final goals = await _repository.getActiveSavingsGoals();
      final debts = await _repository.getActiveDebts();

      emit(
        state.copyWith(savingsGoals: goals, debts: debts, clearMessages: true),
      );
    } catch (e) {
      emit(state.copyWith(errorMessage: 'Gagal memperbarui data: $e'));
    }
  }

  Future<void> _onCreateSavingsGoal(
    CreateSavingsGoal event,
    Emitter<SavingsDebtState> emit,
  ) async {
    emit(state.copyWith(isSubmitting: true, clearMessages: true));

    try {
      await _repository.createSavingsGoal(
        nama: event.nama,
        deskripsi: event.deskripsi,
        jumlahTarget: event.jumlahTarget,
        icon: event.icon,
        warna: event.warna,
        tanggalTarget: event.tanggalTarget,
      );

      // Refresh data
      final goals = await _repository.getActiveSavingsGoals();
      emit(
        state.copyWith(
          isSubmitting: false,
          savingsGoals: goals,
          successMessage: 'Target tabungan berhasil dibuat!',
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isSubmitting: false,
          errorMessage: 'Gagal membuat target: $e',
        ),
      );
    }
  }

  Future<void> _onDepositToGoal(
    DepositToGoal event,
    Emitter<SavingsDebtState> emit,
  ) async {
    emit(state.copyWith(isSubmitting: true, clearMessages: true));

    try {
      await _repository.depositToGoal(
        targetId: event.targetId,
        jumlah: event.jumlah,
        catatan: event.catatan,
      );

      // Refresh data
      final goals = await _repository.getActiveSavingsGoals();
      emit(
        state.copyWith(
          isSubmitting: false,
          savingsGoals: goals,
          successMessage: 'Berhasil menyetor!',
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(isSubmitting: false, errorMessage: 'Gagal menyetor: $e'),
      );
    }
  }

  Future<void> _onDeleteSavingsGoal(
    DeleteSavingsGoal event,
    Emitter<SavingsDebtState> emit,
  ) async {
    emit(state.copyWith(isSubmitting: true, clearMessages: true));

    try {
      await _repository.deleteSavingsGoal(event.id);

      final goals = await _repository.getActiveSavingsGoals();
      emit(
        state.copyWith(
          isSubmitting: false,
          savingsGoals: goals,
          successMessage: 'Target dihapus!',
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isSubmitting: false,
          errorMessage: 'Gagal menghapus: $e',
        ),
      );
    }
  }

  Future<void> _onCreateDebt(
    CreateDebt event,
    Emitter<SavingsDebtState> emit,
  ) async {
    emit(state.copyWith(isSubmitting: true, clearMessages: true));

    try {
      await _repository.createDebt(
        nama: event.nama,
        jenis: event.jenis,
        jumlah: event.jumlah,
        bungaPersen: event.bungaPersen,
        tanggalJatuhTempo: event.tanggalJatuhTempo,
      );

      final debts = await _repository.getActiveDebts();
      emit(
        state.copyWith(
          isSubmitting: false,
          debts: debts,
          successMessage: 'Hutang berhasil dicatat!',
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isSubmitting: false,
          errorMessage: 'Gagal mencatat hutang: $e',
        ),
      );
    }
  }

  Future<void> _onPayDebt(PayDebt event, Emitter<SavingsDebtState> emit) async {
    emit(state.copyWith(isSubmitting: true, clearMessages: true));

    try {
      await _repository.payDebt(
        hutangId: event.hutangId,
        jumlah: event.jumlah,
        catatan: event.catatan,
      );

      final debts = await _repository.getActiveDebts();
      emit(
        state.copyWith(
          isSubmitting: false,
          debts: debts,
          successMessage: 'Pembayaran berhasil!',
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(isSubmitting: false, errorMessage: 'Gagal membayar: $e'),
      );
    }
  }

  Future<void> _onDeleteDebt(
    DeleteDebt event,
    Emitter<SavingsDebtState> emit,
  ) async {
    emit(state.copyWith(isSubmitting: true, clearMessages: true));

    try {
      await _repository.deleteDebt(event.id);

      final debts = await _repository.getActiveDebts();
      emit(
        state.copyWith(
          isSubmitting: false,
          debts: debts,
          successMessage: 'Hutang dihapus!',
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isSubmitting: false,
          errorMessage: 'Gagal menghapus: $e',
        ),
      );
    }
  }
}
