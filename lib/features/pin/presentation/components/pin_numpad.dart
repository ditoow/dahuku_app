import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_text_styles.dart';

/// Number pad for PIN entry
class PinNumpad extends StatelessWidget {
  final ValueChanged<String> onDigitPressed;
  final VoidCallback onDeletePressed;

  const PinNumpad({
    super.key,
    required this.onDigitPressed,
    required this.onDeletePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        children: [
          _buildRow(['1', '2', '3']),
          const SizedBox(height: 16),
          _buildRow(['4', '5', '6']),
          const SizedBox(height: 16),
          _buildRow(['7', '8', '9']),
          const SizedBox(height: 16),
          _buildRow(['', '0', 'del']),
        ],
      ),
    );
  }

  Widget _buildRow(List<String> digits) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: digits.map((digit) {
        if (digit.isEmpty) {
          return const SizedBox(width: 72, height: 72);
        }
        if (digit == 'del') {
          return _buildDeleteButton();
        }
        return _buildDigitButton(digit);
      }).toList(),
    );
  }

  Widget _buildDigitButton(String digit) {
    return GestureDetector(
      onTap: () => onDigitPressed(digit),
      child: Container(
        width: 72,
        height: 72,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: Text(
            digit,
            style: AppTextStyles.heading2.copyWith(
              fontSize: 28,
              color: AppColors.textMain,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDeleteButton() {
    return GestureDetector(
      onTap: onDeletePressed,
      child: Container(
        width: 72,
        height: 72,
        decoration: const BoxDecoration(
          color: Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Icon(
            Icons.backspace_outlined,
            color: AppColors.textSub,
            size: 28,
          ),
        ),
      ),
    );
  }
}
