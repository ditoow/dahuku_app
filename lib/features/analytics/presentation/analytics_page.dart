import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../../core/constants/app_colors.dart';
import '../bloc/analytics_bloc.dart';
import '../bloc/analytics_event.dart';
import '../bloc/analytics_state.dart';
import '../bloc/savings_debt_bloc.dart';
import '../bloc/savings_debt_event.dart';
import '../bloc/savings_debt_state.dart';
import '../../dashboard/bloc/dashboard_bloc.dart';
import '../../dashboard/bloc/dashboard_event.dart';
import 'components/analytics_background.dart';
import 'components/analytics_header.dart';
import 'components/expense_summary_section.dart';
import 'components/savings_goals_section.dart';
import 'components/debt_management_section.dart';
import 'components/transaction_history_section.dart';

/// Analytics page - integrated with AnalyticsBloc and SavingsDebtBloc
class AnalyticsPage extends StatelessWidget {
  const AnalyticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => GetIt.I<AnalyticsBloc>()..add(LoadAnalytics()),
        ),
        BlocProvider(
          create: (_) =>
              GetIt.I<SavingsDebtBloc>()..add(const LoadSavingsDebt()),
        ),
      ],
      child: const _AnalyticsPageContent(),
    );
  }
}

class _AnalyticsPageContent extends StatelessWidget {
  const _AnalyticsPageContent();

  @override
  Widget build(BuildContext context) {
    return BlocListener<SavingsDebtBloc, SavingsDebtState>(
      listener: (context, state) {
        // Show success message
        if (state.successMessage != null) {
          context.read<DashboardBloc>().add(const DashboardRefreshRequested());

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.successMessage!),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 2),
            ),
          );
        }
        // Show error message
        if (state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage!),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 3),
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.bgPage,
        body: BlocBuilder<AnalyticsBloc, AnalyticsState>(
          builder: (context, state) {
            return Stack(
              children: [
                // Header gradient background
                const AnalyticsBackground(),

                // Main content
                SafeArea(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      context.read<AnalyticsBloc>().add(RefreshAnalytics());
                      context.read<SavingsDebtBloc>().add(
                        const RefreshSavingsDebt(),
                      );
                      await Future.delayed(const Duration(milliseconds: 500));
                    },
                    color: AppColors.primary,
                    backgroundColor: AppColors.cardWhite,
                    child: state.isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : CustomScrollView(
                            physics: const BouncingScrollPhysics(
                              parent: AlwaysScrollableScrollPhysics(),
                            ),
                            slivers: [
                              // Header
                              const SliverToBoxAdapter(
                                child: AnalyticsHeader(),
                              ),

                              // Main content sections
                              SliverPadding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                ),
                                sliver: SliverList(
                                  delegate: SliverChildListDelegate([
                                    // Total Pengeluaran Section
                                    ExpenseSummarySection(
                                      totalExpense: state.totalExpenseThisMonth,
                                      remainingBudget: state.remainingBudget,
                                      expensesByCategory:
                                          state.expensesByCategory,
                                      insight: state.insight,
                                    ),

                                    // Target Tabungan Section
                                    const SavingsGoalsSection(),

                                    // Manajemen Hutang Section
                                    const DebtManagementSection(),

                                    // Riwayat Transaksi Section
                                    TransactionHistorySection(
                                      transactions: state.filteredTransactions,
                                      currentFilter: state.filter,
                                      searchQuery: state.searchQuery,
                                      onFilterChanged: (filter) {
                                        context.read<AnalyticsBloc>().add(
                                          FilterTransactions(filter),
                                        );
                                      },
                                      onSearchChanged: (query) {
                                        context.read<AnalyticsBloc>().add(
                                          SearchTransactions(query),
                                        );
                                      },
                                    ),

                                    // Space for bottom nav
                                    const SizedBox(height: 100),
                                  ]),
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
