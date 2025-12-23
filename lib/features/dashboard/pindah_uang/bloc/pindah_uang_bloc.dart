import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/repositories/transfer_repository.dart';
import 'pindah_uang_event.dart';
import 'pindah_uang_state.dart';

/// BLoC for managing Pindah Uang (Transfer Money) state
class PindahUangBloc extends Bloc<PindahUangEvent, PindahUangState> {
  final TransferRepository _repository;

  PindahUangBloc(this._repository) : super(PindahUangState.initial()) {
    on<LoadWallets>(_onLoadWallets);
    on<SelectTargetWallet>(_onSelectTargetWallet);
    on<UpdateAmount>(_onUpdateAmount);
    on<SubmitTransfer>(_onSubmitTransfer);
  }

  Future<void> _onLoadWallets(
    LoadWallets event,
    Emitter<PindahUangState> emit,
  ) async {
    emit(state.copyWith(isLoadingWallets: true));

    try {
      final response = await _repository.getAllDompet();
      final wallets = response.map((w) => WalletInfo.fromJson(w)).toList();

      // Select source wallet based on initialSourceWalletId or default to belanja
      WalletInfo? sourceWallet;
      if (wallets.isNotEmpty) {
        if (event.initialSourceWalletId != null) {
          sourceWallet = wallets.firstWhere(
            (w) => w.id == event.initialSourceWalletId,
            orElse: () => wallets.first,
          );
        } else {
          // Default source = dompet belanja (primary)
          sourceWallet = wallets.firstWhere(
            (w) => w.tipe == 'belanja',
            orElse: () => wallets.first,
          );
        }
      }

      emit(
        state.copyWith(
          isLoadingWallets: false,
          wallets: wallets,
          sourceWallet: sourceWallet,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isLoadingWallets: false,
          errorMessage: 'Gagal memuat dompet: $e',
        ),
      );
    }
  }

  void _onSelectTargetWallet(
    SelectTargetWallet event,
    Emitter<PindahUangState> emit,
  ) {
    final target = state.wallets.firstWhere(
      (w) => w.tipe == event.walletType,
      orElse: () => state.wallets.first,
    );
    emit(state.copyWith(targetWallet: target));
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
      await _repository.transfer(
        idDompetSumber: state.sourceWallet!.id,
        idDompetTujuan: state.targetWallet!.id,
        jumlah: state.amount.toDouble(),
        deskripsi: 'Transfer ke ${state.targetWallet!.nama}',
      );

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
