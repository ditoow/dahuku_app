import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/bottom_navigation_bar.dart';
import 'components/dashboard_header.dart';
import 'components/wallet_card.dart';
import 'components/quick_summary_section.dart';
import 'components/recent_transactions_section.dart';

/// Dashboard main page - matches HTML mockup design
class DashboardIndexPage extends StatefulWidget {
  const DashboardIndexPage({super.key});

  @override
  State<DashboardIndexPage> createState() => _DashboardIndexPageState();
}

class _DashboardIndexPageState extends State<DashboardIndexPage> {
  int _currentNavIndex = 0;

  void _onNavTap(int index) {
    if (index == _currentNavIndex) return;

    switch (index) {
      case 0:
        break;
      case 1:
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Halaman Analisis coming soon')),
        );
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/education');
        break;
      case 3:
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Halaman Akun coming soon')),
        );
        break;
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
          const DashboardContent(),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: DahuKuBottomNavBar(
              currentIndex: _currentNavIndex,
              onTap: _onNavTap,
              onFabPressed: _onRecordTap,
            ),
          ),
        ],
      ),
    );
  }
}

/// Dashboard content widget - can be used standalone in MainShellPage
class DashboardContent extends StatelessWidget {
  const DashboardContent({super.key});

  static const List<WalletData> _wallets = [
    WalletData(
      type: WalletType.belanja,
      name: 'Belanja',
      balance: 2150000,
      isPrimary: true,
    ),
    WalletData(type: WalletType.tabungan, name: 'Tabungan', balance: 8000000),
    WalletData(
      type: WalletType.darurat,
      name: 'Dana Darurat',
      balance: 2400000,
    ),
  ];

  static final List<TransactionData> _transactions = [
    TransactionData(
      id: '1',
      title: 'Makan Siang',
      subtitle: 'Hari ini, 12:30',
      amount: 45000,
      type: TransactionType.expense,
      icon: Icons.lunch_dining,
      iconBgColor: Colors.orange.shade50,
      iconColor: Colors.orange.shade500,
    ),
    TransactionData(
      id: '2',
      title: 'Grab Ride',
      subtitle: 'Kemarin',
      amount: 25000,
      type: TransactionType.expense,
      icon: Icons.local_taxi,
      iconBgColor: Colors.blue.shade50,
      iconColor: AppColors.primary,
    ),
    TransactionData(
      id: '3',
      title: 'Project Desain',
      subtitle: '20 Okt 2023',
      amount: 1500000,
      type: TransactionType.income,
      icon: Icons.work,
      iconBgColor: Colors.green.shade50,
      iconColor: Colors.green.shade600,
    ),
  ];

  double get _totalBalance =>
      _wallets.fold(0, (sum, wallet) => sum + wallet.balance);

  @override
  Widget build(BuildContext context) {
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

        // Main scrollable content
        SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 120),
          child: SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 12),
                const DashboardHeader(userName: 'Alexandria'),
                const SizedBox(height: 42),
                TotalBalanceSection(
                  totalBalance: _totalBalance,
                  percentChange: 2.5,
                ),
                const SizedBox(height: 42),
                WalletCardsSection(
                  wallets: _wallets,
                  onWalletTap: (wallet) {},
                  onViewAll: () {},
                ),
                const SizedBox(height: 12),
                QuickSummarySection(
                  weeklyExpense: 450000,
                  remainingBudget: 1200000,
                  budgetProgress: 0.65,
                  onLearnTap: () {},
                  onHistoryTap: () {},
                ),
                const SizedBox(height: 32),
                RecentTransactionsSection(
                  transactions: _transactions,
                  onViewAll: () {},
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
