import 'package:equatable/equatable.dart';
import '../../dashboard/data/models/transaction_model.dart';

/// Category expense data for bar chart
class CategoryExpense {
  final String category;
  final double amount;
  final double percentage; // 0.0 - 1.0

  const CategoryExpense({
    required this.category,
    required this.amount,
    required this.percentage,
  });
}

/// Filter type for transactions
enum TransactionFilter { all, expense, income }

/// Analytics page state
class AnalyticsState extends Equatable {
  final bool isLoading;
  final double totalExpenseThisMonth;
  final double remainingBudget;
  final List<CategoryExpense> expensesByCategory;
  final List<TransactionModel> transactions;
  final List<TransactionModel> filteredTransactions;
  final TransactionFilter filter;
  final String searchQuery;
  final String? errorMessage;
  final String? insight;

  const AnalyticsState({
    this.isLoading = true,
    this.totalExpenseThisMonth = 0,
    this.remainingBudget = 0,
    this.expensesByCategory = const [],
    this.transactions = const [],
    this.filteredTransactions = const [],
    this.filter = TransactionFilter.all,
    this.searchQuery = '',
    this.errorMessage,
    this.insight,
  });

  factory AnalyticsState.initial() => const AnalyticsState();

  AnalyticsState copyWith({
    bool? isLoading,
    double? totalExpenseThisMonth,
    double? remainingBudget,
    List<CategoryExpense>? expensesByCategory,
    List<TransactionModel>? transactions,
    List<TransactionModel>? filteredTransactions,
    TransactionFilter? filter,
    String? searchQuery,
    String? errorMessage,
    String? insight,
    bool clearError = false,
  }) {
    return AnalyticsState(
      isLoading: isLoading ?? this.isLoading,
      totalExpenseThisMonth:
          totalExpenseThisMonth ?? this.totalExpenseThisMonth,
      remainingBudget: remainingBudget ?? this.remainingBudget,
      expensesByCategory: expensesByCategory ?? this.expensesByCategory,
      transactions: transactions ?? this.transactions,
      filteredTransactions: filteredTransactions ?? this.filteredTransactions,
      filter: filter ?? this.filter,
      searchQuery: searchQuery ?? this.searchQuery,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      insight: insight ?? this.insight,
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    totalExpenseThisMonth,
    remainingBudget,
    expensesByCategory,
    transactions,
    filteredTransactions,
    filter,
    searchQuery,
    errorMessage,
    insight,
  ];
}
