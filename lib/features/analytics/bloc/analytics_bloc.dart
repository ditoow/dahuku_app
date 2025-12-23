import 'package:flutter_bloc/flutter_bloc.dart';
import '../../dashboard/data/models/transaction_model.dart';
import '../../dashboard/data/repositories/transaction_repository.dart';
import '../../dashboard/data/repositories/wallet_repository.dart';
import 'analytics_event.dart';
import 'analytics_state.dart';

class AnalyticsBloc extends Bloc<AnalyticsEvent, AnalyticsState> {
  final TransactionRepository _transactionRepository;
  final WalletRepository _walletRepository;

  AnalyticsBloc({
    required TransactionRepository transactionRepository,
    required WalletRepository walletRepository,
  }) : _transactionRepository = transactionRepository,
       _walletRepository = walletRepository,
       super(AnalyticsState.initial()) {
    on<LoadAnalytics>(_onLoadAnalytics);
    on<RefreshAnalytics>(_onRefreshAnalytics);
    on<FilterTransactions>(_onFilterTransactions);
    on<SearchTransactions>(_onSearchTransactions);
  }

  Future<void> _onLoadAnalytics(
    LoadAnalytics event,
    Emitter<AnalyticsState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, clearError: true));

    try {
      // Get all transactions for this month
      final now = DateTime.now();
      final startOfMonth = DateTime(now.year, now.month, 1);
      final endOfMonth = DateTime(now.year, now.month + 1, 0);

      final transactions = await _transactionRepository.getTransactions(
        startDate: startOfMonth,
        endDate: endOfMonth,
      );

      // Calculate expense summary
      final expenses = transactions.where(
        (t) => t.type == TransactionType.expense,
      );
      final totalExpense = expenses.fold<double>(0, (sum, t) => sum + t.amount);

      // Get primary wallet balance for remaining budget
      final wallets = await _walletRepository.getWallets();
      final primaryWallet = wallets.isNotEmpty
          ? wallets.firstWhere((w) => w.isPrimary, orElse: () => wallets.first)
          : null;
      final remainingBudget = primaryWallet?.balance ?? 0;

      // Group by category for bar chart
      final categoryTotals = <String, double>{};
      for (final t in expenses) {
        final category = t.title;
        categoryTotals[category] = (categoryTotals[category] ?? 0) + t.amount;
      }

      // Find max for percentage calculation
      final maxAmount = categoryTotals.values.isEmpty
          ? 1.0
          : categoryTotals.values.reduce((a, b) => a > b ? a : b);

      // Convert to CategoryExpense list (top 5)
      final sortedCategories = categoryTotals.entries.toList()
        ..sort((a, b) => b.value.compareTo(a.value));

      final topCategories = sortedCategories.take(5).map((e) {
        return CategoryExpense(
          category: _shortenCategory(e.key),
          amount: e.value,
          percentage: e.value / maxAmount,
        );
      }).toList();

      // Generate insight
      String? insight;
      if (sortedCategories.isNotEmpty) {
        final topCategory = sortedCategories.first;
        insight =
            'Insight: Pengeluaran terbesar bulan ini adalah ${topCategory.key} sebesar Rp ${_formatNumber(topCategory.value.toInt())}.';
      }

      emit(
        state.copyWith(
          isLoading: false,
          totalExpenseThisMonth: totalExpense,
          remainingBudget: remainingBudget,
          expensesByCategory: topCategories,
          transactions: transactions,
          filteredTransactions: transactions,
          insight: insight,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(isLoading: false, errorMessage: 'Gagal memuat data: $e'),
      );
    }
  }

  Future<void> _onRefreshAnalytics(
    RefreshAnalytics event,
    Emitter<AnalyticsState> emit,
  ) async {
    // Same as load but keep showing existing data while loading
    try {
      final now = DateTime.now();
      final startOfMonth = DateTime(now.year, now.month, 1);
      final endOfMonth = DateTime(now.year, now.month + 1, 0);

      final transactions = await _transactionRepository.getTransactions(
        startDate: startOfMonth,
        endDate: endOfMonth,
      );

      final expenses = transactions.where(
        (t) => t.type == TransactionType.expense,
      );
      final totalExpense = expenses.fold<double>(0, (sum, t) => sum + t.amount);

      final wallets = await _walletRepository.getWallets();
      final primaryWallet = wallets.isNotEmpty
          ? wallets.firstWhere((w) => w.isPrimary, orElse: () => wallets.first)
          : null;

      final categoryTotals = <String, double>{};
      for (final t in expenses) {
        categoryTotals[t.title] = (categoryTotals[t.title] ?? 0) + t.amount;
      }

      final maxAmount = categoryTotals.values.isEmpty
          ? 1.0
          : categoryTotals.values.reduce((a, b) => a > b ? a : b);

      final sortedCategories = categoryTotals.entries.toList()
        ..sort((a, b) => b.value.compareTo(a.value));

      final topCategories = sortedCategories.take(5).map((e) {
        return CategoryExpense(
          category: _shortenCategory(e.key),
          amount: e.value,
          percentage: e.value / maxAmount,
        );
      }).toList();

      emit(
        state.copyWith(
          totalExpenseThisMonth: totalExpense,
          remainingBudget: primaryWallet?.balance ?? 0,
          expensesByCategory: topCategories,
          transactions: transactions,
          filteredTransactions: _applyFilters(
            transactions,
            state.filter,
            state.searchQuery,
          ),
        ),
      );
    } catch (e) {
      // Silently fail on refresh, data already shown
    }
  }

  void _onFilterTransactions(
    FilterTransactions event,
    Emitter<AnalyticsState> emit,
  ) {
    final filtered = _applyFilters(
      state.transactions,
      event.filter,
      state.searchQuery,
    );
    emit(state.copyWith(filter: event.filter, filteredTransactions: filtered));
  }

  void _onSearchTransactions(
    SearchTransactions event,
    Emitter<AnalyticsState> emit,
  ) {
    final filtered = _applyFilters(
      state.transactions,
      state.filter,
      event.query,
    );
    emit(
      state.copyWith(searchQuery: event.query, filteredTransactions: filtered),
    );
  }

  List<TransactionModel> _applyFilters(
    List<TransactionModel> transactions,
    TransactionFilter filter,
    String query,
  ) {
    var result = transactions;

    // Apply type filter
    switch (filter) {
      case TransactionFilter.expense:
        result = result
            .where((t) => t.type == TransactionType.expense)
            .toList();
        break;
      case TransactionFilter.income:
        result = result.where((t) => t.type == TransactionType.income).toList();
        break;
      case TransactionFilter.all:
        break;
    }

    // Apply search
    if (query.isNotEmpty) {
      final lowerQuery = query.toLowerCase();
      result = result.where((t) {
        return t.title.toLowerCase().contains(lowerQuery) ||
            (t.description?.toLowerCase().contains(lowerQuery) ?? false);
      }).toList();
    }

    return result;
  }

  String _shortenCategory(String category) {
    if (category.length <= 8) return category;
    return '${category.substring(0, 6)}..';
  }

  String _formatNumber(int number) {
    return number.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    );
  }
}
