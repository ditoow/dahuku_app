import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import 'core/theme/app_theme.dart';

// Boarding
import 'features/boardingfeature/splash/presentation/pages/splash_page.dart';
import 'features/boardingfeature/onboarding/presentation/pages/onboarding_page.dart';
import 'features/boardingfeature/auth/presentation/pages/login/login_index_page.dart';
import 'features/boardingfeature/auth/presentation/pages/register/register_index_page.dart';
import 'features/boardingfeature/pin/presentation/pin_index_page.dart';
import 'features/boardingfeature/questionnaire/presentation/questionnaire_index_page.dart';
import 'features/boardingfeature/auth/bloc/auth_bloc.dart';

// Dashboard
import 'main_shell_page.dart';
import 'features/dashboard/bloc/dashboard_bloc.dart';
import 'features/dashboard/bloc/dashboard_event.dart';

// Transaction
import 'features/dashboard/transaction/presentation/pages/featurea_index_page.dart';
import 'features/dashboard/pindah_uang/presentation/pindah_uang_page.dart';
import 'features/dashboard/presentation/dompet_page.dart';
import 'features/dashboard/presentation/tabungan_page.dart';
import 'features/dashboard/presentation/darurat_page.dart';

// Account
import 'features/account/bloc/account_bloc.dart';
import 'features/account/bloc/offline_mode_cubit.dart';

// Education
import 'features/education/presentation/comics_detail_page.dart';

// Global Key for Snackbars
final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

/// Main app widget with Navigator routes
class DahuKuApp extends StatelessWidget {
  const DahuKuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (_) => GetIt.I<AuthBloc>()..add(AuthCheckRequested()),
        ),
        BlocProvider<AccountBloc>(create: (_) => GetIt.I<AccountBloc>()),
        BlocProvider<OfflineModeCubit>(
          create: (_) => GetIt.I<OfflineModeCubit>(),
        ),
      ],
      child: MaterialApp(
        scaffoldMessengerKey: rootScaffoldMessengerKey,
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
          '/catat-transaksi': (context) => const FeatureaIndexPage(),
          '/pindah-uang': (context) => BlocProvider(
            create: (_) =>
                GetIt.I<DashboardBloc>()..add(const DashboardLoadRequested()),
            child: const PindahUangPage(),
          ),
          '/dompet': (context) => BlocProvider(
            create: (_) =>
                GetIt.I<DashboardBloc>()..add(const DashboardLoadRequested()),
            child: const DompetPage(),
          ),
          '/tabungan': (context) => BlocProvider(
            create: (_) =>
                GetIt.I<DashboardBloc>()..add(const DashboardLoadRequested()),
            child: const TabunganPage(),
          ),
          '/darurat': (context) => BlocProvider(
            create: (_) =>
                GetIt.I<DashboardBloc>()..add(const DashboardLoadRequested()),
            child: const DaruratPage(),
          ),
          '/comic-detail': (context) {
            final args =
                ModalRoute.of(context)?.settings.arguments
                    as Map<String, dynamic>?;
            final comicId = args?['comicId'] as String? ?? '';
            return ComicsDetailPage(comicId: comicId);
          },
        },
      ),
    );
  }
}
