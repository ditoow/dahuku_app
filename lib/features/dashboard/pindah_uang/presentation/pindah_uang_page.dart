import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_colors.dart';
import '../bloc/pindah_uang_bloc.dart';
import '../bloc/pindah_uang_event.dart';
import '../bloc/pindah_uang_state.dart';
import 'components/source_wallet_card.dart';
import 'components/target_wallet_selector.dart';
import 'components/amount_input_section.dart';
import 'components/transfer_button.dart';

/// Pindah Uang (Transfer Money) Page
class PindahUangPage extends StatelessWidget {
  const PindahUangPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PindahUangBloc(),
      child: const _PindahUangPageContent(),
    );
  }
}

class _PindahUangPageContent extends StatelessWidget {
  const _PindahUangPageContent();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PindahUangBloc, PindahUangState>(
      listener: (context, state) {
        if (state.isSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Berhasil memindahkan uang!'),
              backgroundColor: AppColors.success,
            ),
          );
          Navigator.pop(context);
        }

        if (state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage!),
              backgroundColor: AppColors.error,
            ),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.bgPage,
          body: Stack(
            children: [
              // Background gradient
              _buildGradientBackground(),

              // Main content
              SafeArea(
                child: Column(
                  children: [
                    // App bar
                    _buildAppBar(context),

                    // Scrollable content
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 120),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // "DARI DOMPET" Section
                            const Text(
                              'DARI DOMPET',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textSub,
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(height: 12),
                            SourceWalletCard(
                              walletName: 'Dompet Belanja',
                              balance: state.sourceWalletBalance,
                            ),
                            const SizedBox(height: 24),

                            // "KE DOMPET" Section
                            const Text(
                              'KE DOMPET',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textSub,
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(height: 12),
                            TargetWalletSelector(
                              selectedWalletType:
                                  state.selectedTargetWalletType,
                              onWalletSelected: (type) {
                                context.read<PindahUangBloc>().add(
                                  SelectTargetWallet(type),
                                );
                              },
                            ),
                            const SizedBox(height: 24),

                            // "Jumlah Uang" Section
                            AmountInputSection(
                              amount: state.amount,
                              maxAmount: state.sourceWalletBalance,
                              onAmountChanged: (amount) {
                                context.read<PindahUangBloc>().add(
                                  UpdateAmount(amount),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Transfer button (fixed at bottom)
              Positioned(
                left: 20,
                right: 20,
                bottom: 32,
                child: TransferButton(
                  isEnabled: state.isValid,
                  isLoading: state.isLoading,
                  onPressed: () {
                    context.read<PindahUangBloc>().add(const SubmitTransfer());
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildGradientBackground() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      height: 200,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.primary.withOpacity(0.1),
              AppColors.accentPurple.withOpacity(0.05),
              Colors.transparent,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back, color: AppColors.textMain),
          ),
          const SizedBox(width: 8),
          const Text(
            'Pindahkan Uang',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.textMain,
            ),
          ),
        ],
      ),
    );
  }
}
