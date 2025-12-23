import 'package:equatable/equatable.dart';

/// State for PindahUang (Transfer Money) feature
class PindahUangState extends Equatable {
  final String sourceWalletType;
  final double sourceWalletBalance;
  final String? selectedTargetWalletType;
  final int amount;
  final bool isLoading;
  final bool isSuccess;
  final String? errorMessage;

  const PindahUangState({
    required this.sourceWalletType,
    required this.sourceWalletBalance,
    this.selectedTargetWalletType,
    this.amount = 0,
    this.isLoading = false,
    this.isSuccess = false,
    this.errorMessage,
  });

  /// Initial state with Dompet Belanja as source
  factory PindahUangState.initial() {
    return const PindahUangState(
      sourceWalletType: 'belanja',
      sourceWalletBalance: 2150000,
    );
  }

  /// Check if the form is valid for submission
  bool get isValid =>
      selectedTargetWalletType != null &&
      amount > 0 &&
      amount <= sourceWalletBalance;

  PindahUangState copyWith({
    String? sourceWalletType,
    double? sourceWalletBalance,
    String? selectedTargetWalletType,
    int? amount,
    bool? isLoading,
    bool? isSuccess,
    String? errorMessage,
  }) {
    return PindahUangState(
      sourceWalletType: sourceWalletType ?? this.sourceWalletType,
      sourceWalletBalance: sourceWalletBalance ?? this.sourceWalletBalance,
      selectedTargetWalletType:
          selectedTargetWalletType ?? this.selectedTargetWalletType,
      amount: amount ?? this.amount,
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    sourceWalletType,
    sourceWalletBalance,
    selectedTargetWalletType,
    amount,
    isLoading,
    isSuccess,
    errorMessage,
  ];
}
