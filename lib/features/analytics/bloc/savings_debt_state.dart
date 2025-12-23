import 'package:equatable/equatable.dart';
import '../data/models/savings_debt_model.dart';

/// State untuk SavingsDebtBloc
class SavingsDebtState extends Equatable {
  final bool isLoading;
  final bool isSubmitting;
  final List<SavingsGoalModel> savingsGoals;
  final List<DebtModel> debts;
  final String? errorMessage;
  final String? successMessage;

  const SavingsDebtState({
    this.isLoading = false,
    this.isSubmitting = false,
    this.savingsGoals = const [],
    this.debts = const [],
    this.errorMessage,
    this.successMessage,
  });

  factory SavingsDebtState.initial() => const SavingsDebtState();

  /// Total terkumpul dari semua target tabungan
  double get totalSavingsCollected =>
      savingsGoals.fold(0, (sum, goal) => sum + goal.terkumpul);

  /// Total target dari semua tabungan
  double get totalSavingsTarget =>
      savingsGoals.fold(0, (sum, goal) => sum + goal.jumlahTarget);

  /// Total sisa hutang
  double get totalDebtRemaining =>
      debts.fold(0, (sum, debt) => sum + debt.sisaHutang);

  /// Total hutang awal
  double get totalDebtOriginal =>
      debts.fold(0, (sum, debt) => sum + debt.jumlahAwal);

  SavingsDebtState copyWith({
    bool? isLoading,
    bool? isSubmitting,
    List<SavingsGoalModel>? savingsGoals,
    List<DebtModel>? debts,
    String? errorMessage,
    String? successMessage,
    bool clearMessages = false,
  }) {
    return SavingsDebtState(
      isLoading: isLoading ?? this.isLoading,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      savingsGoals: savingsGoals ?? this.savingsGoals,
      debts: debts ?? this.debts,
      errorMessage: clearMessages ? null : (errorMessage ?? this.errorMessage),
      successMessage: clearMessages
          ? null
          : (successMessage ?? this.successMessage),
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    isSubmitting,
    savingsGoals,
    debts,
    errorMessage,
    successMessage,
  ];
}
