import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

/// Analytics page gradient background
class AnalyticsBackground extends StatelessWidget {
  const AnalyticsBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 320,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color(0xFFE0D4FC),
            const Color(0xFFF1EAFF),
            AppColors.bgPage,
          ],
          stops: const [0.0, 0.5, 1.0],
        ),
      ),
    );
  }
}
