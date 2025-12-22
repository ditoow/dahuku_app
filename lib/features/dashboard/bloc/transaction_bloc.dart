import 'package:flutter_bloc/flutter_bloc.dart';
import 'transaction_event.dart';
import 'transaction_state.dart';
import '../data/repositories/transaction_repository.dart';

/// Transaction BLoC - manages transaction operations
class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  final TransactionRepository repository;

  TransactionBloc({required this.repository})
    : super(const TransactionState()) {
    on<TransactionLoadRequested>(_onLoadRequested);
    on<TransactionCreateIncomeRequested>(_onCreateIncome);
    on<TransactionCreateExpenseRequested>(_onCreateExpense);
    on<TransactionCreateTransferRequested>(_onCreateTransfer);
    on<TransactionDeleteRequested>(_onDelete);
  }

  Future<void> _onLoadRequested(
    TransactionLoadRequested event,
    Emitter<TransactionState> emit,
  ) async {
    emit(state.copyWith(status: TransactionStatus.loading));

    try {
      final transactions = await repository.getTransactions(
        limit: event.limit,
        startDate: event.startDate,
        endDate: event.endDate,
        walletId: event.walletId,
        type: event.type,
      );

      emit(
        state.copyWith(
          status: TransactionStatus.success,
          transactions: transactions,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: TransactionStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onCreateIncome(
    TransactionCreateIncomeRequested event,
    Emitter<TransactionState> emit,
  ) async {
    emit(state.copyWith(status: TransactionStatus.loading));

    try {
      final transaction = await repository.createIncome(
        walletId: event.walletId,
        title: event.title,
        amount: event.amount,
        description: event.description,
        categoryId: event.categoryId,
        date: event.date,
      );

      emit(
        state.copyWith(
          status: TransactionStatus.success,
          transactions: [transaction, ...state.transactions],
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: TransactionStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onCreateExpense(
    TransactionCreateExpenseRequested event,
    Emitter<TransactionState> emit,
  ) async {
    emit(state.copyWith(status: TransactionStatus.loading));

    try {
      final transaction = await repository.createExpense(
        walletId: event.walletId,
        title: event.title,
        amount: event.amount,
        description: event.description,
        categoryId: event.categoryId,
        date: event.date,
      );

      emit(
        state.copyWith(
          status: TransactionStatus.success,
          transactions: [transaction, ...state.transactions],
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: TransactionStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onCreateTransfer(
    TransactionCreateTransferRequested event,
    Emitter<TransactionState> emit,
  ) async {
    emit(state.copyWith(status: TransactionStatus.loading));

    try {
      final transaction = await repository.createTransfer(
        fromWalletId: event.fromWalletId,
        toWalletId: event.toWalletId,
        title: event.title,
        amount: event.amount,
        description: event.description,
        date: event.date,
      );

      emit(
        state.copyWith(
          status: TransactionStatus.success,
          transactions: [transaction, ...state.transactions],
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: TransactionStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onDelete(
    TransactionDeleteRequested event,
    Emitter<TransactionState> emit,
  ) async {
    emit(state.copyWith(status: TransactionStatus.loading));

    try {
      await repository.deleteTransaction(event.id);

      final updated = state.transactions
          .where((t) => t.id != event.id)
          .toList();

      emit(
        state.copyWith(
          status: TransactionStatus.success,
          transactions: updated,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: TransactionStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
