import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

/// Explore item model
class ExploreItem {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color? gradientStart;
  final Color? gradientEnd;
  final bool isGradient;

  const ExploreItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    this.gradientStart,
    this.gradientEnd,
    this.isGradient = false,
  });
}

/// Explore/Education section with horizontal scrolling cards
class ExploreSection extends StatelessWidget {
  final List<ExploreItem> items;
  final ValueChanged<ExploreItem>? onItemTap;

  const ExploreSection({super.key, required this.items, this.onItemTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'Jelajahi',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textMain,
            ),
          ),
        ),
        const SizedBox(height: 12),

        // Cards horizontal list
        SizedBox(
          height: 130,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: items.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.only(
                  right: index < items.length - 1 ? 12 : 0,
                ),
                child: _ExploreCard(
                  item: items[index],
                  onTap: () => onItemTap?.call(items[index]),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

/// Individual explore card
class _ExploreCard extends StatelessWidget {
  final ExploreItem item;
  final VoidCallback? onTap;

  const _ExploreCard({required this.item, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 160,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: item.isGradient
              ? LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    item.gradientStart ?? AppColors.accentPurple,
                    item.gradientEnd ?? AppColors.primary,
                  ],
                )
              : null,
          color: item.isGradient ? null : Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: item.isGradient
                  ? (item.gradientStart ?? AppColors.accentPurple).withOpacity(
                      0.3,
                    )
                  : Colors.black.withOpacity(0.04),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: item.isGradient
                    ? Colors.white.withOpacity(0.2)
                    : AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                item.icon,
                color: item.isGradient ? Colors.white : AppColors.primary,
                size: 18,
              ),
            ),

            const Spacer(), // Use Spacer to push content to the bottom
            // Title
            Text(
              item.title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: item.isGradient ? Colors.white : AppColors.textMain,
              ),
            ),
            const SizedBox(height: 2),

            // Subtitle
            Text(
              item.subtitle,
              style: TextStyle(
                fontSize: 11,
                color: item.isGradient
                    ? Colors.white.withOpacity(0.8)
                    : AppColors.textLight,
                fontWeight: FontWeight.w400,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
