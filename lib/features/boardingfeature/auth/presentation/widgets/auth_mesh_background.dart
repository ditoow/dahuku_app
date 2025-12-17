import 'package:flutter/material.dart';
import '../../../../../../core/constants/app_colors.dart';

/// Reusable mesh background for auth pages
class AuthMeshBackground extends StatelessWidget {
  const AuthMeshBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        height: 350,
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.topCenter,
            radius: 1.2,
            colors: [
              const Color(0xFFE8E0FF),
              const Color(0xFFF4F1FF),
              AppColors.bgPage,
            ],
          ),
        ),
      ),
    );
  }
}
