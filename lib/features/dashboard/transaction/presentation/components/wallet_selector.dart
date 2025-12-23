import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../data/models/wallet_model.dart';
import '../../../data/repositories/wallet_repository.dart';
import '../../bloc/featurea_bloc.dart';
import '../../bloc/featurea_event.dart';

/// Widget for selecting wallet source or destination with dropdown
class WalletSelector extends StatelessWidget {
  final bool isIncome;
  final String? selectedWalletId;
  final String? selectedWalletName;

  const WalletSelector({
    super.key,
    required this.isIncome,
    this.selectedWalletId,
    this.selectedWalletName,
  });

  void _showWalletPicker(BuildContext context) {
    final bloc = context.read<FeatureaBloc>();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (bottomSheetContext) => _WalletPickerSheet(
        selectedWalletId: selectedWalletId,
        walletRepository: bloc.walletRepository,
        onWalletSelected: (walletId, walletName) {
          bloc.add(
            SelectWalletById(walletId: walletId, walletName: walletName),
          );
          Navigator.pop(bottomSheetContext);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showWalletPicker(context),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
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
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.primary.withAlpha(26),
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
                  const SizedBox(height: 4),
                  Text(
                    selectedWalletName != null
                        ? 'Dompet $selectedWalletName'
                        : 'Pilih dompet',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: selectedWalletName != null
                          ? AppColors.textMain
                          : AppColors.textLight,
                    ),
                  ),
                ],
              ),
            ),

            // Dropdown icon
            Icon(
              Icons.keyboard_arrow_down,
              color: AppColors.textLight,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }
}

/// Bottom sheet for wallet selection
class _WalletPickerSheet extends StatelessWidget {
  final String? selectedWalletId;
  final WalletRepository walletRepository;
  final Function(String walletId, String walletName) onWalletSelected;

  const _WalletPickerSheet({
    required this.selectedWalletId,
    required this.walletRepository,
    required this.onWalletSelected,
  });

  IconData _getWalletIcon(WalletType type) {
    switch (type) {
      case WalletType.belanja:
        return Icons.account_balance_wallet;
      case WalletType.tabungan:
        return Icons.savings;
      case WalletType.darurat:
        return Icons.shield;
    }
  }

  Color _getWalletColor(WalletType type) {
    switch (type) {
      case WalletType.belanja:
        return AppColors.primary;
      case WalletType.tabungan:
        return Colors.green;
      case WalletType.darurat:
        return Colors.orange;
    }
  }

  String _formatCurrency(double amount) {
    return 'Rp ${amount.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(top: 12),
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Title
          Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              'Pilih Dompet',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textMain,
              ),
            ),
          ),

          // Wallet list
          FutureBuilder<List<WalletModel>>(
            future: walletRepository.getWallets(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Padding(
                  padding: EdgeInsets.all(40),
                  child: CircularProgressIndicator(),
                );
              }

              final wallets = snapshot.data ?? [];

              if (wallets.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.all(40),
                  child: Text(
                    'Tidak ada dompet ditemukan',
                    style: TextStyle(color: AppColors.textSub),
                  ),
                );
              }

              return ListView.builder(
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: wallets.length,
                itemBuilder: (context, index) {
                  final wallet = wallets[index];
                  final isSelected = wallet.id == selectedWalletId;
                  final color = _getWalletColor(wallet.type);

                  return GestureDetector(
                    onTap: () => onWalletSelected(wallet.id, wallet.name),
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? color.withAlpha(13)
                            : Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isSelected ? color : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: color.withAlpha(26),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              _getWalletIcon(wallet.type),
                              color: color,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  wallet.name,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textMain,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  _formatCurrency(wallet.balance),
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppColors.textSub,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (isSelected)
                            Icon(Icons.check_circle, color: color, size: 24),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
