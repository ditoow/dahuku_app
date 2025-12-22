import 'package:flutter/material.dart';
import '../../data/models/featurea_model.dart';

class FeatureATile extends StatelessWidget {
  final FeatureATransaction data;

  const FeatureATile({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ListTile(
        leading: CircleAvatar(
          radius: 22,
          backgroundColor: Colors.grey.shade100,
          child: Text(data.icon, style: const TextStyle(fontSize: 18)),
        ),
        title: Text(
          data.title,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          data.subtitle,
          style: TextStyle(color: Colors.grey.shade600),
        ),
        trailing: Text(
          '- Rp ${data.amount.abs()}',
          style: const TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
