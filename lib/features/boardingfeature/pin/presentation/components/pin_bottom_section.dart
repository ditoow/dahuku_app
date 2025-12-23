import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../core/widgets/primary_button.dart';
import '../../bloc/pin_bloc.dart';

/// Bottom section for PIN page - gets state from BLoC
class PinBottomSection extends StatelessWidget {
  final String Function() getPin;

  const PinBottomSection({super.key, required this.getPin});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PinBloc, PinState>(
      builder: (context, state) {
        final pin = getPin();
        final isEnabled = pin.length == 6;
        final isLoading = false; // PIN doesn't have loading state

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
          child: PrimaryButton(
            text: 'Konfirmasi PIN',
            icon: Icons.arrow_forward,
            isLoading: isLoading,
            onPressed: isEnabled
                ? () {
                    Navigator.pushReplacementNamed(context, '/questionnaire');
                  }
                : null,
          ),
        );
      },
    );
  }
}
