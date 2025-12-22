import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../data/models/transaction_category.dart';

/// Widget for selecting/displaying wallet source or destination
class WalletSelector extends StatelessWidget {
  final bool isIncome;
  final WalletData wallet;
  final VoidCallback? onTap;

  const WalletSelector({
    super.key,
    required this.isIncome,
    required this.wallet,
    this.onTap,
  });

  String _formatCurrency(double amount) {
    return 'Rp ${amount.toStringAsFixed(0).replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (m) => '${m[1]}.',
        )}';
  }

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
      child: Row(
        children: [
          // Wallet icon
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Icons.account_balance_wallet,
              color: AppColors.primary,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),

          // Wallet info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isIncome ? 'Masuk ke dompet' : 'DARI DOMPET',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSub,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 2),
                if (isIncome) ...[
                  Text(
                    'Dompet ${wallet.name}',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textMain,
                    ),
                  ),
                  Text(
                    _formatCurrency(wallet.balance),
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSub,
                    ),
                  ),
                ] else ...[
                  Row(
                    children: [
                      Text(
                        wallet.name,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textMain,
                        ),
                      ),
                      Text(
                        ' — ${_formatCurrency(wallet.balance)}',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textSub,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),

          // Action icon
          Icon(
            isIncome ? Icons.keyboard_arrow_down : Icons.lock_outline,
            color: AppColors.textLight,
            size: 24,
          ),
        ],
      ),
    );
  }
}
