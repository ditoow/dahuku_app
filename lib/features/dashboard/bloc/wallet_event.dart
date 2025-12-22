import 'package:equatable/equatable.dart';
import '../data/models/wallet_model.dart';

/// Wallet events
abstract class WalletEvent extends Equatable {
  const WalletEvent();

  @override
  List<Object?> get props => [];
}

/// Load all wallets
class WalletLoadRequested extends WalletEvent {
  const WalletLoadRequested();
}

/// Create new wallet
class WalletCreateRequested extends WalletEvent {
  final String name;
  final WalletType type;
  final double balance;
  final bool isPrimary;
  final String? iconName;
  final String? colorHex;

  const WalletCreateRequested({
    required this.name,
    required this.type,
    this.balance = 0,
    this.isPrimary = false,
    this.iconName,
    this.colorHex,
  });

  @override
  List<Object?> get props => [
    name,
    type,
    balance,
    isPrimary,
    iconName,
    colorHex,
  ];
}

/// Update wallet
class WalletUpdateRequested extends WalletEvent {
  final WalletModel wallet;

  const WalletUpdateRequested(this.wallet);

  @override
  List<Object?> get props => [wallet];
}

/// Delete wallet
class WalletDeleteRequested extends WalletEvent {
  final String id;

  const WalletDeleteRequested(this.id);

  @override
  List<Object?> get props => [id];
}
