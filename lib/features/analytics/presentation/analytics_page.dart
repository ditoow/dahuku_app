import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import 'components/analytics_background.dart';
import 'components/analytics_header.dart';
import 'components/expense_summary_section.dart';
import 'components/savings_goals_section.dart';
import 'components/debt_management_section.dart';
import 'components/transaction_history_section.dart';

/// Analytics page - refactored to use const Column pattern
///
/// Features:
/// - Pull-to-refresh for data reload
/// - Smooth scroll with physics
/// - Modular component-based architecture
class AnalyticsPage extends StatelessWidget {
  const AnalyticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPage,
      body: Stack(
        children: [
          // Header gradient background
          const AnalyticsBackground(),

          // Main content
          SafeArea(
            child: RefreshIndicator(
              onRefresh: _onRefresh,
              color: AppColors.primary,
              backgroundColor: AppColors.cardWhite,
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
                ),
                slivers: [
                  // Header
                  const SliverToBoxAdapter(child: AnalyticsHeader()),

                  // Main content sections
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        // Total Pengeluaran Section
                        const ExpenseSummarySection(),

                        // Target Tabungan Section
                        const SavingsGoalsSection(),

                        // Manajemen Hutang Section
                        const DebtManagementSection(),

                        // Riwayat Transaksi Section
                        const TransactionHistorySection(),

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
      ),
    );
  }

  /// Handle pull-to-refresh
  /// TODO: Connect to AnalyticsBloc when implemented
  Future<void> _onRefresh() async {
    // Simulate refresh delay
    await Future.delayed(const Duration(milliseconds: 500));
    // When AnalyticsBloc is implemented:
    // context.read<AnalyticsBloc>().add(AnalyticsRefreshRequested());
  }
}
