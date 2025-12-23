import 'package:equatable/equatable.dart';

/// Events for PindahUang BLoC
abstract class PindahUangEvent extends Equatable {
  const PindahUangEvent();

  @override
  List<Object?> get props => [];
}

/// Load wallets from database
class LoadWallets extends PindahUangEvent {
  final String? initialSourceWalletId;

  const LoadWallets({this.initialSourceWalletId});

  @override
  List<Object?> get props => [initialSourceWalletId];
}

/// Select target wallet for transfer
class SelectTargetWallet extends PindahUangEvent {
  final String walletType; // 'tabungan' or 'darurat'

  const SelectTargetWallet(this.walletType);

  @override
  List<Object?> get props => [walletType];
}

/// Update transfer amount
class UpdateAmount extends PindahUangEvent {
  final int amount;

  const UpdateAmount(this.amount);

  @override
  List<Object?> get props => [amount];
}

/// Submit transfer
class SubmitTransfer extends PindahUangEvent {
  const SubmitTransfer();
}
