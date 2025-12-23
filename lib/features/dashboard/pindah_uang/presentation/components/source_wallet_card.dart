import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';

/// Source wallet card showing "Dari Dompet" with locked icon
class SourceWalletCard extends StatelessWidget {
  final String walletName;
  final double balance;
  final String? walletType;

  const SourceWalletCard({
    super.key,
    required this.walletName,
    required this.balance,
    this.walletType,
  });

  String _formatCurrency(double amount) {
    final formatted = amount
        .toStringAsFixed(0)
        .replaceAllMapped(
          RegExp(r'(\\d{1,3})(?=(\\d{3})+(?!\\d))'),
          (Match m) => '${m[1]}.',
        );
    return 'Rp $formatted';
  }

  IconData _getWalletIcon() {
    switch (walletType) {
      case 'tabungan':
        return Icons.savings_outlined;
      case 'darurat':
        return Icons.security_outlined;
      case 'belanja':
      default:
        return Icons.account_balance_wallet_outlined;
    }
  }

  Color _getWalletColor() {
    switch (walletType) {
      case 'tabungan':
        return AppColors.walletSaving;
      case 'darurat':
        return AppColors.walletEmergency;
      case 'belanja':
      default:
        return AppColors.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final walletColor = _getWalletColor();
    final walletIcon = _getWalletIcon();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: walletColor.withAlpha(51), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: walletColor.withAlpha(20),
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
              color: walletColor.withAlpha(26),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(walletIcon, color: walletColor, size: 24),
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
