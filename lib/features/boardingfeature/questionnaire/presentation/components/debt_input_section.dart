import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/constants/app_text_styles.dart';

/// Debt type options
enum DebtType { none, rentenir, keluarga, koperasi }

/// Debt input section with amount and type selector
class DebtInputSection extends StatelessWidget {
  final TextEditingController amountController;
  final DebtType selectedType;
  final ValueChanged<DebtType> onTypeChanged;
  final ValueChanged<String>? onAmountChanged;

  const DebtInputSection({
    super.key,
    required this.amountController,
    required this.selectedType,
    required this.onTypeChanged,
    this.onAmountChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Amount input
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              // Icon
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.error.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.money_off_outlined,
                  color: AppColors.error,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),

              // Input
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Jumlah Hutang',
                      style: AppTextStyles.labelSmall.copyWith(
                        color: AppColors.textSub,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          'Rp ',
                          style: AppTextStyles.bodyMedium.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColors.textMain,
                          ),
                        ),
                        Expanded(
                          child: TextField(
                            controller: amountController,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            onChanged: onAmountChanged,
                            style: AppTextStyles.bodyMedium.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                            decoration: InputDecoration(
                              hintText: '0 (opsional)',
                              hintStyle: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.textSub.withValues(alpha: 0.5),
                              ),
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding: EdgeInsets.zero,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Debt type label
        Text(
          'Jenis Hutang',
          style: AppTextStyles.labelSmall.copyWith(
            color: AppColors.textSub,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 12),

        // Debt type options
        Row(
          children: [
            _buildTypeChip(
              'Tidak Ada',
              DebtType.none,
              Icons.check_circle_outline,
            ),
            const SizedBox(width: 8),
            _buildTypeChip(
              'Rentenir',
              DebtType.rentenir,
              Icons.warning_outlined,
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            _buildTypeChip(
              'Keluarga',
              DebtType.keluarga,
              Icons.family_restroom_outlined,
            ),
            const SizedBox(width: 8),
            _buildTypeChip(
              'Koperasi',
              DebtType.koperasi,
              Icons.business_outlined,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTypeChip(String label, DebtType type, IconData icon) {
    final isSelected = selectedType == type;

    return Expanded(
      child: GestureDetector(
        onTap: () => onTypeChanged(type),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primary.withValues(alpha: 0.1)
                : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? AppColors.primary : const Color(0xFFE5E5E5),
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 18,
                color: isSelected ? AppColors.primary : AppColors.textSub,
              ),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  label,
                  style: AppTextStyles.bodySmall.copyWith(
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: isSelected ? AppColors.primary : AppColors.textMain,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
