import 'package:flutter/material.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/constants/app_text_styles.dart';
import '../../../widgets/auth_text_field.dart';

/// Form fields for login page
class LoginFormFields extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;

  const LoginFormFields({
    super.key,
    required this.emailController,
    required this.passwordController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Email field
        AuthTextField(
          label: 'Email atau No. HP',
          hint: 'Contoh: user@email.com',
          prefixIcon: Icons.mail_outline,
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Email tidak boleh kosong';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),

        // Password field
        AuthTextField(
          label: 'Kata Sandi',
          hint: 'Masukkan kata sandi',
          prefixIcon: Icons.lock_outline,
          isPassword: true,
          controller: passwordController,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Kata sandi tidak boleh kosong';
            }
            return null;
          },
        ),
        const SizedBox(height: 8),

        // Forgot password
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              'Lupa Kata Sandi?',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
