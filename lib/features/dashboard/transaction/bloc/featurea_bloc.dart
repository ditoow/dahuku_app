import 'package:flutter_bloc/flutter_bloc.dart';
import 'featurea_event.dart';
import 'featurea_state.dart';

class FeatureaBloc extends Bloc<FeatureaEvent, FeatureaState> {
  FeatureaBloc() : super(FeatureaState.initial()) {
    on<ToggleTransactionType>(_onToggleTransactionType);
    on<UpdateAmount>(_onUpdateAmount);
    on<SelectExpenseCategory>(_onSelectExpenseCategory);
    on<SelectIncomeSource>(_onSelectIncomeSource);
    on<UpdateNote>(_onUpdateNote);
    on<SelectWallet>(_onSelectWallet);
    on<SaveTransaction>(_onSaveTransaction);
    on<ResetForm>(_onResetForm);
  }

  void _onToggleTransactionType(
    ToggleTransactionType event,
    Emitter<FeatureaState> emit,
  ) {
    // When switching modes, clear the category selection of the other mode
    emit(state.copyWith(
      isIncome: event.isIncome,
      clearExpenseCategory: event.isIncome, // Clear expense if switching to income
      clearIncomeSource: !event.isIncome, // Clear income if switching to expense
    ));
  }

  void _onUpdateAmount(
    UpdateAmount event,
    Emitter<FeatureaState> emit,
  ) {
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

  void _onUpdateNote(
    UpdateNote event,
    Emitter<FeatureaState> emit,
  ) {
    emit(state.copyWith(note: event.note));
  }

  void _onSelectWallet(
    SelectWallet event,
    Emitter<FeatureaState> emit,
  ) {
    emit(state.copyWith(selectedWallet: event.wallet));
  }

  Future<void> _onSaveTransaction(
    SaveTransaction event,
    Emitter<FeatureaState> emit,
  ) async {
    if (!state.isValid) return;

    emit(state.copyWith(isLoading: true, clearError: true));

    try {
      // TODO: Implement actual save logic with repository
      await Future.delayed(const Duration(milliseconds: 500));

      // Reset form after successful save
      emit(FeatureaState.initial());
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      ));
    }
  }

  void _onResetForm(
    ResetForm event,
    Emitter<FeatureaState> emit,
  ) {
    emit(FeatureaState.initial());
  }
}
