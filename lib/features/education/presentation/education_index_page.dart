import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/bottom_navigation_bar.dart';
import 'components/comics_sections.dart';

/// Education main page - displays comics list
class EducationIndexPage extends StatefulWidget {
  const EducationIndexPage({super.key});

  @override
  State<EducationIndexPage> createState() => _EducationIndexPageState();
}

class _EducationIndexPageState extends State<EducationIndexPage> {
  final int _currentNavIndex = 2;

  void _onNavTap(int index) {
    if (index != _currentNavIndex) {
      if (index == 0) {
        Navigator.pushReplacementNamed(context, '/dashboard');
      }
    }
  }

  void _onRecordTap() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Catat transaksi baru'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPage,
      extendBody: true,
      body: Stack(
        children: [
          const EducationContent(),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: DahuKuBottomNavBar(
              currentIndex: _currentNavIndex,
              onTap: _onNavTap,
              onFabPressed: _onRecordTap,
            ),
          ),
        ],
      ),
    );
  }
}

/// Education content with smooth header to app bar transition
class EducationContent extends StatefulWidget {
  const EducationContent({super.key});

  @override
  State<EducationContent> createState() => _EducationContentState();
}

class _EducationContentState extends State<EducationContent> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  String _searchQuery = '';
  bool _isSearching = false;
  bool _showTitle = false;

  // Threshold in pixels when title should appear
  static const double _titleShowThreshold = 55.0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final shouldShowTitle = _scrollController.offset > _titleShowThreshold;
    if (shouldShowTitle != _showTitle) {
      setState(() => _showTitle = shouldShowTitle);
    }
  }

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) {
        _searchController.clear();
        _searchQuery = '';
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFF0EDFF), Color(0xFFE8F4FF), Color(0xFFF8F9FE)],
          stops: [0.0, 0.5, 1.0],
        ),
      ),
      child: NestedScrollView(
        controller: _scrollController,
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              expandedHeight: 120,
              floating: false,
              pinned: true,
              elevation: 0,
              shape: _showTitle
                  ? null
                  : const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        bottom: Radius.circular(20),
                      ),
                    ),
              backgroundColor: AppColors.primary,
              surfaceTintColor: Colors.transparent,
              forceElevated: innerBoxIsScrolled,
              automaticallyImplyLeading: false,
              title: _showTitle
                  ? const Text(
                      'Edukasi Keuangan',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    )
                  : null,
              actions: [
                if (_showTitle)
                  IconButton(
                    icon: Icon(
                      _isSearching ? Icons.close_rounded : Icons.search_rounded,
                      color: Colors.white,
                    ),
                    onPressed: _toggleSearch,
                  ),
                const SizedBox(width: 8),
              ],
              flexibleSpace: FlexibleSpaceBar(
                collapseMode: CollapseMode.parallax,
                background: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [AppColors.accentPurple, AppColors.primary],
                      ),
                    ),
                    child: Stack(
                      children: [
                        // Decorative circles
                        Positioned(
                          top: -30,
                          right: -30,
                          child: Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withAlpha(26),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 20,
                          left: -40,
                          child: Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withAlpha(15),
                            ),
                          ),
                        ),

                        // Header content
                        SafeArea(
                          child: Padding(
                            padding: const EdgeInsets.only(
                              top: 28,
                              left: 24,
                              right: 16,
                              bottom: 16,
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withAlpha(51),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: const Icon(
                                    Icons.menu_book_rounded,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                const Expanded(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Edukasi Keuangan',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white,
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        'Belajar kelola uang lewat komik',
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: Colors.white70,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // Search button aligned with header
                                IconButton(
                                  icon: Icon(
                                    _isSearching
                                        ? Icons.close_rounded
                                        : Icons.search_rounded,
                                    color: Colors.white,
                                    size: 26,
                                  ),
                                  onPressed: _toggleSearch,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ];
        },
        body: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 120),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search field below app bar
              if (_isSearching) ...[
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(13),
                          blurRadius: 20,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _searchController,
                      autofocus: true,
                      onChanged: (value) =>
                          setState(() => _searchQuery = value),
                      style: const TextStyle(
                        color: AppColors.textMain,
                        fontSize: 15,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Cari komik...',
                        hintStyle: TextStyle(
                          color: AppColors.textSub.withAlpha(150),
                        ),
                        prefixIcon: Icon(
                          Icons.search_rounded,
                          color: AppColors.primary.withAlpha(180),
                        ),
                        suffixIcon: _searchQuery.isNotEmpty
                            ? IconButton(
                                icon: Icon(
                                  Icons.clear_rounded,
                                  color: AppColors.textSub.withAlpha(150),
                                ),
                                onPressed: () {
                                  _searchController.clear();
                                  setState(() => _searchQuery = '');
                                },
                              )
                            : null,
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                      ),
                    ),
                  ),
                ),
                // Show search results
                AllComicsSection(searchQuery: _searchQuery),
              ] else ...[
                // Featured comics (hide when searching)
                const FeaturedComicsSection(),
                const SizedBox(height: 32),
                // All comics
                AllComicsSection(searchQuery: _searchQuery),
              ],
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
