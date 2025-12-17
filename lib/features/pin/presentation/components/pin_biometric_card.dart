import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_text_styles.dart';

/// Biometric toggle card
class PinBiometricCard extends StatelessWidget {
  final bool isEnabled;
  final bool isAvailable;
  final ValueChanged<bool>? onChanged;

  const PinBiometricCard({
    super.key,
    this.isEnabled = false,
    this.isAvailable = false,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Fingerprint icon
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFFF0F0F5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.fingerprint,
              color: isAvailable ? AppColors.primary : AppColors.textSub,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),

          // Text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Masuk dengan Biometrik',
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  isAvailable ? 'Tersedia' : 'Belum tersedia',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSub,
                  ),
                ),
              ],
            ),
          ),

          // Toggle
          Switch(
            value: isEnabled,
            onChanged: isAvailable ? onChanged : null,
            activeTrackColor: AppColors.primary.withValues(alpha: 0.5),
            thumbColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.selected)) {
                return AppColors.primary;
              }
              return const Color(0xFFCCCCCC);
            }),
            trackColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.selected)) {
                return AppColors.primary.withValues(alpha: 0.5);
              }
              return const Color(0xFFE5E5E5);
            }),
          ),
        ],
      ),
    );
  }
}
