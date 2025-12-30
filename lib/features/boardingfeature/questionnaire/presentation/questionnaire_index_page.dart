import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import '../../../../../core/constants/app_colors.dart';
import '../bloc/questionnaire_bloc.dart';
import 'components/debt_input_section.dart';
import 'components/questionnaire_app_bar.dart';
import 'components/questionnaire_bottom_section.dart';
import 'components/questionnaire_header.dart';
import 'components/questionnaire_option_card.dart';
import 'components/questionnaire_progress.dart';
import 'components/wallet_balance_inputs_section.dart';

/// Questionnaire data model
class QuestionData {
  final IconData icon;
  final String question;
  final String subtitle;
  final List<OptionData>? options;
  final bool isWalletInput;
  final bool isDebtInput;

  const QuestionData({
    required this.icon,
    required this.question,
    required this.subtitle,
    this.options,
    this.isWalletInput = false,
    this.isDebtInput = false,
  });
}

class OptionData {
  final String text;
  final IconData icon;

  const OptionData({required this.text, required this.icon});
}

/// Questionnaire index page - clean composition of components
class QuestionnaireIndexPage extends StatefulWidget {
  const QuestionnaireIndexPage({super.key});

  @override
  State<QuestionnaireIndexPage> createState() => _QuestionnaireIndexPageState();
}

class _QuestionnaireIndexPageState extends State<QuestionnaireIndexPage> {
  final _walletInputsKey = GlobalKey<WalletBalanceInputsSectionState>();
  final _debtInputsKey = GlobalKey<DebtInputSectionState>();

  static const List<QuestionData> _questions = [
    QuestionData(
      icon: Icons.savings_outlined,
      question: 'Apa tujuan utama keuangan Anda?',
      subtitle: 'Pilih yang paling sesuai dengan kondisi Anda saat ini.',
      options: [
        OptionData(
          text: 'Mengatur pengeluaran harian',
          icon: Icons.shopping_bag_outlined,
        ),
        OptionData(
          text: 'Menabung untuk masa depan',
          icon: Icons.account_balance_outlined,
        ),
        OptionData(
          text: 'Mempersiapkan dana darurat',
          icon: Icons.security_outlined,
        ),
        OptionData(text: 'Belajar mengelola uang', icon: Icons.school_outlined),
      ],
    ),
    QuestionData(
      icon: Icons.wallet_outlined,
      question: 'Masukkan Saldo Awal Dompet',
      subtitle: 'Atur saldo awal untuk ketiga dompet Anda.',
      isWalletInput: true,
    ),
    QuestionData(
      icon: Icons.money_off_outlined,
      question: 'Apakah Anda memiliki hutang?',
      subtitle: 'Informasi ini opsional dan membantu kami memberikan saran.',
      isDebtInput: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetIt.I<QuestionnaireBloc>(),
      child: BlocConsumer<QuestionnaireBloc, QuestionnaireState>(
        listener: (context, state) async {
          if (state.status == QuestionnaireStatus.completed) {
            // Small delay to ensure database transaction is committed
            await Future.delayed(const Duration(milliseconds: 300));
            if (context.mounted) {
              Navigator.pushReplacementNamed(context, '/dashboard');
            }
          }
        },
        builder: (context, state) {
          final currentQuestion = _questions[state.currentQuestionIndex];

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
                    height: 300,
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
                  child: Column(
                    children: [
                      // App Bar
                      const QuestionnaireAppBar(),

                      // Progress
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: QuestionnaireProgress(
                          currentStep: state.currentQuestionIndex,
                          totalSteps: _questions.length,
                        ),
                      ),

                      // Scrollable content
                      Expanded(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Column(
                            children: [
                              const SizedBox(height: 24),

                              // Header
                              QuestionnaireHeader(
                                icon: currentQuestion.icon,
                                question: currentQuestion.question,
                                subtitle: currentQuestion.subtitle,
                              ),
                              const SizedBox(height: 32),

                              // Content based on question type
                              if (currentQuestion.isWalletInput)
                                WalletBalanceInputsSection(
                                  key: _walletInputsKey,
                                  onChanged: () => setState(() {}),
                                )
                              else if (currentQuestion.isDebtInput)
                                DebtInputSection(key: _debtInputsKey)
                              else if (currentQuestion.options != null)
                                _buildOptions(context, state, currentQuestion),

                              const SizedBox(height: 16),
                            ],
                          ),
                        ),
                      ),

                      // Bottom Section - gets state from BLoC
                      QuestionnaireBottomSection(
                        totalQuestions: _questions.length,
                        walletInputsKey: _walletInputsKey,
                        debtInputsKey: _debtInputsKey,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildOptions(
    BuildContext context,
    QuestionnaireState state,
    QuestionData currentQuestion,
  ) {
    return Column(
      children: currentQuestion.options!.asMap().entries.map((entry) {
        final index = entry.key;
        final option = entry.value;
        final isSelected = state.answers[state.currentQuestionIndex] == index;

        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: QuestionnaireOptionCard(
            text: option.text,
            icon: option.icon,
            isSelected: isSelected,
            onTap: () {
              context.read<QuestionnaireBloc>().add(
                QuestionnaireAnswerSelected(
                  questionIndex: state.currentQuestionIndex,
                  answerIndex: index,
                ),
              );
            },
          ),
        );
      }).toList(),
    );
  }
}
