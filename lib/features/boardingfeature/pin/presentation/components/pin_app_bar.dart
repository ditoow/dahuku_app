import 'package:flutter/material.dart';
import '../../../../../../core/constants/app_text_styles.dart';

/// App bar for PIN page with back button and title
class PinAppBar extends StatelessWidget {
  final VoidCallback? onBackPressed;

  const PinAppBar({super.key, this.onBackPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Text(
        'Keamanan',
        textAlign: TextAlign.center,
        style: AppTextStyles.heading4.copyWith(fontSize: 18),
      ),
    );
  }
}
