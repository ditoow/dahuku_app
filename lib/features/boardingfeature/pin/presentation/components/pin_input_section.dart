import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/constants/app_text_styles.dart';
import '../../bloc/pin_bloc.dart';

/// PIN input section - manages its own controller and state
class PinInputSection extends StatefulWidget {
  const PinInputSection({super.key});

  @override
  State<PinInputSection> createState() => PinInputSectionState();
}

class PinInputSectionState extends State<PinInputSection> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // Auto focus on load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  /// Get PIN value for parent access
  String get pin => _controller.text;

  /// Check if PIN is complete
  bool get isComplete => _controller.text.length == 6;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Label
        Text(
          'MASUKKAN 6 DIGIT PIN',
          style: AppTextStyles.labelSmall.copyWith(
            color: AppColors.textSub,
            letterSpacing: 1.5,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),

        // PIN boxes with hidden text field
        GestureDetector(
          onTap: () => _focusNode.requestFocus(),
          child: Column(
            children: [
              // Visual PIN boxes
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(6, (index) {
                  final isFilled = index < _controller.text.length;
                  final isCurrentBox = index == _controller.text.length;

                  return Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 6),
                      height: 56,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: isCurrentBox
                              ? AppColors.primary
                              : isFilled
                              ? AppColors.primary.withValues(alpha: 0.3)
                              : Colors.transparent,
                          width: isCurrentBox ? 2 : 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.04),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Center(
                        child: isFilled
                            ? Container(
                                width: 12,
                                height: 12,
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  shape: BoxShape.circle,
                                ),
                              )
                            : null,
                      ),
                    ),
                  );
                }),
              ),

              // Invisible text field for keyboard input
              Opacity(
                opacity: 0,
                child: SizedBox(
                  height: 1,
                  child: TextField(
                    controller: _controller,
                    focusNode: _focusNode,
                    keyboardType: TextInputType.number,
                    maxLength: 6,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    onChanged: (value) {
                      setState(() {});
                      if (value.length == 6) {
                        context.read<PinBloc>().add(
                          PinDigitEntered(digit: value, isConfirmation: false),
                        );
                      }
                    },
                    autofocus: true,
                    decoration: const InputDecoration(
                      counterText: '',
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
