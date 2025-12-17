import 'package:flutter/material.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/constants/app_text_styles.dart';

/// Header section with icon and welcome text for register page
class RegisterHeader extends StatelessWidget {
  const RegisterHeader({super.key});

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
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: const Icon(Icons.group_add, size: 44, color: Colors.white),
            ),
            // Yellow dot
            Positioned(
              top: -4,
              right: -4,
              child: Container(
                width: 16,
                height: 16,
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
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: AppColors.accentPurple,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // Welcome text
        Text(
          'Mulai Perjalanan Anda',
          style: AppTextStyles.heading3.copyWith(fontSize: 22),
        ),
        const SizedBox(height: 8),
        Text(
          'Buat akun untuk mengelola keuangan\ndengan lebih cerdas dan efisien.',
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
