import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';

/// Text input field for optional transaction note
class NoteInput extends StatelessWidget {
  final String value;
  final ValueChanged<String> onChanged;

  const NoteInput({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(
            Icons.notes,
            color: AppColors.textLight,
            size: 22,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textMain,
              ),
              decoration: InputDecoration(
                hintText: 'Catatan (opsional)',
                hintStyle: TextStyle(
                  fontSize: 14,
                  color: AppColors.textLight,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
                isDense: true,
              ),
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }
}
