import 'package:flutter/material.dart';

/// Dashboard gradient background widget
/// Provides the purple/violet gradient decorations for the dashboard
class DashboardBackground extends StatelessWidget {
  const DashboardBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Primary gradient background
        Positioned(
          top: -50,
          left: 0,
          right: -80,
          child: Container(
            height: 350,
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment(0.5, -0.5),
                radius: 1.2,
                colors: [
                  Color.fromARGB(106, 211, 100, 255),
                  Color(0xFFF4F1FF),
                  Color.fromARGB(31, 255, 255, 255),
                ],
                stops: [0.0, 0.5, 0.7],
              ),
            ),
          ),
        ),
        // Secondary gradient accent
        Positioned(
          top: 0,
          right: 0,
          child: Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.topRight,
                radius: 1.0,
                colors: [
                  const Color(0xFFD4C4FC).withAlpha(153),
                  const Color.fromARGB(0, 255, 255, 255),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
