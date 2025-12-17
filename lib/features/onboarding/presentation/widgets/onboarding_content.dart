import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

/// Model for onboarding content
class OnboardingData {
  final String title;
  final String highlightedText;
  final String? subtitle;
  final int pageIndex;

  const OnboardingData({
    required this.title,
    required this.highlightedText,
    this.subtitle,
    required this.pageIndex,
  });
}

/// Widget for onboarding content with different illustrations per page
class OnboardingContent extends StatelessWidget {
  final OnboardingData data;

  const OnboardingContent({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return switch (data.pageIndex) {
      0 => _buildPhoneMockupIllustration(context),
      1 => _buildWalletCardsIllustration(context),
      2 => _buildComicIllustration(context),
      _ => _buildPhoneMockupIllustration(context),
    };
  }

  /// Onboarding 1: Phone mockup with offline mode
  Widget _buildPhoneMockupIllustration(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background blur
          Positioned.fill(
            child: Center(
              child: Container(
                width: 280,
                height: 280,
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    colors: [
                      AppColors.accentPurple.withValues(alpha: 0.15),
                      Colors.transparent,
                    ],
                  ),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),

          // Phone mockup
          Container(
            width: 240,
            height: 380,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(36),
              boxShadow: [
                BoxShadow(
                  color: AppColors.accentPurple.withValues(alpha: 0.15),
                  blurRadius: 40,
                  offset: const Offset(0, 20),
                ),
              ],
              border: Border.all(color: Colors.grey.shade100, width: 1),
            ),
            child: Column(
              children: [
                // Status bar
                Container(
                  height: 48,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(36),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(Icons.menu, size: 20, color: Colors.grey.shade400),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.wifi_off,
                              size: 12,
                              color: Colors.red.shade500,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'OFFLINE',
                              style: TextStyle(
                                fontSize: 8,
                                fontWeight: FontWeight.bold,
                                color: Colors.red.shade500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Content
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    color: Colors.grey.shade50.withValues(alpha: 0.5),
                    child: Column(
                      children: [
                        // Balance card
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            gradient: AppColors.cardGradient,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withValues(alpha: 0.3),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Total Saldo',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.white.withValues(alpha: 0.8),
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                'Rp 2.500.000',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Transaction items
                        _buildTransactionRow(
                          Icons.arrow_downward,
                          Colors.purple.shade50,
                          AppColors.accentPurple,
                        ),
                        const SizedBox(height: 10),
                        _buildTransactionRow(
                          Icons.arrow_upward,
                          Colors.blue.shade50,
                          AppColors.primary,
                        ),

                        const Spacer(),

                        // FAB
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: const Color(0xFF1A1A1A),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.2),
                                  blurRadius: 8,
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 22,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Floating cloud off icon (top right)
          Positioned(
            top: 30,
            right: 30,
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.accentPurple.withValues(alpha: 0.2),
                    blurRadius: 16,
                  ),
                ],
              ),
              child: Icon(
                Icons.cloud_off,
                color: AppColors.accentPurple,
                size: 28,
              ),
            ),
          ),

          // "Tersimpan" badge (bottom left)
          Positioned(
            bottom: 60,
            left: 10,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    blurRadius: 12,
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: Colors.green.shade100,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.check,
                      size: 14,
                      color: Colors.green.shade600,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Tersimpan',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionRow(IconData icon, Color bgColor, Color iconColor) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
            child: Icon(icon, size: 18, color: iconColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 8,
                  width: 60,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  height: 6,
                  width: 40,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 8,
            width: 50,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ],
      ),
    );
  }

  /// Onboarding 2: Three wallet cards floating
  Widget _buildWalletCardsIllustration(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background blur
          Positioned.fill(
            child: Center(
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    colors: [
                      AppColors.primary.withValues(alpha: 0.08),
                      Colors.transparent,
                    ],
                  ),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),

          // BELANJA card (top left, tilted)
          Positioned(
            top: 20,
            left: 20,
            child: Transform.rotate(
              angle: -0.15,
              child: _buildWalletCard(
                'BELANJA',
                'Rp 1.5jt',
                Icons.shopping_bag,
                Colors.pink.shade50,
                Colors.pink,
                Colors.pink.shade300,
                120,
              ),
            ),
          ),

          // TABUNGAN card (center, main)
          Center(
            child: _buildWalletCard(
              'TABUNGAN',
              'Rp 5.000k',
              Icons.savings,
              Colors.white,
              AppColors.primary,
              AppColors.primary,
              160,
              isMain: true,
            ),
          ),

          // DARURAT card (bottom right, tilted)
          Positioned(
            bottom: 40,
            right: 20,
            child: Transform.rotate(
              angle: 0.1,
              child: _buildWalletCard(
                'DARURAT',
                'Rp 10jt',
                Icons.shield,
                Colors.white,
                AppColors.accentPurple,
                AppColors.accentPurple,
                110,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWalletCard(
    String label,
    String amount,
    IconData icon,
    Color bgColor,
    Color iconColor,
    Color progressColor,
    double width, {
    bool isMain = false,
  }) {
    return Container(
      width: width,
      padding: EdgeInsets.all(isMain ? 20 : 14),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(isMain ? 24 : 18),
        boxShadow: [
          BoxShadow(
            color: iconColor.withValues(alpha: isMain ? 0.2 : 0.1),
            blurRadius: isMain ? 24 : 12,
            offset: Offset(0, isMain ? 8 : 4),
          ),
        ],
        border: Border.all(
          color: isMain ? Colors.grey.shade100 : Colors.transparent,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isMain) ...[
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, color: Colors.white, size: 28),
            ),
            const SizedBox(height: 12),
          ] else ...[
            Row(
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: iconColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: iconColor, size: 16),
                ),
              ],
            ),
            const SizedBox(height: 6),
          ],
          Text(
            label,
            style: TextStyle(
              fontSize: isMain ? 12 : 9,
              fontWeight: FontWeight.w600,
              color: iconColor,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            amount,
            style: TextStyle(
              fontSize: isMain ? 22 : 14,
              fontWeight: FontWeight.bold,
              color: isMain ? AppColors.textMain : Colors.grey.shade700,
            ),
          ),
          if (isMain) ...[
            const SizedBox(height: 12),
            Container(
              height: 6,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(3),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: 0.7,
                child: Container(
                  decoration: BoxDecoration(
                    color: progressColor,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
            ),
          ] else ...[
            const SizedBox(height: 8),
            Container(
              height: 4,
              decoration: BoxDecoration(
                color: progressColor.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: 0.5,
                child: Container(
                  decoration: BoxDecoration(
                    color: progressColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// Onboarding 3: Comic learning illustration
  Widget _buildComicIllustration(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Main gradient card
          Container(
            width: double.infinity,
            height: 320,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFD4A574), Color(0xFFB8860B)],
              ),
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFB8860B).withValues(alpha: 0.3),
                  blurRadius: 24,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
          ),

          // Trophy icon (bottom left, floating)
          Positioned(
            bottom: 80,
            left: 10,
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 12,
                  ),
                ],
              ),
              child: Icon(
                Icons.emoji_events,
                color: AppColors.primary,
                size: 26,
              ),
            ),
          ),

          // Book icon (top right, floating)
          Positioned(
            top: 40,
            right: 10,
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 12,
                  ),
                ],
              ),
              child: Icon(
                Icons.menu_book,
                color: AppColors.accentPurple,
                size: 26,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
