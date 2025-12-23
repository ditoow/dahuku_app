import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../../core/constants/app_colors.dart';

/// Amount input section for transfer
class AmountInputSection extends StatelessWidget {
  final int amount;
  final double maxAmount;
  final ValueChanged<int> onAmountChanged;

  const AmountInputSection({
    super.key,
    required this.amount,
    required this.maxAmount,
    required this.onAmountChanged,
  });

  int _parseAmount(String value) {
    final cleaned = value.replaceAll('.', '').replaceAll(',', '');
    return int.tryParse(cleaned) ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Label
          const Text(
            'Jumlah Uang',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textMain,
            ),
          ),
          const SizedBox(height: 20),

          // Amount input row
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Rp',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.w300,
                  color: AppColors.primary.withOpacity(0.6),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.w300,
                    color: AppColors.textLight,
                  ),
                  decoration: InputDecoration(
                    hintText: '0',
                    hintStyle: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.w300,
                      color: AppColors.textLight.withOpacity(0.5),
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
                  onChanged: (value) {
                    final parsed = _parseAmount(value);
                    onAmountChanged(parsed);
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Max amount hint
          Text(
            'Maksimal sesuai saldo Dompet Belanja',
            style: TextStyle(
              fontSize: 13,
              color: AppColors.primary.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }
}
