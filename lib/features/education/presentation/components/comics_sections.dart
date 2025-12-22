import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

/// Featured comics section - horizontal scrollable list
class FeaturedComicsSection extends StatelessWidget {
  const FeaturedComicsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final featuredComics = [
      {
        'title': 'Menabung Sejak Dini',
        'subtitle': 'Episode 1-5',
        'image': 'assets/images/comics/featured_1.png',
        'color': AppColors.accentPurple,
      },
      {
        'title': 'Bijak Mengatur Uang',
        'subtitle': 'Episode 1-3',
        'image': 'assets/images/comics/featured_2.png',
        'color': AppColors.primary,
      },
      {
        'title': 'Jangan Boros!',
        'subtitle': 'Episode 1-4',
        'image': 'assets/images/comics/featured_3.png',
        'color': AppColors.success,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          child: Text(
            'Komik Pilihan',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.textMain,
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 180,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: featuredComics.length,
            itemBuilder: (context, index) {
              final comic = featuredComics[index];
              return _FeaturedComicCard(
                title: comic['title'] as String,
                subtitle: comic['subtitle'] as String,
                color: comic['color'] as Color,
                onTap: () {
                  // Navigate to comic detail
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

class _FeaturedComicCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _FeaturedComicCard({
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      margin: const EdgeInsets.only(right: 16),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [color, color.withAlpha(180)],
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: color.withAlpha(60),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Stack(
              children: [
                // Decorative elements
                Positioned(
                  top: -20,
                  right: -20,
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withAlpha(26),
                    ),
                  ),
                ),
                Positioned(
                  bottom: -30,
                  left: -30,
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withAlpha(15),
                    ),
                  ),
                ),
                // Content
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withAlpha(51),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          subtitle,
                          style: const TextStyle(
                            fontSize: 11,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(
                            Icons.play_circle_fill_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Baca Sekarang',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white.withAlpha(230),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// All comics section - grid view
class AllComicsSection extends StatelessWidget {
  final String searchQuery;

  const AllComicsSection({super.key, this.searchQuery = ''});

  @override
  Widget build(BuildContext context) {
    final allComics = [
      {
        'title': 'Menabung Sejak Dini',
        'episodes': 5,
        'category': 'Tabungan',
        'icon': Icons.savings_rounded,
        'color': AppColors.accentPurple,
      },
      {
        'title': 'Bijak Mengatur Uang',
        'episodes': 3,
        'category': 'Pengelolaan',
        'icon': Icons.account_balance_wallet_rounded,
        'color': AppColors.primary,
      },
      {
        'title': 'Jangan Boros!',
        'episodes': 4,
        'category': 'Pengeluaran',
        'icon': Icons.money_off_rounded,
        'color': AppColors.success,
      },
      {
        'title': 'Apa Itu Investasi?',
        'episodes': 6,
        'category': 'Investasi',
        'icon': Icons.trending_up_rounded,
        'color': AppColors.warning,
      },
      {
        'title': 'Dana Darurat',
        'episodes': 3,
        'category': 'Darurat',
        'icon': Icons.shield_rounded,
        'color': Colors.red,
      },
      {
        'title': 'Hutang & Cicilan',
        'episodes': 4,
        'category': 'Hutang',
        'icon': Icons.credit_card_rounded,
        'color': Colors.teal,
      },
    ];

    // Filter comics based on search query
    final filteredComics = searchQuery.isEmpty
        ? allComics
        : allComics.where((comic) {
            final title = (comic['title'] as String).toLowerCase();
            final category = (comic['category'] as String).toLowerCase();
            final query = searchQuery.toLowerCase();
            return title.contains(query) || category.contains(query);
          }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            searchQuery.isEmpty ? 'Semua Komik' : 'Hasil Pencarian',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.textMain,
            ),
          ),
        ),
        // const SizedBox(height: 16),
        if (filteredComics.isEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.all(40),
              child: Column(
                children: [
                  Icon(
                    Icons.search_off_rounded,
                    size: 64,
                    color: AppColors.textSub.withAlpha(100),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Komik tidak ditemukan',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.textSub.withAlpha(150),
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: GridView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.only(top: 12),
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.85,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: filteredComics.length,
              itemBuilder: (context, index) {
                final comic = filteredComics[index];
                return _ComicCard(
                  title: comic['title'] as String,
                  episodes: comic['episodes'] as int,
                  category: comic['category'] as String,
                  icon: comic['icon'] as IconData,
                  color: comic['color'] as Color,
                  onTap: () {
                    // Navigate to comic detail
                  },
                );
              },
            ),
          ),
      ],
    );
  }
}

class _ComicCard extends StatelessWidget {
  final String title;
  final int episodes;
  final String category;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ComicCard({
    required this.title,
    required this.episodes,
    required this.category,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(13),
                blurRadius: 20,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon header
              Container(
                height: 100,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [color, color.withAlpha(180)],
                  ),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      top: -15,
                      right: -15,
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withAlpha(26),
                        ),
                      ),
                    ),
                    Center(child: Icon(icon, size: 40, color: Colors.white)),
                  ],
                ),
              ),
              // Content
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textMain,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: color.withAlpha(26),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              category,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                                color: color,
                              ),
                            ),
                          ),
                          const Spacer(),
                          Text(
                            '$episodes ep',
                            style: TextStyle(
                              fontSize: 11,
                              color: AppColors.textSub.withAlpha(180),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
