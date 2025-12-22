import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';

/// Toggle button for switching between Expense (Uang Keluar) and Income (Uang Masuk)
class TransactionTypeToggle extends StatelessWidget {
  final bool isIncome;
  final ValueChanged<bool> onChanged;

  const TransactionTypeToggle({
    super.key,
    required this.isIncome,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Uang Keluar (Expense)
          Expanded(
            child: _ToggleOption(
              label: 'Uang Keluar',
              isActive: !isIncome,
              activeColor: const Color(0xFFFF6B6B), // Coral/red
              onTap: () => onChanged(false),
            ),
          ),
          // Uang Masuk (Income)
          Expanded(
            child: _ToggleOption(
              label: 'Uang Masuk',
              isActive: isIncome,
              activeColor: AppColors.success, // Teal/green
              onTap: () => onChanged(true),
            ),
          ),
        ],
      ),
    );
  }
}

class _ToggleOption extends StatelessWidget {
  final String label;
  final bool isActive;
  final Color activeColor;
  final VoidCallback onTap;

  const _ToggleOption({
    required this.label,
    required this.isActive,
    required this.activeColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isActive ? activeColor : Colors.transparent,
          borderRadius: BorderRadius.circular(28),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isActive ? Colors.white : AppColors.textSub,
            ),
          ),
        ),
      ),
    );
  }
}
