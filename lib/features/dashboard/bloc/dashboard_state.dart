import 'package:equatable/equatable.dart';
import '../data/models/wallet_model.dart';
import '../data/models/transaction_model.dart';
import '../data/models/dashboard_summary.dart';

/// Dashboard state status
enum DashboardStatus { initial, loading, success, failure }

/// Dashboard state
class DashboardState extends Equatable {
  final DashboardStatus status;
  final List<WalletModel> wallets;
  final List<TransactionModel> recentTransactions;
  final DashboardSummary summary;
  final String? errorMessage;

  const DashboardState({
    this.status = DashboardStatus.initial,
    this.wallets = const [],
    this.recentTransactions = const [],
    this.summary = const DashboardSummary(
      totalBalance: 0,
      weeklyExpense: 0,
      monthlyBudget: 0,
      monthlySpent: 0,
    ),
    this.errorMessage,
  });

  /// Total balance across all wallets
  double get totalBalance => wallets.fold(0.0, (sum, w) => sum + w.balance);

  /// Primary wallet (Belanja)
  WalletModel? get primaryWallet =>
      wallets.where((w) => w.isPrimary).firstOrNull;

  DashboardState copyWith({
    DashboardStatus? status,
    List<WalletModel>? wallets,
    List<TransactionModel>? recentTransactions,
    DashboardSummary? summary,
    String? errorMessage,
  }) {
    return DashboardState(
      status: status ?? this.status,
      wallets: wallets ?? this.wallets,
      recentTransactions: recentTransactions ?? this.recentTransactions,
      summary: summary ?? this.summary,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    wallets,
    recentTransactions,
    summary,
    errorMessage,
  ];
}
