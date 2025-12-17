import 'package:flutter/material.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/constants/app_text_styles.dart';

/// Header section with lock icon and title for PIN page
class PinHeader extends StatelessWidget {
  const PinHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Lock icon with decorations
        Stack(
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF8B9AFF), AppColors.primary],
                ),
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.3),
                    blurRadius: 24,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),
              child: const Icon(
                Icons.lock_open_rounded,
                size: 48,
                color: Colors.white,
              ),
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
            // Small purple dot
            Positioned(
              bottom: 8,
              left: -6,
              child: Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: AppColors.accentPurple.withValues(alpha: 0.6),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 28),

        // Title
        Text(
          'Buat PIN Baru',
          style: AppTextStyles.heading2.copyWith(fontSize: 24),
        ),
        const SizedBox(height: 8),

        // Subtitle
        Text(
          'PIN untuk melindungi data Anda dan\nmengamankan setiap transaksi.',
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
