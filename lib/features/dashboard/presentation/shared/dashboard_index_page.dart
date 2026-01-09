import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../account/bloc/account_bloc.dart';
import '../../../account/bloc/account_event.dart';
import '../../../account/bloc/offline_mode_cubit.dart';
import '../../bloc/dashboard_bloc.dart';
import '../../bloc/dashboard_event.dart';
import '../../bloc/dashboard_state.dart';
import '../components/dashboard_header.dart';
import '../components/quick_summary_section.dart';
import '../components/recent_transactions_section.dart';
import '../components/wallet_card.dart';
import '../components/dashboard_background.dart';

/// Dashboard main page - integrated with Supabase
/// This version is intended to be used within a shell (no Scaffold/NavBar)
/// Note: DashboardBloc is provided at MainShellPage level for state persistence
class DashboardIndexPage extends StatelessWidget {
  const DashboardIndexPage({super.key});

  @override
  Widget build(BuildContext context) {
    // DashboardBloc is provided by MainShellPage, no need to create here
    return const DashboardContent();
  }
}

/// Dashboard content widget - connected to Supabase via BLoC
class DashboardContent extends StatefulWidget {
  const DashboardContent({super.key});

  @override
  State<DashboardContent> createState() => _DashboardContentState();
}

class _DashboardContentState extends State<DashboardContent> {
  @override
  void initState() {
    super.initState();
    // Use post frame callback to ensure BLoC is ready
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Load account data for the header name
      context.read<AccountBloc>().add(LoadAccount());
      // Refresh dashboard data to get latest wallet balances
      context.read<DashboardBloc>().add(const DashboardRefreshRequested());
    });
  }

  @override
  Widget build(BuildContext context) {
    // Listen for offline mode changes to refresh when going online
    return BlocListener<OfflineModeCubit, bool>(
      listener: (context, isOffline) {
        if (!isOffline) {
          // Just went online - refresh dashboard after a delay
          // to allow sync to complete
          Future.delayed(const Duration(seconds: 3), () {
            if (mounted) {
              print('📱 DASHBOARD: Refreshing after going online');
              context.read<DashboardBloc>().add(
                const DashboardRefreshRequested(),
              );
            }
          });
        }
      },
      child: BlocBuilder<DashboardBloc, DashboardState>(
        builder: (context, state) {
          return Stack(
            children: [
              // Gradient backgrounds
              const DashboardBackground(),

              // Content based on state
              _buildContent(context, state),
            ],
          );
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context, DashboardState state) {
    if (state.status == DashboardStatus.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.status == DashboardStatus.failure) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.red.shade300),
            const SizedBox(height: 16),
            Text(
              'Gagal memuat data',
              style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                context.read<DashboardBloc>().add(
                  const DashboardLoadRequested(),
                );
              },
              child: const Text('Coba Lagi'),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        context.read<DashboardBloc>().add(const DashboardRefreshRequested());
        context.read<AccountBloc>().add(LoadAccount());
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.only(bottom: 120),
        child: SafeArea(
          child: Column(
            children: const [
              SizedBox(height: 12),
              DashboardHeader(),
              SizedBox(height: 42),
              TotalBalanceSection(),
              SizedBox(height: 42),
              WalletCardsSection(),
              SizedBox(height: 12),
              QuickSummarySection(),
              SizedBox(height: 12),
              RecentTransactionsSection(),
              SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
