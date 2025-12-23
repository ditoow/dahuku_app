import '../data/models/transaction_category.dart';

/// Base class for all transaction feature events
abstract class FeatureaEvent {}

/// Load wallets from database
class LoadWallets extends FeatureaEvent {
  final String? preselectedWalletId;
  final bool? forceIncomeMode;

  LoadWallets({this.preselectedWalletId, this.forceIncomeMode});
}

/// Toggle between income and expense mode
class ToggleTransactionType extends FeatureaEvent {
  final bool isIncome;
  ToggleTransactionType(this.isIncome);
}

/// Update the transaction amount
class UpdateAmount extends FeatureaEvent {
  final int amount;
  UpdateAmount(this.amount);
}

/// Select an expense category
class SelectExpenseCategory extends FeatureaEvent {
  final ExpenseCategory category;
  SelectExpenseCategory(this.category);
}

/// Select an income source
class SelectIncomeSource extends FeatureaEvent {
  final IncomeSource source;
  SelectIncomeSource(this.source);
}

/// Update the transaction note
class UpdateNote extends FeatureaEvent {
  final String note;
  UpdateNote(this.note);
}

/// Select a wallet
class SelectWallet extends FeatureaEvent {
  final WalletData wallet;
  SelectWallet(this.wallet);
}

/// Save the transaction
class SaveTransaction extends FeatureaEvent {}

/// Select wallet by ID
class SelectWalletById extends FeatureaEvent {
  final String walletId;
  final String walletName;
  SelectWalletById({required this.walletId, required this.walletName});
}

/// Reset the form to initial state
class ResetForm extends FeatureaEvent {}
