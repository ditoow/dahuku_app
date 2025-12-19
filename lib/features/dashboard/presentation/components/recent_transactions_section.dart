import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

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

/// Recent transactions section matching HTML mockup
class RecentTransactionsSection extends StatelessWidget {
  final List<TransactionData> transactions;
  final VoidCallback? onViewAll;

  const RecentTransactionsSection({
    super.key,
    required this.transactions,
    this.onViewAll,
  });

  @override
  Widget build(BuildContext context) {
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
                onTap: onViewAll,
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
          ...transactions.map((tx) => _TransactionItem(transaction: tx)),
        ],
      ),
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
