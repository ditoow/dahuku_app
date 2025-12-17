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

/// Horizontal scrollable wallet cards
class WalletCardsSection extends StatelessWidget {
  final List<WalletData> wallets;
  final ValueChanged<WalletData>? onWalletTap;

  const WalletCardsSection({
    super.key,
    required this.wallets,
    this.onWalletTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 160,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: wallets.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(
              right: index < wallets.length - 1 ? 12 : 0,
            ),
            child: _WalletCard(
              wallet: wallets[index],
              onTap: () => onWalletTap?.call(wallets[index]),
            ),
          );
        },
      ),
    );
  }
}

/// Individual wallet card
class _WalletCard extends StatelessWidget {
  final WalletData wallet;
  final VoidCallback? onTap;

  const _WalletCard({required this.wallet, this.onTap});

  Color _getGradientStart() {
    switch (wallet.type) {
      case WalletType.belanja:
        return AppColors.primary;
      case WalletType.tabungan:
        return const Color(0xFF10B981);
      case WalletType.darurat:
        return const Color(0xFF8B5CF6);
    }
  }

  Color _getGradientEnd() {
    switch (wallet.type) {
      case WalletType.belanja:
        return const Color(0xFF5C71FF);
      case WalletType.tabungan:
        return const Color(0xFF34D399);
      case WalletType.darurat:
        return const Color(0xFFA78BFA);
    }
  }

  IconData _getIcon() {
    switch (wallet.type) {
      case WalletType.belanja:
        return Icons.shopping_bag_outlined;
      case WalletType.tabungan:
        return Icons.savings_outlined;
      case WalletType.darurat:
        return Icons.shield_outlined;
    }
  }

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
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 275,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [_getGradientStart(), _getGradientEnd()],
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: _getGradientStart().withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top row: Icon container, badge, menu
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon container
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(_getIcon(), color: Colors.white, size: 22),
                ),
                const SizedBox(width: 8),

                // Name & Badge
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (wallet.isPrimary)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            'UTAMA',
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      const SizedBox(height: 4),
                      Text(
                        wallet.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),

                // Menu dots
                Icon(
                  Icons.more_vert,
                  color: Colors.white.withOpacity(0.7),
                  size: 20,
                ),
              ],
            ),

            const Spacer(),

            // Bottom: Balance info
            Text(
              'Saldo Tersedia',
              style: TextStyle(
                fontSize: 11,
                color: Colors.white.withOpacity(0.8),
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              _formatCurrency(wallet.balance),
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
