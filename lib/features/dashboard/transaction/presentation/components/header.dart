import 'package:flutter/material.dart';

class FeatureAHeader extends StatelessWidget {
  const FeatureAHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF4A6CF7), Color(0xFF5E7BFA)],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.25),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: Colors.white24,
                child: Icon(Icons.shopping_bag, color: Colors.white),
              ),
              SizedBox(width: 12),
              Text(
                'DOMPET UTAMA',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Text(
            'Dompet Belanja',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 20),
          Text(
            'Saldo Saat Ini',
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
          SizedBox(height: 6),
          Text(
            'Rp 2.150.000',
            style: TextStyle(
              color: Colors.white,
              fontSize: 36,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
