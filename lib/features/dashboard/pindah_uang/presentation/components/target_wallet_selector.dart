import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';

/// Target wallet data model
class TargetWallet {
  final String type;
  final String name;
  final double balance;
  final IconData icon;
  final Color color;

  const TargetWallet({
    required this.type,
    required this.name,
    required this.balance,
    required this.icon,
    required this.color,
  });
}

/// Selector for target wallet with radio buttons
class TargetWalletSelector extends StatelessWidget {
  final String? selectedWalletType;
  final ValueChanged<String> onWalletSelected;

  const TargetWalletSelector({
    super.key,
    required this.selectedWalletType,
    required this.onWalletSelected,
  });

  // Available target wallets
  static const List<TargetWallet> _wallets = [
    TargetWallet(
      type: 'tabungan',
      name: 'Tabungan',
      balance: 15500000,
      icon: Icons.savings_outlined,
      color: AppColors.accentPurple,
    ),
    TargetWallet(
      type: 'darurat',
      name: 'Darurat',
      balance: 5000000,
      icon: Icons.medical_services_outlined,
      color: Color(0xFFFF6B6B),
    ),
  ];

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
    return Column(
      children: _wallets.map((wallet) {
        final isSelected = selectedWalletType == wallet.type;
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: GestureDetector(
            onTap: () => onWalletSelected(wallet.type),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected
                      ? wallet.color.withOpacity(0.5)
                      : Colors.grey.withOpacity(0.1),
                  width: isSelected ? 2 : 1,
                ),
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
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: wallet.color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(wallet.icon, color: wallet.color, size: 24),
                  ),
                  const SizedBox(width: 16),

                  // Wallet info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          wallet.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textMain,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Saldo: ${_formatCurrency(wallet.balance)}',
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
                        color: isSelected ? wallet.color : AppColors.textLight,
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
                                color: wallet.color,
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
