import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../account/bloc/account_bloc.dart';
import '../../account/bloc/account_event.dart';
import '../bloc/dashboard_bloc.dart';
import '../bloc/dashboard_event.dart';
import '../bloc/dashboard_state.dart';
import 'components/dashboard_header.dart';
import 'components/quick_summary_section.dart';
import 'components/recent_transactions_section.dart';
import 'components/wallet_card.dart';

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
    // Load account data for the header name
    context.read<AccountBloc>().add(LoadAccount());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardBloc, DashboardState>(
      builder: (context, state) {
        return Stack(
          children: [
            // Gradient backgrounds
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

            // Content based on state
            _buildContent(context, state),
          ],
        );
      },
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
              SizedBox(height: 32),
              RecentTransactionsSection(),
              SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
