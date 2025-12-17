import 'package:flutter/material.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/constants/app_text_styles.dart';
import '../../../../../../core/widgets/primary_button.dart';

/// Bottom section for login page with button and register link
class LoginBottomSection extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onLoginPressed;
  final VoidCallback onRegisterPressed;

  const LoginBottomSection({
    super.key,
    required this.isLoading,
    required this.onLoginPressed,
    required this.onRegisterPressed,
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
            text: 'Masuk',
            icon: Icons.login,
            isLoading: isLoading,
            onPressed: onLoginPressed,
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Belum punya akun? ',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSub,
                ),
              ),
              GestureDetector(
                onTap: onRegisterPressed,
                child: Text(
                  'Daftar Sekarang',
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
