import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_text_styles.dart';
import '../../../../../core/widgets/primary_button.dart';
import '../../bloc/onboarding_bloc.dart';
import '../widgets/onboarding_content.dart';

/// Onboarding page with 3 slides
class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();

  final List<OnboardingData> _pages = const [
    OnboardingData(
      title: 'Catat Uang Masuk & Keluar Kapan Saja,',
      highlightedText: 'Bahkan Tanpa Internet',
      pageIndex: 0,
    ),
    OnboardingData(
      title: 'Pisahkan Uangmu untuk',
      highlightedText: 'Belanja, Tabungan, dan Darurat',
      pageIndex: 1,
    ),
    OnboardingData(
      title: 'Belajar Keuangan Jadi Mudah Lewat',
      highlightedText: 'Komik Interaktif',
      subtitle:
          'Pahami konsep finansial yang rumit dengan cerita bergambar yang seru dan mudah dipahami.',
      pageIndex: 2,
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OnboardingBloc(),
      child: BlocConsumer<OnboardingBloc, OnboardingState>(
        listener: (context, state) {
          if (state.isCompleted) {
            Navigator.pushReplacementNamed(context, '/register');
          } else {
            _pageController.animateToPage(
              state.currentPage,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          }
        },
        builder: (context, state) {
          final isLastPage = state.currentPage == 2;

          return Scaffold(
            backgroundColor: Colors.white,
            body: Stack(
              children: [
                // Background decorations
                Positioned(
                  top: -MediaQuery.of(context).size.width * 0.05,
                  right: -MediaQuery.of(context).size.width * 0.1,
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: MediaQuery.of(context).size.width * 0.9,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [const Color(0xFFF4F1FF), Colors.transparent],
                      ),
                    ),
                  ),
                ),

                // Skip button (only on last page)
                if (isLastPage)
                  Positioned(
                    top: MediaQuery.of(context).padding.top + 16,
                    right: 24,
                    child: TextButton(
                      onPressed: () {
                        context.read<OnboardingBloc>().add(
                          OnboardingSkipPressed(),
                        );
                      },
                      child: Text(
                        'Lewati',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                // Main content
                SafeArea(
                  child: Column(
                    children: [
                      const SizedBox(height: 20),

                      // PageView for illustrations
                      Expanded(
                        child: PageView.builder(
                          controller: _pageController,
                          onPageChanged: (index) {
                            context.read<OnboardingBloc>().add(
                              OnboardingPageChanged(index),
                            );
                          },
                          itemCount: _pages.length,
                          itemBuilder: (context, index) {
                            return OnboardingContent(data: _pages[index]);
                          },
                        ),
                      ),

                      // Bottom section with indicators, text, and button
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.9),
                        ),
                        child: Column(
                          children: [
                            // Page indicators
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(
                                _pages.length,
                                (index) => AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 4,
                                  ),
                                  width: state.currentPage == index ? 28 : 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: state.currentPage == index
                                        ? AppColors.primary
                                        : Colors.grey.shade300,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 28),

                            // Title
                            Text(
                              _pages[state.currentPage].title,
                              style: AppTextStyles.heading2.copyWith(
                                fontSize: 24,
                                height: 1.3,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              _pages[state.currentPage].highlightedText,
                              style: AppTextStyles.heading2.copyWith(
                                fontSize: 24,
                                height: 1.3,
                                color: AppColors.primary,
                              ),
                              textAlign: TextAlign.center,
                            ),

                            // Subtitle (only on page 3)
                            if (_pages[state.currentPage].subtitle != null) ...[
                              const SizedBox(height: 12),
                              Text(
                                _pages[state.currentPage].subtitle!,
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: AppColors.textSub,
                                  height: 1.5,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                            const SizedBox(height: 28),

                            // Button
                            PrimaryButton(
                              text: isLastPage ? 'Mulai Sekarang' : 'Lanjut',
                              icon: Icons.arrow_forward,
                              onPressed: () {
                                context.read<OnboardingBloc>().add(
                                  OnboardingNextPressed(),
                                );
                              },
                            ),
                            const SizedBox(height: 40),
                          ],
                        ),
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
}
