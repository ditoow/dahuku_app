import 'package:dahuku_app/features/account/presentation/pages/account_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'core/constants/app_colors.dart';
import 'core/widgets/bottom_navigation_bar.dart';
import 'features/boardingfeature/auth/bloc/auth_bloc.dart';
import 'features/dashboard/bloc/dashboard_bloc.dart';
import 'features/dashboard/bloc/dashboard_event.dart';
import 'features/dashboard/presentation/dashboard_index_page.dart';
import 'features/education/presentation/education_index_page.dart';
import 'features/analytics/presentation/analytics_page.dart';

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
    return BlocProvider(
      create: (_) =>
          GetIt.I<DashboardBloc>()..add(const DashboardLoadRequested()),
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state.status == AuthStatus.unauthenticated) {
            Navigator.pushReplacementNamed(context, '/login');
          }
        },
        child: Scaffold(
          backgroundColor: AppColors.bgPage,
          resizeToAvoidBottomInset:
              false, // Prevent navbar from moving up when keyboard appears
          extendBody: true,
          body: Stack(
            children: [
              // PageView for animated page transitions
              PageView(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                // Swipe enabled - user can swipe left/right to change tabs
                children: const [
                  // Page 0: Dashboard (Beranda)
                  DashboardIndexPage(),
                  // Page 1: Analisis
                  AnalyticsPage(),
                  // Page 2: Education (Edukasi)
                  EducationIndexPage(),
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
        ),
      ),
    );
  }
}
