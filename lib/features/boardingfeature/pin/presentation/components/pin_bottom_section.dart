import 'package:flutter/material.dart';
import '../../../../../../core/widgets/primary_button.dart';

/// Bottom section for PIN page with confirm button
class PinBottomSection extends StatelessWidget {
  final bool isEnabled;
  final bool isLoading;
  final VoidCallback onPressed;

  const PinBottomSection({
    super.key,
    required this.isEnabled,
    required this.isLoading,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      child: PrimaryButton(
        text: 'Konfirmasi PIN',
        icon: Icons.arrow_forward,
        isLoading: isLoading,
        onPressed: isEnabled ? onPressed : null,
      ),
    );
  }
}
