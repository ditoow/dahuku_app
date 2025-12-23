import 'package:equatable/equatable.dart';

/// Wallet data for transfer
class WalletInfo {
  final String id;
  final String nama;
  final String tipe;
  final double saldo;

  const WalletInfo({
    required this.id,
    required this.nama,
    required this.tipe,
    required this.saldo,
  });

  factory WalletInfo.fromJson(Map<String, dynamic> json) {
    return WalletInfo(
      id: json['id'] as String,
      nama: json['nama'] as String,
      tipe: json['tipe'] as String,
      saldo: (json['saldo'] as num?)?.toDouble() ?? 0,
    );
  }
}

/// State for PindahUang (Transfer Money) feature
class PindahUangState extends Equatable {
  final bool isLoadingWallets;
  final List<WalletInfo> wallets;
  final WalletInfo? sourceWallet;
  final WalletInfo? targetWallet;
  final int amount;
  final bool isLoading;
  final bool isSuccess;
  final String? errorMessage;

  const PindahUangState({
    this.isLoadingWallets = true,
    this.wallets = const [],
    this.sourceWallet,
    this.targetWallet,
    this.amount = 0,
    this.isLoading = false,
    this.isSuccess = false,
    this.errorMessage,
  });

  /// Initial state
  factory PindahUangState.initial() {
    return const PindahUangState();
  }

  /// Get source wallet balance
  double get sourceWalletBalance => sourceWallet?.saldo ?? 0;

  /// Get available target wallets (exclude source)
  List<WalletInfo> get availableTargetWallets {
    if (sourceWallet == null) return wallets;
    return wallets.where((w) => w.id != sourceWallet!.id).toList();
  }

  /// Check if the form is valid for submission
  bool get isValid =>
      sourceWallet != null &&
      targetWallet != null &&
      amount > 0 &&
      amount <= sourceWalletBalance;

  PindahUangState copyWith({
    bool? isLoadingWallets,
    List<WalletInfo>? wallets,
    WalletInfo? sourceWallet,
    WalletInfo? targetWallet,
    bool clearTargetWallet = false,
    int? amount,
    bool? isLoading,
    bool? isSuccess,
    String? errorMessage,
  }) {
    return PindahUangState(
      isLoadingWallets: isLoadingWallets ?? this.isLoadingWallets,
      wallets: wallets ?? this.wallets,
      sourceWallet: sourceWallet ?? this.sourceWallet,
      targetWallet: clearTargetWallet
          ? null
          : (targetWallet ?? this.targetWallet),
      amount: amount ?? this.amount,
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    isLoadingWallets,
    wallets,
    sourceWallet,
    targetWallet,
    amount,
    isLoading,
    isSuccess,
    errorMessage,
  ];
}
