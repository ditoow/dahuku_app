import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../bloc/dashboard_bloc.dart';
import '../../bloc/dashboard_state.dart';
import '../../data/models/transaction_model.dart' as data_models;

/// Transaction type
enum TransactionType { income, expense }

/// Transaction data model
class TransactionData {
  final String id;
  final String title;
  final String subtitle;
  final double amount;
  final TransactionType type;
  final IconData icon;
  final Color iconBgColor;
  final Color iconColor;

  const TransactionData({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.type,
    required this.icon,
    required this.iconBgColor,
    required this.iconColor,
  });
}

/// Recent transactions section matching HTML mockup (smart component)
class RecentTransactionsSection extends StatelessWidget {
  const RecentTransactionsSection({super.key});

  /// Convert TransactionModel to TransactionData for UI
  List<TransactionData> _convertTransactions(
    List<data_models.TransactionModel> models,
  ) {
    if (models.isEmpty) {
      return [];
    }

    return models.map((t) {
      TransactionType uiType;
      IconData icon;
      Color iconBgColor;
      Color iconColor;

      switch (t.type) {
        case data_models.TransactionType.income:
          uiType = TransactionType.income;
          icon = Icons.arrow_downward;
          iconBgColor = Colors.green.shade50;
          iconColor = Colors.green.shade600;
          break;
        case data_models.TransactionType.expense:
          uiType = TransactionType.expense;
          icon = Icons.arrow_upward;
          iconBgColor = Colors.red.shade50;
          iconColor = Colors.red.shade500;
          break;
        case data_models.TransactionType.transfer:
          uiType = TransactionType.expense;
          icon = Icons.swap_horiz;
          iconBgColor = Colors.blue.shade50;
          iconColor = Colors.blue.shade500;
          break;
      }

      return TransactionData(
        id: t.id,
        title: t.title,
        subtitle: _formatDate(t.transactionDate),
        amount: t.amount,
        type: uiType,
        icon: icon,
        iconBgColor: iconBgColor,
        iconColor: iconColor,
      );
    }).toList();
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date).inDays;

    if (diff == 0) return 'Hari ini';
    if (diff == 1) return 'Kemarin';
    if (diff < 7) return '$diff hari lalu';

    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardBloc, DashboardState>(
      builder: (context, state) {
        final transactions = _convertTransactions(state.recentTransactions);

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              // Section header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Transaksi Terakhir',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textMain,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      // Navigate to all transactions
                    },
                    child: Text(
                      'Lihat Semua',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Transaction list
              if (transactions.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Text(
                    'Belum ada transaksi',
                    style: TextStyle(color: Colors.grey),
                  ),
                )
              else
                ...transactions.map((tx) => _TransactionItem(transaction: tx)),
            ],
          ),
        );
      },
    );
  }
}

/// Transaction list item
class _TransactionItem extends StatelessWidget {
  final TransactionData transaction;

  const _TransactionItem({required this.transaction});

  String _formatCurrency(double amount) {
    final formatted = amount
        .toStringAsFixed(0)
        .replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]}.',
        );
    return 'Rp $formatted';
  }

  @override
  Widget build(BuildContext context) {
    final isIncome = transaction.type == TransactionType.income;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          // Icon container
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: transaction.iconBgColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              transaction.icon,
              color: transaction.iconColor,
              size: 22,
            ),
          ),
          const SizedBox(width: 16),

          // Title and subtitle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textMain,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  transaction.subtitle,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade400),
                ),
              ],
            ),
          ),

          // Amount
          Text(
            '${isIncome ? '+' : '-'}${_formatCurrency(transaction.amount)}',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: isIncome ? Colors.green.shade600 : AppColors.textMain,
            ),
          ),
        ],
      ),
    );
  }
}
