import 'package:flutter_bloc/flutter_bloc.dart';
import 'pindah_uang_event.dart';
import 'pindah_uang_state.dart';

/// BLoC for managing Pindah Uang (Transfer Money) state
class PindahUangBloc extends Bloc<PindahUangEvent, PindahUangState> {
  PindahUangBloc() : super(PindahUangState.initial()) {
    on<SelectTargetWallet>(_onSelectTargetWallet);
    on<UpdateAmount>(_onUpdateAmount);
    on<SubmitTransfer>(_onSubmitTransfer);
  }

  void _onSelectTargetWallet(
    SelectTargetWallet event,
    Emitter<PindahUangState> emit,
  ) {
    emit(state.copyWith(selectedTargetWalletType: event.walletType));
  }

  void _onUpdateAmount(UpdateAmount event, Emitter<PindahUangState> emit) {
    emit(state.copyWith(amount: event.amount));
  }

  Future<void> _onSubmitTransfer(
    SubmitTransfer event,
    Emitter<PindahUangState> emit,
  ) async {
    if (!state.isValid) return;

    emit(state.copyWith(isLoading: true));

    try {
      // TODO: Implement actual transfer logic with repository
      await Future.delayed(const Duration(seconds: 1));

      emit(state.copyWith(isLoading: false, isSuccess: true));
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: 'Gagal memindahkan uang: $e',
        ),
      );
    }
  }
}
