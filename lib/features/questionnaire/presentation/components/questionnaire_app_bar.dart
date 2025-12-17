import 'package:flutter/material.dart';
import '../../../../../core/constants/app_text_styles.dart';

/// App bar for questionnaire page
class QuestionnaireAppBar extends StatelessWidget {
  const QuestionnaireAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Text(
        'Profil Keuangan',
        textAlign: TextAlign.center,
        style: AppTextStyles.heading4.copyWith(fontSize: 18),
      ),
    );
  }
}
