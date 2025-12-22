import 'package:flutter/material.dart';
import 'core/constants/app_colors.dart';
import 'core/widgets/bottom_navigation_bar.dart';
import 'features/dashboard/presentation/dashboard_index_page.dart';
import 'features/education/presentation/education_index_page.dart';

/// Main shell page that handles bottom navigation with animated tab switching
/// Uses PageView for smooth transitions synced with navbar indicator animation
class MainShellPage extends StatefulWidget {
  final int initialIndex;

  const MainShellPage({super.key, this.initialIndex = 0});

  @override
  State<MainShellPage> createState() => _MainShellPageState();
}

class _MainShellPageState extends State<MainShellPage> {
  late int _currentIndex;
  late PageController _pageController;

  // Map nav indices to page indices (since not all tabs have pages yet)
  // Nav: 0=Beranda, 1=Analisis, 2=Edukasi, 3=Akun
  // Page: 0=Beranda, 1=Edukasi
  int _navToPageIndex(int navIndex) => navIndex == 2 ? 1 : 0;
  int _pageToNavIndex(int pageIndex) => pageIndex == 1 ? 2 : 0;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(
      initialPage: _navToPageIndex(_currentIndex),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onNavTap(int index) {
    if (index == _currentIndex) return;

    // For tabs that are not yet implemented, show snackbar
    if (index == 1 || index == 3) {
      final labels = ['Beranda', 'Analisis', 'Edukasi', 'Akun'];
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Halaman ${labels[index]} coming soon'),
          duration: const Duration(seconds: 1),
        ),
      );
      return;
    }

    setState(() => _currentIndex = index);

    // Animate to the page with same duration and curve as navbar indicator
    _pageController.animateToPage(
      _navToPageIndex(index),
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  void _onPageChanged(int pageIndex) {
    final navIndex = _pageToNavIndex(pageIndex);
    if (navIndex != _currentIndex) {
      setState(() => _currentIndex = navIndex);
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
          // PageView for animated page transitions
          PageView(
            controller: _pageController,
            onPageChanged: _onPageChanged,
            physics:
                const NeverScrollableScrollPhysics(), // Disable swipe, use navbar only
            children: const [
              // Page 0: Dashboard (Beranda)
              DashboardContent(),
              // Page 1: Education (Edukasi)
              EducationContent(),
            ],
          ),

          // Floating Bottom Navigation Bar
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: DahuKuBottomNavBar(
              currentIndex: _currentIndex,
              onTap: _onNavTap,
              onFabPressed: _onRecordTap,
            ),
          ),
        ],
      ),
    );
  }
}
