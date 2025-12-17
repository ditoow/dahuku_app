import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/constants/app_colors.dart';
import '../bloc/pin_bloc.dart';
import 'components/pin_app_bar.dart';
import 'components/pin_bottom_section.dart';
import 'components/pin_header.dart';
import 'components/pin_input_section.dart';

/// PIN index page - clean composition of components
class PinIndexPage extends StatefulWidget {
  const PinIndexPage({super.key});

  @override
  State<PinIndexPage> createState() => _PinIndexPageState();
}

class _PinIndexPageState extends State<PinIndexPage> {
  final _pinController = TextEditingController();
  final _pinFocusNode = FocusNode();

  @override
  void dispose() {
    _pinController.dispose();
    _pinFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PinBloc(),
      child: BlocConsumer<PinBloc, PinState>(
        listener: (context, state) {
          if (state.status == PinStatus.success) {
            Navigator.pushReplacementNamed(context, '/questionnaire');
          } else if (state.status == PinStatus.error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage ?? 'Terjadi kesalahan'),
                backgroundColor: AppColors.error,
              ),
            );
          }
        },
        builder: (context, state) {
          return Scaffold(
            backgroundColor: AppColors.bgPage,
            body: Stack(
              children: [
                // Purple gradient background at top
                Positioned(
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
                ),

                // Main content
                SafeArea(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return SingleChildScrollView(
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            minHeight: constraints.maxHeight,
                          ),
                          child: IntrinsicHeight(
                            child: Column(
                              children: [
                                // App Bar
                                const PinAppBar(),

                                // Content
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 24,
                                  ),
                                  child: Column(
                                    children: [
                                      const SizedBox(height: 16),

                                      // Header
                                      const PinHeader(),
                                      const SizedBox(height: 40),

                                      // PIN Input Section
                                      GestureDetector(
                                        onTap: () {
                                          _pinFocusNode.requestFocus();
                                        },
                                        child: PinInputSection(
                                          label: 'MASUKKAN 6 DIGIT PIN',
                                          controller: _pinController,
                                          focusNode: _pinFocusNode,
                                          isActive: true,
                                          onChanged: (value) {
                                            setState(() {});
                                            if (value.length == 6) {
                                              context.read<PinBloc>().add(
                                                PinDigitEntered(
                                                  digit: value,
                                                  isConfirmation: false,
                                                ),
                                              );
                                            }
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // Spacer
                                const Spacer(),

                                // Bottom Section
                                PinBottomSection(
                                  isEnabled: _pinController.text.length == 6,
                                  isLoading: false,
                                  onPressed: () {
                                    if (_pinController.text.length == 6) {
                                      Navigator.pushReplacementNamed(
                                        context,
                                        '/questionnaire',
                                      );
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
