import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';

/// Source wallet card showing "Dari Dompet" with locked icon
class SourceWalletCard extends StatelessWidget {
  final String walletName;
  final double balance;

  const SourceWalletCard({
    super.key,
    required this.walletName,
    required this.balance,
  });

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
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.primary.withOpacity(0.2),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Wallet icon
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.account_balance_wallet_outlined,
              color: AppColors.primary,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),

          // Wallet info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  walletName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textMain,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Saldo: ${_formatCurrency(balance)}',
                  style: TextStyle(fontSize: 14, color: AppColors.textSub),
                ),
              ],
            ),
          ),

          // Lock icon (indicating this is fixed source)
          Icon(Icons.lock_outline, color: AppColors.textLight, size: 20),
        ],
      ),
    );
  }
}
