import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../bloc/dashboard_bloc.dart';
import '../../../bloc/dashboard_event.dart';
import '../../../data/repositories/transaction_repository.dart';
import '../../../data/repositories/wallet_repository.dart';
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
    // Extract route arguments if any
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final preselectedWalletId = args?['walletId'] as String?;
    final forceIncomeMode = args?['isIncome'] as bool?;

    return BlocProvider(
      create: (_) =>
          FeatureaBloc(
            transactionRepository: GetIt.I<TransactionRepository>(),
            walletRepository: GetIt.I<WalletRepository>(),
          )..add(
            LoadWallets(
              preselectedWalletId: preselectedWalletId,
              forceIncomeMode: forceIncomeMode,
            ),
          ),
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
        // Show success and refresh dashboard
        if (state.isSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Transaksi berhasil disimpan!'),
              backgroundColor: AppColors.success,
            ),
          );
          // Refresh dashboard
          try {
            GetIt.I<DashboardBloc>().add(const DashboardRefreshRequested());
          } catch (_) {}
          Navigator.pop(context, true);
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
                              selectedWalletId: state.selectedWalletId,
                              selectedWalletName: state.selectedWalletName,
                            ),
                            const SizedBox(height: 24),

                            // Category grid
                            CategoryGrid(
                              isIncome: state.isIncome,
                              selectedExpenseCategory:
                                  state.selectedExpenseCategory,
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
                    AppColors.success.withAlpha(77),
                    AppColors.success.withAlpha(26),
                    Colors.transparent,
                  ]
                : [
                    const Color(0xFFE8D5FF).withAlpha(153),
                    const Color(0xFFFFD5D5).withAlpha(102),
                    Colors.transparent,
                  ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text('Catat Transaksi'),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Navigator.pop(context),
      ),
    );
  }
}
