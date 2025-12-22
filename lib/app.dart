import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'features/boardingfeature/splash/presentation/pages/splash_page.dart';
import 'features/boardingfeature/onboarding/presentation/pages/onboarding_page.dart';
import 'features/boardingfeature/auth/presentation/pages/login/login_index_page.dart';
import 'features/boardingfeature/auth/presentation/pages/register/register_index_page.dart';
import 'features/boardingfeature/pin/presentation/pin_index_page.dart';
import 'features/boardingfeature/questionnaire/presentation/questionnaire_index_page.dart';
import 'main_shell_page.dart';

/// Main app widget with Navigator routes
class DahuKuApp extends StatelessWidget {
  const DahuKuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DahuKu',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashPage(),
        '/onboarding': (context) => const OnboardingPage(),
        '/login': (context) => const LoginIndexPage(),
        '/register': (context) => const RegisterIndexPage(),
        '/pin': (context) => const PinIndexPage(),
        '/questionnaire': (context) => const QuestionnaireIndexPage(),
        '/dashboard': (context) => const MainShellPage(initialIndex: 0),
        '/education': (context) => const MainShellPage(initialIndex: 2),
      },
    );
  }
}
