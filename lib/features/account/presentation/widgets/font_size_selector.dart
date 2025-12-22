import 'package:flutter/material.dart';

class FontSizeSelector extends StatelessWidget {
  final String currentSize;
  final ValueChanged<String> onSelected;

  const FontSizeSelector({
    super.key,
    required this.currentSize,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: ['Kecil', 'Sedang', 'Besar'].map((size) {
        final isActive = currentSize == size;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: ChoiceChip(
            label: Text(size),
            selected: isActive,
            onSelected: (_) => onSelected(size),
          ),
        );
      }).toList(),
    );
  }
}
