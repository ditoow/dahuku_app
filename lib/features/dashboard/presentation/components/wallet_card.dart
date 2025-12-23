import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../bloc/dashboard_bloc.dart';
import '../../bloc/dashboard_state.dart';

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

/// Dompetku section with horizontal scrollable wallet cards (smart component)
class WalletCardsSection extends StatelessWidget {
  const WalletCardsSection({super.key});

  List<WalletData> _convertWallets(List<dynamic> models) {
    if (models.isEmpty) return [];
    return models.map((m) {
      WalletType uiType;
      // Handle both converting from internal WalletModel or just using the model directly if mapped
      // Assuming models are WalletModel from data layer
      final typeStr = m.type.toString().split('.').last;
      switch (typeStr) {
        case 'belanja':
          uiType = WalletType.belanja;
          break;
        case 'tabungan':
          uiType = WalletType.tabungan;
          break;
        case 'darurat':
          uiType = WalletType.darurat;
          break;
        default:
          uiType = WalletType.belanja;
      }

      return WalletData(
        type: uiType,
        name: m.name,
        balance: m.balance,
        isPrimary: m.isPrimary,
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardBloc, DashboardState>(
      builder: (context, state) {
        final wallets = _convertWallets(state.wallets);

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
                    onTap: () {
                      // Navigate to all wallets
                    },
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
            if (wallets.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Text("Belum ada dompet"),
              )
            else
              SizedBox(
                height: 180, // Increased for shadow space
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  clipBehavior: Clip.none, // Prevent shadow clipping
                  padding: const EdgeInsets.only(
                    left: 24,
                    right: 24,
                    bottom: 16,
                  ),
                  itemCount: wallets.length,
                  itemBuilder: (context, index) {
                    final wallet = wallets[index];
                    // Only Dompet Belanja (primary wallet) can navigate to detail page
                    final canNavigate = wallet.type == WalletType.belanja;

                    return Padding(
                      padding: EdgeInsets.only(
                        right: index < wallets.length - 1 ? 16 : 0,
                      ),
                      child: _WalletCard(
                        key: ValueKey('wallet_${wallet.type.name}_$index'),
                        wallet: wallet,
                        onTap: canNavigate
                            ? () {
                                // Navigate to Dompet Belanja detail page
                                Navigator.pushNamed(context, '/dompet');
                              }
                            : null, // Tabungan & Darurat have no navigation
                      ),
                    );
                  },
                ),
              ),
          ],
        );
      },
    );
  }
}

/// Individual wallet card matching HTML design
class _WalletCard extends StatelessWidget {
  final WalletData wallet;
  final VoidCallback? onTap;

  const _WalletCard({super.key, required this.wallet, this.onTap});

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
              : Border.all(color: accentColor.withAlpha(51), width: 1),
          boxShadow: [
            BoxShadow(
              color: isPrimary
                  ? AppColors.primary.withAlpha(77)
                  : Colors.black.withAlpha(13),
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
                        ? Colors.white.withAlpha(26)
                        : accentColor.withAlpha(26),
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
                                ? Colors.white.withAlpha(51)
                                : accentColor.withAlpha(26),
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
                              color: Colors.black.withAlpha(26),
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
