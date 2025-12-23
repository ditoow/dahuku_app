import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../../core/constants/app_colors.dart';
import '../../../../../../../core/constants/app_text_styles.dart';
import '../../../../../../../core/widgets/primary_button.dart';
import '../../../../bloc/auth_bloc.dart';

/// Bottom section for login page - handles its own logic
class LoginBottomSection extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final String Function() getEmail;
  final String Function() getPassword;

  const LoginBottomSection({
    super.key,
    required this.formKey,
    required this.getEmail,
    required this.getPassword,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        final isLoading = state.status == AuthStatus.loading;

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
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    context.read<AuthBloc>().add(
                      AuthLoginRequested(
                        email: getEmail(),
                        password: getPassword(),
                      ),
                    );
                  }
                },
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
                    onTap: () {
                      Navigator.pushReplacementNamed(context, '/register');
                    },
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
      },
    );
  }
}
