import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

/// Quick summary section with expense and remaining budget cards
class QuickSummarySection extends StatelessWidget {
  final double weeklyExpense;
  final double remainingBudgetPercent;
  final VoidCallback? onViewAll;

  const QuickSummarySection({
    super.key,
    required this.weeklyExpense,
    required this.remainingBudgetPercent,
    this.onViewAll,
  });

  String _formatCompactCurrency(double amount) {
    if (amount >= 1000000) {
      return 'Rp ${(amount / 1000000).toStringAsFixed(1)}jt';
    } else if (amount >= 1000) {
      return 'Rp ${(amount / 1000).toStringAsFixed(0)}rb';
    }
    return 'Rp ${amount.toStringAsFixed(0)}';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          // Header row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Ringkasan Cepat',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textMain,
                ),
              ),
              GestureDetector(
                onTap: onViewAll,
                child: const Text(
                  'Lihat Semua',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Summary cards row
          Row(
            children: [
              // Expense card
              Expanded(
                child: _SummaryCard(
                  icon: Icons.arrow_upward_rounded,
                  iconColor: AppColors.accentPurple,
                  iconBgColor: AppColors.accentPurple.withOpacity(0.15),
                  label: 'Pengeluaran',
                  value: _formatCompactCurrency(weeklyExpense),
                  subtitle: 'Minggu ini',
                ),
              ),
              const SizedBox(width: 12),

              // Remaining budget card
              Expanded(
                child: _SummaryCard(
                  icon: Icons.account_balance_wallet_outlined,
                  iconColor: AppColors.success,
                  iconBgColor: AppColors.success.withOpacity(0.15),
                  label: 'Sisa Belanja',
                  value: '${remainingBudgetPercent.toStringAsFixed(0)}%',
                  subtitle: null,
                  showProgress: true,
                  progressValue: remainingBudgetPercent / 100,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Individual summary card widget
class _SummaryCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBgColor;
  final String label;
  final String value;
  final String? subtitle;
  final bool showProgress;
  final double? progressValue;

  const _SummaryCard({
    required this.icon,
    required this.iconColor,
    required this.iconBgColor,
    required this.label,
    required this.value,
    this.subtitle,
    this.showProgress = false,
    this.progressValue,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon & Label row
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: iconBgColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: iconColor, size: 18),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSub,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Value
          Text(
            value,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: AppColors.textMain,
            ),
          ),

          // Subtitle or Progress
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(
              subtitle!,
              style: TextStyle(
                fontSize: 11,
                color: AppColors.textLight,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],

          if (showProgress && progressValue != null) ...[
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progressValue!,
                backgroundColor: Colors.grey.shade200,
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                minHeight: 6,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
