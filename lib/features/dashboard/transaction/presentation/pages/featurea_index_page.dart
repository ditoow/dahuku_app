import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../bloc/featurea_bloc.dart';
import '../../bloc/featurea_event.dart';
import '../../bloc/featurea_state.dart';
import '../components/transaction_type_toggle.dart';
import '../components/nominal_input_card.dart';
import '../components/wallet_selector.dart';
import '../components/category_grid.dart';
import '../components/note_input.dart';
import '../components/save_button.dart';

class FeatureaIndexPage extends StatelessWidget {
  const FeatureaIndexPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => FeatureaBloc(),
      child: const _FeatureaPageContent(),
    );
  }
}

class _FeatureaPageContent extends StatelessWidget {
  const _FeatureaPageContent();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FeatureaBloc, FeatureaState>(
      listener: (context, state) {
        // Show success message when transaction is saved
        if (state.amount == 0 && state.selectedExpenseCategory == null && state.selectedIncomeSource == null) {
          // This indicates the form was just reset after a successful save
          // We could show a success message here if needed
        }

        // Show error if any
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
          body: Stack(
            children: [
              // Gradient background
              _buildGradientBackground(state.isIncome),

              // Main content
              SafeArea(
                child: Column(
                  children: [
                    // App bar
                    _buildAppBar(context),

                    // Scrollable content
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Header text
                            const Text(
                              'Transaksi Baru',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textMain,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Catat pengeluaran atau pemasukan',
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.textSub,
                              ),
                            ),
                            const SizedBox(height: 20),

                            // Toggle
                            TransactionTypeToggle(
                              isIncome: state.isIncome,
                              onChanged: (isIncome) {
                                context.read<FeatureaBloc>().add(
                                      ToggleTransactionType(isIncome),
                                    );
                              },
                            ),
                            const SizedBox(height: 20),

                            // Nominal input
                            NominalInputCard(
                              isIncome: state.isIncome,
                              amount: state.amount,
                              onAmountChanged: (amount) {
                                context.read<FeatureaBloc>().add(
                                      UpdateAmount(amount),
                                    );
                              },
                            ),
                            const SizedBox(height: 16),

                            // Wallet selector
                            WalletSelector(
                              isIncome: state.isIncome,
                              wallet: state.selectedWallet,
                            ),
                            const SizedBox(height: 24),

                            // Category grid
                            CategoryGrid(
                              isIncome: state.isIncome,
                              selectedExpenseCategory: state.selectedExpenseCategory,
                              selectedIncomeSource: state.selectedIncomeSource,
                              onExpenseCategorySelected: (category) {
                                context.read<FeatureaBloc>().add(
                                      SelectExpenseCategory(category),
                                    );
                              },
                              onIncomeSourceSelected: (source) {
                                context.read<FeatureaBloc>().add(
                                      SelectIncomeSource(source),
                                    );
                              },
                            ),
                            const SizedBox(height: 20),

                            // Note input
                            NoteInput(
                              value: state.note,
                              onChanged: (note) {
                                context.read<FeatureaBloc>().add(
                                      UpdateNote(note),
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

              // Save button (fixed at bottom)
              Positioned(
                left: 20,
                right: 20,
                bottom: 32,
                child: SaveButton(
                  isEnabled: state.isValid,
                  isLoading: state.isLoading,
                  onPressed: () {
                    context.read<FeatureaBloc>().add(SaveTransaction());
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildGradientBackground(bool isIncome) {
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
            colors: isIncome
                ? [
                    AppColors.success.withOpacity(0.3),
                    AppColors.success.withOpacity(0.1),
                    Colors.transparent,
                  ]
                : [
                    const Color(0xFFE8D5FF).withOpacity(0.6), // Light purple
                    const Color(0xFFFFD5D5).withOpacity(0.4), // Light coral
                    Colors.transparent,
                  ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          // Back button
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.arrow_back,
                color: AppColors.textMain,
                size: 22,
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Title
          const Expanded(
            child: Text(
              'Catat Transaksi',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textMain,
              ),
            ),
          ),

          // Notification icon
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.8),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                const Icon(
                  Icons.notifications_outlined,
                  color: AppColors.textMain,
                  size: 22,
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Color(0xFFFF6B6B),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
