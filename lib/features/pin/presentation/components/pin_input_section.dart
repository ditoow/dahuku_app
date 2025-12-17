import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_text_styles.dart';

/// PIN input section with text field and number keyboard
class PinInputSection extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final FocusNode focusNode;
  final bool isActive;
  final ValueChanged<String>? onChanged;

  const PinInputSection({
    super.key,
    required this.label,
    required this.controller,
    required this.focusNode,
    required this.isActive,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Label
        Text(
          label,
          style: AppTextStyles.labelSmall.copyWith(
            color: AppColors.textSub,
            letterSpacing: 1.5,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),

        // PIN boxes with hidden text field
        GestureDetector(
          onTap: () => focusNode.requestFocus(),
          child: Column(
            children: [
              // Visual PIN boxes
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(6, (index) {
                  final isFilled = index < controller.text.length;
                  final isCurrentBox =
                      index == controller.text.length && isActive;

                  return Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 6),
                      height: 56,
                      decoration: BoxDecoration(
                        color: isActive
                            ? Colors.white
                            : const Color(0xFFF5F5F8),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: isCurrentBox
                              ? AppColors.primary
                              : isFilled
                              ? AppColors.primary.withValues(alpha: 0.3)
                              : Colors.transparent,
                          width: isCurrentBox ? 2 : 1,
                        ),
                        boxShadow: isActive
                            ? [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.04),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ]
                            : null,
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
                    controller: controller,
                    focusNode: focusNode,
                    keyboardType: TextInputType.number,
                    maxLength: 6,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    onChanged: onChanged,
                    autofocus: isActive,
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
