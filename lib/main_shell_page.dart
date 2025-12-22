import 'package:dahuku_app/features/account/presentation/pages/account_page.dart';
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

  // Map nav indices to page indices
  // Nav: 0=Beranda, 1=Analisis, 2=Edukasi, 3=Akun
  // Page: 0=Beranda, 1=Analisis, 2=Edukasi, 3=Akun
  int _navToPageIndex(int navIndex) => navIndex;
  int _pageToNavIndex(int pageIndex) => pageIndex;

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
    Navigator.pushNamed(context, '/catat-transaksi');
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
              // Page 1: Analisis
              _AnalisisPlaceholder(),
              // Page 2: Education (Edukasi)
              EducationContent(),
              // Page 3: Account (Akun)
              AccountPage(),
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

/// Placeholder widget for Analisis page
class _AnalisisPlaceholder extends StatelessWidget {
  const _AnalisisPlaceholder();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'Halaman Analisis',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
