import 'package:flutter/material.dart';
import '../../../../../../core/constants/app_text_styles.dart';

/// App bar for login page
class LoginAppBar extends StatelessWidget {
  const LoginAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Text(
        'Masuk',
        textAlign: TextAlign.center,
        style: AppTextStyles.heading4.copyWith(fontSize: 18),
      ),
    );
  }
}
