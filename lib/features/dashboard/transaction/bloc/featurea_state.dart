import '../data/models/transaction_category.dart';

/// State for the transaction recording feature
class FeatureaState {
  final bool isIncome;
  final int amount;
  final ExpenseCategory? selectedExpenseCategory;
  final IncomeSource? selectedIncomeSource;
  final String note;
  final WalletData selectedWallet;
  final String? selectedWalletId;
  final String? selectedWalletName;
  final bool isLoading;
  final bool isSuccess;
  final String? errorMessage;

  FeatureaState({
    required this.isIncome,
    required this.amount,
    this.selectedExpenseCategory,
    this.selectedIncomeSource,
    this.note = '',
    WalletData? selectedWallet,
    this.selectedWalletId,
    this.selectedWalletName,
    this.isLoading = false,
    this.isSuccess = false,
    this.errorMessage,
  }) : selectedWallet = selectedWallet ?? WalletData.defaultWallet;

  /// Initial state - defaults to expense mode
  factory FeatureaState.initial() {
    return FeatureaState(
      isIncome: false,
      amount: 0,
      selectedExpenseCategory: null,
      selectedIncomeSource: null,
      note: '',
      selectedWallet: WalletData.defaultWallet,
      selectedWalletId: null,
      selectedWalletName: null,
      isLoading: false,
      isSuccess: false,
    );
  }

  /// Check if form is valid for saving
  bool get isValid {
    if (amount <= 0) return false;
    if (selectedWalletId == null || selectedWalletId!.isEmpty) return false;
    if (isIncome) {
      return selectedIncomeSource != null;
    } else {
      return selectedExpenseCategory != null;
    }
  }

  FeatureaState copyWith({
    bool? isIncome,
    int? amount,
    ExpenseCategory? selectedExpenseCategory,
    IncomeSource? selectedIncomeSource,
    String? note,
    WalletData? selectedWallet,
    String? selectedWalletId,
    String? selectedWalletName,
    bool? isLoading,
    bool? isSuccess,
    String? errorMessage,
    bool clearExpenseCategory = false,
    bool clearIncomeSource = false,
    bool clearError = false,
  }) {
    return FeatureaState(
      isIncome: isIncome ?? this.isIncome,
      amount: amount ?? this.amount,
      selectedExpenseCategory: clearExpenseCategory
          ? null
          : (selectedExpenseCategory ?? this.selectedExpenseCategory),
      selectedIncomeSource: clearIncomeSource
          ? null
          : (selectedIncomeSource ?? this.selectedIncomeSource),
      note: note ?? this.note,
      selectedWallet: selectedWallet ?? this.selectedWallet,
      selectedWalletId: selectedWalletId ?? this.selectedWalletId,
      selectedWalletName: selectedWalletName ?? this.selectedWalletName,
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}
