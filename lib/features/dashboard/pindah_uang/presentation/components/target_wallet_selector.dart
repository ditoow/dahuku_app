import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../bloc/pindah_uang_state.dart';

/// Selector for target wallet with radio buttons
class TargetWalletSelector extends StatelessWidget {
  final List<WalletInfo> wallets;
  final String? selectedWalletType;
  final String? sourceWalletType;
  final ValueChanged<WalletInfo> onWalletSelected;

  const TargetWalletSelector({
    super.key,
    required this.wallets,
    required this.selectedWalletType,
    this.sourceWalletType,
    required this.onWalletSelected,
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

  IconData _getWalletIcon(String type) {
    switch (type) {
      case 'tabungan':
        return Icons.savings_outlined;
      case 'darurat':
        return Icons.medical_services_outlined;
      case 'belanja':
      default:
        return Icons.account_balance_wallet_outlined;
    }
  }

  Color _getWalletColor(String type) {
    switch (type) {
      case 'tabungan':
        return Colors.green;
      case 'darurat':
        return const Color(0xFFFF6B6B);
      case 'belanja':
      default:
        return AppColors.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Filter out source wallet
    final targetWallets = wallets
        .where((w) => sourceWalletType == null || w.tipe != sourceWalletType)
        .toList();

    return Column(
      children: targetWallets.map((wallet) {
        final isSelected = selectedWalletType == wallet.tipe;
        final color = _getWalletColor(wallet.tipe);
        final icon = _getWalletIcon(wallet.tipe);

        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: GestureDetector(
            onTap: () => onWalletSelected(wallet),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected
                      ? color.withAlpha(128)
                      : Colors.grey.withAlpha(26),
                  width: isSelected ? 2 : 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(10),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
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
                      color: color.withAlpha(26),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(icon, color: color, size: 24),
                  ),
                  const SizedBox(width: 16),

                  // Wallet info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          wallet.nama,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textMain,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Saldo: ${_formatCurrency(wallet.saldo)}',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textSub,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Radio indicator
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected ? color : AppColors.textLight,
                        width: 2,
                      ),
                    ),
                    child: isSelected
                        ? Center(
                            child: Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: color,
                              ),
                            ),
                          )
                        : null,
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
