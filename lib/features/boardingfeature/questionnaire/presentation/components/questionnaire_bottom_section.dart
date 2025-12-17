import 'package:flutter/material.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/constants/app_text_styles.dart';
import '../../../../../../core/widgets/primary_button.dart';

/// Bottom section for questionnaire with navigation buttons
class QuestionnaireBottomSection extends StatelessWidget {
  final bool isFirstQuestion;
  final bool isLastQuestion;
  final bool canProceed;
  final VoidCallback onPreviousPressed;
  final VoidCallback onNextPressed;

  const QuestionnaireBottomSection({
    super.key,
    required this.isFirstQuestion,
    required this.isLastQuestion,
    required this.canProceed,
    required this.onPreviousPressed,
    required this.onNextPressed,
  });

  @override
  Widget build(BuildContext context) {
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
                onPressed: onPreviousPressed,
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
            flex: isFirstQuestion ? 1 : 1,
            child: PrimaryButton(
              text: isLastQuestion ? 'Selesai' : 'Lanjutkan',
              icon: isLastQuestion ? Icons.check : Icons.arrow_forward,
              onPressed: canProceed ? onNextPressed : null,
            ),
          ),
        ],
      ),
    );
  }
}
