import 'package:flutter/material.dart';
import '../../../../../core/constants/app_text_styles.dart';

/// Reusable app bar for auth pages
class AuthAppBar extends StatelessWidget {
  final String title;

  const AuthAppBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: AppTextStyles.heading4.copyWith(fontSize: 18),
      ),
    );
  }
}
