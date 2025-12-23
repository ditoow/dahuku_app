import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/constants/app_text_styles.dart';

/// Wallet balance inputs section - manages its own controllers
class WalletBalanceInputsSection extends StatefulWidget {
  const WalletBalanceInputsSection({super.key});

  @override
  State<WalletBalanceInputsSection> createState() =>
      WalletBalanceInputsSectionState();
}

class WalletBalanceInputsSectionState
    extends State<WalletBalanceInputsSection> {
  final _belanjController = TextEditingController();
  final _tabunganController = TextEditingController();
  final _daruratController = TextEditingController();

  @override
  void dispose() {
    _belanjController.dispose();
    _tabunganController.dispose();
    _daruratController.dispose();
    super.dispose();
  }

  /// Get wallet values
  double get belanjaValue =>
      double.tryParse(
        _belanjController.text.replaceAll(RegExp(r'[^0-9]'), ''),
      ) ??
      0;
  double get tabunganValue =>
      double.tryParse(
        _tabunganController.text.replaceAll(RegExp(r'[^0-9]'), ''),
      ) ??
      0;
  double get daruratValue =>
      double.tryParse(
        _daruratController.text.replaceAll(RegExp(r'[^0-9]'), ''),
      ) ??
      0;

  /// Check if at least one wallet has value
  bool get hasValue =>
      _belanjController.text.isNotEmpty ||
      _tabunganController.text.isNotEmpty ||
      _daruratController.text.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildWalletInput(
          label: 'Dompet Belanja',
          icon: Icons.shopping_bag_outlined,
          iconColor: AppColors.walletShopping,
          controller: _belanjController,
        ),
        const SizedBox(height: 12),
        _buildWalletInput(
          label: 'Dompet Tabungan',
          icon: Icons.savings_outlined,
          iconColor: AppColors.walletSaving,
          controller: _tabunganController,
        ),
        const SizedBox(height: 12),
        _buildWalletInput(
          label: 'Dompet Darurat',
          icon: Icons.security_outlined,
          iconColor: AppColors.walletEmergency,
          controller: _daruratController,
        ),
      ],
    );
  }

  Widget _buildWalletInput({
    required String label,
    required IconData icon,
    required Color iconColor,
    required TextEditingController controller,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.textSub,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      'Rp ',
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textMain,
                      ),
                    ),
                    Expanded(
                      child: TextField(
                        controller: controller,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        onChanged: (_) => setState(() {}),
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        decoration: InputDecoration(
                          hintText: '0',
                          hintStyle: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.textSub.withValues(alpha: 0.5),
                          ),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 8,
                            horizontal: 12,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
