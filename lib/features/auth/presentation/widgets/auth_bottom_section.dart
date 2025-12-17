import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_text_styles.dart';
import '../../../../../core/widgets/primary_button.dart';

/// Reusable bottom section for auth pages
class AuthBottomSection extends StatelessWidget {
  final String buttonText;
  final IconData buttonIcon;
  final bool isLoading;
  final VoidCallback onButtonPressed;
  final String alternativeText;
  final String alternativeActionText;
  final VoidCallback onAlternativePressed;

  const AuthBottomSection({
    super.key,
    required this.buttonText,
    required this.buttonIcon,
    required this.isLoading,
    required this.onButtonPressed,
    required this.alternativeText,
    required this.alternativeActionText,
    required this.onAlternativePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          PrimaryButton(
            text: buttonText,
            icon: buttonIcon,
            isLoading: isLoading,
            onPressed: onButtonPressed,
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                alternativeText,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSub,
                ),
              ),
              GestureDetector(
                onTap: onAlternativePressed,
                child: Text(
                  alternativeActionText,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
