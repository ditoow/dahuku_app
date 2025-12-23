import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/constants/app_text_styles.dart';
import '../../../../../../core/widgets/primary_button.dart';
import '../../bloc/questionnaire_bloc.dart';
import 'debt_input_section.dart';
import 'wallet_balance_inputs_section.dart';

/// Bottom section for questionnaire - gets state from BLoC
class QuestionnaireBottomSection extends StatelessWidget {
  final int totalQuestions;
  final GlobalKey<WalletBalanceInputsSectionState>? walletInputsKey;
  final GlobalKey<DebtInputSectionState>? debtInputsKey;

  const QuestionnaireBottomSection({
    super.key,
    required this.totalQuestions,
    this.walletInputsKey,
    this.debtInputsKey,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QuestionnaireBloc, QuestionnaireState>(
      builder: (context, state) {
        final isFirstQuestion = state.isFirstQuestion;
        final isLastQuestion = state.currentQuestionIndex == totalQuestions - 1;
        final canProceed = _canProceed(state);

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: Row(
            children: [
              // Back button
              if (!isFirstQuestion)
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      context.read<QuestionnaireBloc>().add(
                        QuestionnairePreviousPressed(),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side: BorderSide(color: AppColors.primary),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text(
                      'Kembali',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

              if (!isFirstQuestion) const SizedBox(width: 12),

              // Next/Submit button
              Expanded(
                child: PrimaryButton(
                  text: isLastQuestion ? 'Selesai' : 'Lanjutkan',
                  icon: isLastQuestion ? Icons.check : Icons.arrow_forward,
                  onPressed: canProceed
                      ? () => _handleNext(context, state, isLastQuestion)
                      : null,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  bool _canProceed(QuestionnaireState state) {
    // Check based on question index
    if (state.currentQuestionIndex == 1 && walletInputsKey != null) {
      // Wallet input step
      return walletInputsKey?.currentState?.hasValue ?? false;
    } else if (state.currentQuestionIndex == 2) {
      // Debt step is optional
      return true;
    } else {
      return state.hasCurrentAnswer;
    }
  }

  void _handleNext(
    BuildContext context,
    QuestionnaireState state,
    bool isLastQuestion,
  ) {
    if (isLastQuestion) {
      // Submit with wallet and debt data
      final walletState = walletInputsKey?.currentState;
      final debtState = debtInputsKey?.currentState;

      context.read<QuestionnaireBloc>().add(
        QuestionnaireSubmitted(
          initialBelanja: walletState?.belanjaValue ?? 0,
          initialTabungan: walletState?.tabunganValue ?? 0,
          initialDarurat: walletState?.daruratValue ?? 0,
          hasDebt: debtState?.hasDebt ?? false,
          debtAmount: debtState?.debtAmount,
          debtType: debtState?.debtType,
        ),
      );
    } else {
      context.read<QuestionnaireBloc>().add(QuestionnaireNextPressed());
    }
  }
}
