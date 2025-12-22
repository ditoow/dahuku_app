import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';

/// Save transaction button with enabled/disabled state
class SaveButton extends StatelessWidget {
  final bool isEnabled;
  final bool isLoading;
  final VoidCallback? onPressed;

  const SaveButton({
    super.key,
    required this.isEnabled,
    this.isLoading = false,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        gradient: isEnabled
            ? const LinearGradient(
                colors: [Color(0xFF5C71FF), AppColors.primary],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              )
            : null,
        color: isEnabled ? null : Colors.grey.shade300,
        borderRadius: BorderRadius.circular(16),
        boxShadow: isEnabled
            ? [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isEnabled && !isLoading ? onPressed : null,
          borderRadius: BorderRadius.circular(16),
          child: Center(
            child: isLoading
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor: AlwaysStoppedAnimation(Colors.white),
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.check_circle_outline,
                        color: isEnabled ? Colors.white : Colors.grey.shade500,
                        size: 22,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Simpan Transaksi',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: isEnabled ? Colors.white : Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
