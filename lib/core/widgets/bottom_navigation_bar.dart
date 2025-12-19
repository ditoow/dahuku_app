import 'dart:ui';
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

/// Navigation item model for bottom nav bar
class NavItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;

  const NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });
}

/// Glassmorphism floating bottom navigation bar with sliding indicator
class DahuKuBottomNavBar extends StatefulWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final VoidCallback? onFabPressed;

  const DahuKuBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.onFabPressed,
  });

  static const List<NavItem> items = [
    NavItem(
      icon: Icons.home_outlined,
      activeIcon: Icons.home,
      label: 'Beranda',
    ),
    NavItem(
      icon: Icons.bar_chart_outlined,
      activeIcon: Icons.bar_chart,
      label: 'Analisis',
    ),
    NavItem(
      icon: Icons.menu_book_outlined,
      activeIcon: Icons.menu_book,
      label: 'Edukasi',
    ),
    NavItem(
      icon: Icons.person_outline,
      activeIcon: Icons.person,
      label: 'Akun',
    ),
  ];

  @override
  State<DahuKuBottomNavBar> createState() => _DahuKuBottomNavBarState();
}

class _DahuKuBottomNavBarState extends State<DahuKuBottomNavBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _stretchAnimation;
  late Animation<double> _positionAnimation;
  int _previousIndex = 0;

  @override
  void initState() {
    super.initState();
    _previousIndex = widget.currentIndex;
    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    // Stretch animation: 1.0 -> 1.6 -> 1.0 (width multiplier for oval effect)
    _stretchAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.6), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 1.6, end: 1.0), weight: 50),
    ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    // Position animation: 0.0 -> 1.0
    _positionAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void didUpdateWidget(DahuKuBottomNavBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentIndex != widget.currentIndex) {
      _previousIndex = oldWidget.currentIndex;
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 40, right: 40, bottom: 20),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.bottomCenter,
        children: [
          // Glassmorphism navbar container
          ClipRRect(
            borderRadius: BorderRadius.circular(28),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: Container(
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(153),
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(
                    color: const Color.fromARGB(
                      255,
                      189,
                      189,
                      189,
                    ).withAlpha(77),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(20),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final itemWidth =
                        constraints.maxWidth / DahuKuBottomNavBar.items.length;
                    final indicatorBaseSize = 44.0;

                    return Stack(
                      alignment: Alignment.center,
                      children: [
                        // Sliding indicator with stretch animation
                        AnimatedBuilder(
                          animation: _controller,
                          builder: (context, child) {
                            final stretchFactor = _stretchAnimation.value;
                            final positionProgress = _positionAnimation.value;

                            // Interpolate position from previous to current index
                            final fromCenter =
                                (_previousIndex * itemWidth) + (itemWidth / 2);
                            final toCenter =
                                (widget.currentIndex * itemWidth) +
                                (itemWidth / 2);
                            final currentCenter =
                                fromCenter +
                                (toCenter - fromCenter) * positionProgress;

                            final indicatorWidth =
                                indicatorBaseSize * stretchFactor;
                            final left = currentCenter - (indicatorWidth / 2);

                            return Positioned(
                              left: left,
                              child: Container(
                                width: indicatorWidth,
                                height: indicatorBaseSize,
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withAlpha(38),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                            );
                          },
                        ),

                        // Nav items row - centered properly
                        Row(
                          children: List.generate(
                            DahuKuBottomNavBar.items.length,
                            (index) {
                              final item = DahuKuBottomNavBar.items[index];
                              final isActive = widget.currentIndex == index;

                              return Expanded(
                                child: _NavBarItem(
                                  icon: isActive ? item.activeIcon : item.icon,
                                  isActive: isActive,
                                  onTap: () => widget.onTap(index),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),

          // Floating Action Button (elevated above navbar)
          Positioned(
            top: -20,
            child: _FloatingRecordButton(onPressed: widget.onFabPressed),
          ),
        ],
      ),
    );
  }
}

/// Individual navigation bar item (icon only, centered)
class _NavBarItem extends StatelessWidget {
  final IconData icon;
  final bool isActive;
  final VoidCallback onTap;

  const _NavBarItem({
    required this.icon,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 60,
        alignment: Alignment.center,
        child: AnimatedScale(
          scale: isActive ? 1.15 : 1.0,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutBack,
          child: Icon(
            icon,
            size: 24,
            color: isActive ? AppColors.primary : AppColors.textLight,
          ),
        ),
      ),
    );
  }
}

/// Floating record button (FAB style) - circular plus icon
class _FloatingRecordButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const _FloatingRecordButton({this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF5C71FF), AppColors.primary],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withAlpha(102),
            blurRadius: 16,
            offset: const Offset(0, 6),
            spreadRadius: 0,
          ),
        ],
        border: Border.all(
          color: const Color.fromARGB(255, 189, 189, 189).withAlpha(77),
          width: 1.5,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        shape: const CircleBorder(),
        child: InkWell(
          onTap: onPressed,
          customBorder: const CircleBorder(),
          child: const Center(
            child: Icon(Icons.add, color: Colors.white, size: 28),
          ),
        ),
      ),
    );
  }
}
