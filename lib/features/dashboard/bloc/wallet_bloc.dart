import 'package:flutter_bloc/flutter_bloc.dart';
import 'wallet_event.dart';
import 'wallet_state.dart';
import '../data/repositories/wallet_repository.dart';

/// Wallet BLoC - manages wallet CRUD operations
class WalletBloc extends Bloc<WalletEvent, WalletState> {
  final WalletRepository repository;

  WalletBloc({required this.repository}) : super(const WalletState()) {
    on<WalletLoadRequested>(_onLoadRequested);
    on<WalletCreateRequested>(_onCreateRequested);
    on<WalletUpdateRequested>(_onUpdateRequested);
    on<WalletDeleteRequested>(_onDeleteRequested);
  }

  Future<void> _onLoadRequested(
    WalletLoadRequested event,
    Emitter<WalletState> emit,
  ) async {
    emit(state.copyWith(status: WalletStatus.loading));

    try {
      final wallets = await repository.getWallets();
      emit(state.copyWith(status: WalletStatus.success, wallets: wallets));
    } catch (e) {
      emit(
        state.copyWith(
          status: WalletStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onCreateRequested(
    WalletCreateRequested event,
    Emitter<WalletState> emit,
  ) async {
    emit(state.copyWith(status: WalletStatus.loading));

    try {
      final newWallet = await repository.createWallet(
        name: event.name,
        type: event.type,
        balance: event.balance,
        isPrimary: event.isPrimary,
        iconName: event.iconName,
        colorHex: event.colorHex,
      );

      emit(
        state.copyWith(
          status: WalletStatus.success,
          wallets: [...state.wallets, newWallet],
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: WalletStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onUpdateRequested(
    WalletUpdateRequested event,
    Emitter<WalletState> emit,
  ) async {
    emit(state.copyWith(status: WalletStatus.loading));

    try {
      final updatedWallet = await repository.updateWallet(event.wallet);

      final updatedWallets = state.wallets.map((w) {
        return w.id == updatedWallet.id ? updatedWallet : w;
      }).toList();

      emit(
        state.copyWith(status: WalletStatus.success, wallets: updatedWallets),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: WalletStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onDeleteRequested(
    WalletDeleteRequested event,
    Emitter<WalletState> emit,
  ) async {
    emit(state.copyWith(status: WalletStatus.loading));

    try {
      await repository.deleteWallet(event.id);

      final updatedWallets = state.wallets
          .where((w) => w.id != event.id)
          .toList();

      emit(
        state.copyWith(status: WalletStatus.success, wallets: updatedWallets),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: WalletStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
