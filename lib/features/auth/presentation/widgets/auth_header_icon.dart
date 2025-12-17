import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';

/// Reusable header icon with decorative dots for auth pages
class AuthHeaderIcon extends StatelessWidget {
  final IconData icon;
  final List<Color> gradientColors;

  const AuthHeaderIcon({
    super.key,
    required this.icon,
    this.gradientColors = const [Color(0xFF6B7AFF), AppColors.primary],
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 88,
          height: 88,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: gradientColors,
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.3),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Icon(icon, size: 44, color: Colors.white),
        ),
        // Yellow dot
        Positioned(
          top: -4,
          right: -4,
          child: Container(
            width: 14,
            height: 14,
            decoration: BoxDecoration(
              color: Colors.amber,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
            ),
          ),
        ),
        // Purple dot
        Positioned(
          bottom: -2,
          left: -2,
          child: Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: AppColors.accentPurple,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
            ),
          ),
        ),
      ],
    );
  }
}
