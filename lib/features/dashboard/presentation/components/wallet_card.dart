import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

/// Wallet type enum
enum WalletType { belanja, tabungan, darurat }

/// Wallet card model
class WalletData {
  final WalletType type;
  final String name;
  final double balance;
  final bool isPrimary;

  const WalletData({
    required this.type,
    required this.name,
    required this.balance,
    this.isPrimary = false,
  });
}

/// Dompetku section with horizontal scrollable wallet cards
class WalletCardsSection extends StatelessWidget {
  final List<WalletData> wallets;
  final ValueChanged<WalletData>? onWalletTap;
  final VoidCallback? onViewAll;

  const WalletCardsSection({
    super.key,
    required this.wallets,
    this.onWalletTap,
    this.onViewAll,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Section header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Dompetku',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textMain,
                ),
              ),
              GestureDetector(
                onTap: onViewAll,
                child: Text(
                  'SEMUA',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Cards horizontal scroll
        SizedBox(
          height: 180, // Increased for shadow space
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            clipBehavior: Clip.none, // Prevent shadow clipping
            padding: const EdgeInsets.only(left: 24, right: 24, bottom: 16),
            itemCount: wallets.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.only(
                  right: index < wallets.length - 1 ? 16 : 0,
                ),
                child: _WalletCard(
                  wallet: wallets[index],
                  onTap: () => onWalletTap?.call(wallets[index]),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

/// Individual wallet card matching HTML design
class _WalletCard extends StatelessWidget {
  final WalletData wallet;
  final VoidCallback? onTap;

  const _WalletCard({required this.wallet, this.onTap});

  String _formatCurrency(double amount) {
    final formatted = amount
        .toStringAsFixed(0)
        .replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]}.',
        );
    return 'Rp $formatted';
  }

  IconData _getIcon() {
    switch (wallet.type) {
      case WalletType.belanja:
        return Icons.shopping_bag_outlined;
      case WalletType.tabungan:
        return Icons.savings_outlined;
      case WalletType.darurat:
        return Icons.medical_services_outlined;
    }
  }

  Color _getAccentColor() {
    switch (wallet.type) {
      case WalletType.belanja:
        return AppColors.primary;
      case WalletType.tabungan:
        return AppColors.accentPurple;
      case WalletType.darurat:
        return Colors.red.shade400;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isPrimary = wallet.isPrimary;
    final accentColor = _getAccentColor();

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 200,
        decoration: BoxDecoration(
          gradient: isPrimary
              ? LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.blue.shade400, AppColors.primary],
                )
              : null,
          color: isPrimary ? null : Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: isPrimary
              ? null
              : Border.all(color: accentColor.withOpacity(0.2), width: 1),
          boxShadow: [
            BoxShadow(
              color: isPrimary
                  ? AppColors.primary.withOpacity(0.3)
                  : Colors.black.withOpacity(0.05),
              blurRadius: isPrimary ? 20 : 10,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Stack(
            children: [
              // Background circle decoration
              Positioned(
                right: -32,
                top: -32,
                child: Container(
                  width: 96,
                  height: 96,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isPrimary
                        ? Colors.white.withOpacity(0.1)
                        : accentColor.withOpacity(0.1),
                  ),
                ),
              ),

              // Content with padding
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top row: Icon and Badge
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: isPrimary
                                ? Colors.white.withOpacity(0.2)
                                : accentColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            _getIcon(),
                            color: isPrimary ? Colors.white : accentColor,
                            size: 20,
                          ),
                        ),
                        if (isPrimary)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              'Utama',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                          ),
                      ],
                    ),

                    const Spacer(),

                    // Bottom: Label and Balance
                    Text(
                      wallet.type == WalletType.belanja
                          ? 'Dompet Belanja'
                          : wallet.name,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: isPrimary
                            ? Colors.blue.shade100
                            : Colors.grey.shade400,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _formatCurrency(wallet.balance),
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: isPrimary ? Colors.white : AppColors.textMain,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
