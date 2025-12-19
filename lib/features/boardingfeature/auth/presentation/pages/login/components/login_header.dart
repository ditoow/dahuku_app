import 'package:flutter/material.dart';
import '../../../../../../../core/constants/app_colors.dart';
import '../../../../../../../core/constants/app_text_styles.dart';

/// Header section with icon and welcome text for login page
class LoginHeader extends StatelessWidget {
  const LoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Icon with dots
        Stack(
          children: [
            Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF6B7AFF), AppColors.primary],
                ),
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Icon(Icons.person, size: 48, color: Colors.white),
            ),
            // Yellow dot
            Positioned(
              top: -4,
              right: -4,
              child: Container(
                width: 14,
                height: 14,
                decoration: BoxDecoration(
                  color: Colors.amber,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
              ),
            ),
            // Purple dot
            Positioned(
              bottom: -2,
              left: -2,
              child: Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: AppColors.accentPurple,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),

        // Welcome text
        Text(
          'Selamat Datang!',
          style: AppTextStyles.heading2.copyWith(fontSize: 26),
        ),
        const SizedBox(height: 8),
        Text(
          'Masuk untuk mengelola keuangan,\ndompet cerdas, dan aset Anda.',
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textSub,
            height: 1.5,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
