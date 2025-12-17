import 'package:flutter/material.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/constants/app_text_styles.dart';
import '../../../../../../core/widgets/primary_button.dart';

/// Bottom section for register page with button and login link
class RegisterBottomSection extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onRegisterPressed;
  final VoidCallback onLoginPressed;

  const RegisterBottomSection({
    super.key,
    required this.isLoading,
    required this.onRegisterPressed,
    required this.onLoginPressed,
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
            text: 'Daftar Sekarang',
            icon: Icons.arrow_forward,
            isLoading: isLoading,
            onPressed: onRegisterPressed,
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Sudah punya akun? ',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSub,
                ),
              ),
              GestureDetector(
                onTap: onLoginPressed,
                child: Text(
                  'Masuk',
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
