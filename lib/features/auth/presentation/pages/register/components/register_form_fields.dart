import 'package:flutter/material.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/constants/app_text_styles.dart';
import '../../../widgets/auth_text_field.dart';

/// Form fields for register page
class RegisterFormFields extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;

  const RegisterFormFields({
    super.key,
    required this.nameController,
    required this.emailController,
    required this.passwordController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Name field
        AuthTextField(
          label: 'Nama Lengkap',
          hint: 'Cth: Budi Santoso',
          prefixIcon: Icons.person_outline,
          controller: nameController,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Nama tidak boleh kosong';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),

        // Email field
        AuthTextField(
          label: 'No. HP atau Email',
          hint: 'Cth: budi@email.com',
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
          hint: 'Minimal 8 karakter',
          prefixIcon: Icons.lock_outline,
          isPassword: true,
          controller: passwordController,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Kata sandi tidak boleh kosong';
            }
            if (value.length < 8) {
              return 'Kata sandi minimal 8 karakter';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),

        // Terms text
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSub,
              height: 1.5,
            ),
            children: [
              const TextSpan(text: 'Dengan mendaftar, Anda menyetujui '),
              TextSpan(
                text: 'Syarat & Ketentuan',
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const TextSpan(text: ' serta '),
              TextSpan(
                text: 'Kebijakan Privasi',
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const TextSpan(text: ' kami.'),
            ],
          ),
        ),
      ],
    );
  }
}
