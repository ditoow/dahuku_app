import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/theme/app_theme.dart';

// Boarding
import 'features/boardingfeature/splash/presentation/pages/splash_page.dart';
import 'features/boardingfeature/onboarding/presentation/pages/onboarding_page.dart';
import 'features/boardingfeature/auth/presentation/pages/login/login_index_page.dart';
import 'features/boardingfeature/auth/presentation/pages/register/register_index_page.dart';
import 'features/boardingfeature/pin/presentation/pin_index_page.dart';
import 'features/boardingfeature/questionnaire/presentation/questionnaire_index_page.dart';

// Dashboard
import 'main_shell_page.dart';

// Account (punyamu)
import 'features/account/bloc/account_bloc.dart';
import 'features/account/data/repositories/account_repository.dart';
import 'features/account/data/services/account_service.dart';
import 'features/account/data/services/backup_service.dart';
import 'features/account/data/services/local_storage_service.dart';

/// Main app widget with Navigator routes
class DahuKuApp extends StatelessWidget {
  const DahuKuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AccountRepository>(
          create: (_) => AccountRepository(
            accountService: AccountService(),
            backupService: BackupService(),
            localStorageService: LocalStorageService(),
          ),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AccountBloc>(
            create: (context) => AccountBloc(context.read<AccountRepository>()),
          ),
        ],
        child: MaterialApp(
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
            '/dashboard': (context) => const MainShellPage(),
          },
        ),
      ),
    );
  }
}
