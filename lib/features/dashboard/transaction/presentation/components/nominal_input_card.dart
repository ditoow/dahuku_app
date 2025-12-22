import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../../core/constants/app_colors.dart';

/// Card widget for inputting transaction nominal amount
class NominalInputCard extends StatelessWidget {
  final bool isIncome;
  final int amount;
  final ValueChanged<int> onAmountChanged;

  const NominalInputCard({
    super.key,
    required this.isIncome,
    required this.amount,
    required this.onAmountChanged,
  });

  Color get _borderColor =>
      isIncome ? AppColors.success : const Color(0xFFFF6B6B);

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
        border: Border.all(color: _borderColor, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Label
              Center(
                child: Column(
                  children: [
                    Text(
                      'Nominal',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textMain,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Masukkan jumlah uang',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSub,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Amount input
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Rp',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w300,
                      color: AppColors.textLight,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textMain,
                      ),
                      decoration: InputDecoration(
                        hintText: '0',
                        hintStyle: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w300,
                          color: AppColors.textLight,
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
            ],
          ),

          // Decorative piggy bank icon
          Positioned(
            right: 0,
            top: 0,
            child: Icon(
              Icons.savings_outlined,
              size: 48,
              color: _borderColor.withOpacity(0.2),
            ),
          ),
        ],
      ),
    );
  }
}
