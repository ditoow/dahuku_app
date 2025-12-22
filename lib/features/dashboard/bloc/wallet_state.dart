import 'package:equatable/equatable.dart';
import '../data/models/wallet_model.dart';

/// Wallet state status
enum WalletStatus { initial, loading, success, failure }

/// Wallet state
class WalletState extends Equatable {
  final WalletStatus status;
  final List<WalletModel> wallets;
  final String? errorMessage;

  const WalletState({
    this.status = WalletStatus.initial,
    this.wallets = const [],
    this.errorMessage,
  });

  /// Total balance
  double get totalBalance => wallets.fold(0.0, (sum, w) => sum + w.balance);

  /// Get wallet by type
  WalletModel? getWalletByType(WalletType type) =>
      wallets.where((w) => w.type == type).firstOrNull;

  WalletState copyWith({
    WalletStatus? status,
    List<WalletModel>? wallets,
    String? errorMessage,
  }) {
    return WalletState(
      status: status ?? this.status,
      wallets: wallets ?? this.wallets,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, wallets, errorMessage];
}
