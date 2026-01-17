import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../analytics/bloc/analytics_bloc.dart';
import '../../../analytics/bloc/analytics_event.dart';
import '../../../analytics/bloc/analytics_state.dart';
import '../../data/models/transaction_model.dart';
import '../../data/repositories/transaction_repository.dart';
import '../../data/repositories/wallet_repository.dart';

/// Full page to display all transactions with search and filter
class AllTransactionsPage extends StatelessWidget {
  const AllTransactionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AnalyticsBloc(
        transactionRepository: GetIt.I<TransactionRepository>(),
        walletRepository: GetIt.I<WalletRepository>(),
      )..add(LoadAnalytics()),
      child: const _AllTransactionsContent(),
    );
  }
}

class _AllTransactionsContent extends StatelessWidget {
  const _AllTransactionsContent();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPage,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Riwayat Transaksi',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<AnalyticsBloc, AnalyticsState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return Column(
            children: [
              // Search and Filter section
              Container(
                padding: const EdgeInsets.all(16),
                color: Colors.white,
                child: Column(
                  children: [
                    // Search bar
                    TextField(
                      onChanged: (query) {
                        context.read<AnalyticsBloc>().add(
                          SearchTransactions(query),
                        );
                      },
                      decoration: InputDecoration(
                        hintText: 'Cari transaksi...',
                        hintStyle: GoogleFonts.poppins(
                          fontSize: 14,
                          color: const Color(0xFF9E9E9E),
                        ),
                        prefixIcon: const Icon(
                          Icons.search_rounded,
                          color: Color(0xFF9E9E9E),
                          size: 20,
                        ),
                        filled: true,
                        fillColor: const Color(0xFFF5F5F7),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                      ),
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: const Color(0xFF424242),
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Filter buttons
                    Row(
                      children: [
                        _FilterButton(
                          text: 'Semua',
                          isActive: state.filter == TransactionFilter.all,
                          onTap: () => context.read<AnalyticsBloc>().add(
                            FilterTransactions(TransactionFilter.all),
                          ),
                        ),
                        const SizedBox(width: 8),
                        _FilterButton(
                          text: 'Pengeluaran',
                          isActive: state.filter == TransactionFilter.expense,
                          onTap: () => context.read<AnalyticsBloc>().add(
                            FilterTransactions(TransactionFilter.expense),
                          ),
                        ),
                        const SizedBox(width: 8),
                        _FilterButton(
                          text: 'Pemasukan',
                          isActive: state.filter == TransactionFilter.income,
                          onTap: () => context.read<AnalyticsBloc>().add(
                            FilterTransactions(TransactionFilter.income),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Transaction list
              Expanded(
                child: state.filteredTransactions.isEmpty
                    ? _buildEmptyState(state.searchQuery)
                    : RefreshIndicator(
                        onRefresh: () async {
                          context.read<AnalyticsBloc>().add(RefreshAnalytics());
                          await Future.delayed(
                            const Duration(milliseconds: 500),
                          );
                        },
                        child: ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: state.filteredTransactions.length,
                          itemBuilder: (context, index) {
                            final transaction =
                                state.filteredTransactions[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: _TransactionCard(transaction: transaction),
                            );
                          },
                        ),
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(String searchQuery) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.receipt_long_outlined,
            size: 64,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            searchQuery.isNotEmpty
                ? 'Tidak ada transaksi ditemukan'
                : 'Belum ada transaksi',
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterButton extends StatelessWidget {
  final String text;
  final bool isActive;
  final VoidCallback onTap;

  const _FilterButton({
    required this.text,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: isActive ? null : Border.all(color: const Color(0xFFE5E7EB)),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: AppColors.primary.withAlpha(77),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Text(
          text,
          style: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: isActive ? Colors.white : const Color(0xFF6B7280),
          ),
        ),
      ),
    );
  }
}

class _TransactionCard extends StatelessWidget {
  final TransactionModel transaction;

  const _TransactionCard({required this.transaction});

  @override
  Widget build(BuildContext context) {
    final isIncome = transaction.type == TransactionType.income;
    final icon = _getTransactionIcon(transaction.title);
    final color = isIncome ? Colors.green : Colors.red;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(13),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color.withAlpha(26),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.title,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      _formatDate(transaction.transactionDate),
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        color: const Color(0xFFBDBDBD),
                      ),
                    ),
                    if (transaction.description != null &&
                        transaction.description!.isNotEmpty) ...[
                      Text(
                        ' • ',
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          color: const Color(0xFFBDBDBD),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          transaction.description!,
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            color: const Color(0xFFBDBDBD),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          Text(
            '${isIncome ? '+' : '-'}Rp ${_formatNumber(transaction.amount.toInt().abs())}',
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: isIncome
                  ? const Color(0xFF00BFA6)
                  : const Color(0xFFFF5252),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getTransactionIcon(String title) {
    final lowerTitle = title.toLowerCase();
    if (lowerTitle.contains('makan') || lowerTitle.contains('resto')) {
      return Icons.restaurant;
    } else if (lowerTitle.contains('belanja') || lowerTitle.contains('shop')) {
      return Icons.shopping_cart;
    } else if (lowerTitle.contains('transport') ||
        lowerTitle.contains('bensin')) {
      return Icons.directions_car;
    } else if (lowerTitle.contains('gaji') || lowerTitle.contains('salary')) {
      return Icons.payments;
    } else if (lowerTitle.contains('transfer')) {
      return Icons.swap_horiz;
    } else {
      return Icons.receipt;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inDays == 0) {
      return 'Hari ini, ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } else if (diff.inDays == 1) {
      return 'Kemarin';
    } else if (diff.inDays < 7) {
      return '${diff.inDays} hari lalu';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  String _formatNumber(int number) {
    return number.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    );
  }
}
