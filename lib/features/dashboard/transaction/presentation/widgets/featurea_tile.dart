import 'package:flutter/material.dart';

class FeatureaTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const FeatureaTile({
    super.key,
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: selected ? Colors.purple.shade50 : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? Colors.purple : Colors.grey.shade300,
          ),
        ),
        child: Column(
          children: [
            Icon(icon, color: Colors.black54),
            const SizedBox(height: 8),
            Text(label),
          ],
        ),
      ),
    );
  }
}
