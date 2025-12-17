import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/bottom_navigation_bar.dart';
import 'components/dashboard_header.dart';
import 'components/wallet_card.dart';
import 'components/quick_summary_section.dart';
import 'components/recent_transactions_section.dart';
import 'components/explore_section.dart';

/// Dashboard main page - composes all dashboard sections
class DashboardIndexPage extends StatefulWidget {
  const DashboardIndexPage({super.key});

  @override
  State<DashboardIndexPage> createState() => _DashboardIndexPageState();
}

class _DashboardIndexPageState extends State<DashboardIndexPage> {
  int _currentNavIndex = 0;

  // Sample data - in production, this would come from a BLoC/Provider
  final List<WalletData> _wallets = const [
    WalletData(
      type: WalletType.belanja,
      name: 'Belanja',
      balance: 2150000,
      isPrimary: true,
    ),
    WalletData(type: WalletType.tabungan, name: 'Tabungan', balance: 8500000),
    WalletData(type: WalletType.darurat, name: 'Darurat', balance: 1900000),
  ];

  final List<TransactionData> _transactions = [
    TransactionData(
      id: '1',
      title: 'Makan Siang',
      wallet: 'Dompet Belanja',
      timeAgo: 'Hari ini',
      amount: 45000,
      type: TransactionType.expense,
      icon: Icons.restaurant_outlined,
      iconColor: const Color(0xFFFF6B6B),
    ),
    TransactionData(
      id: '2',
      title: 'Isi Bensin',
      wallet: 'Dompet Belanja',
      timeAgo: 'Kemarin',
      amount: 30000,
      type: TransactionType.expense,
      icon: Icons.local_gas_station_outlined,
      iconColor: const Color(0xFF4ECDC4),
    ),
    TransactionData(
      id: '3',
      title: 'Gajian Freelance',
      wallet: 'Dompet Tabungan',
      timeAgo: '2 Hari lalu',
      amount: 1500000,
      type: TransactionType.income,
      icon: Icons.attach_money_rounded,
      iconColor: const Color(0xFF10B981),
    ),
  ];

  final List<ExploreItem> _exploreItems = const [
    ExploreItem(
      title: 'Belajar Keuangan',
      subtitle: 'Modul & Tips Praktis',
      icon: Icons.menu_book_outlined,
      isGradient: true,
      gradientStart: Color(0xFF8B5CF6),
      gradientEnd: Color(0xFF6366F1),
    ),
    ExploreItem(
      title: 'Riwayat Lengkap',
      subtitle: 'Lihat arus kasmu',
      icon: Icons.history_outlined,
      isGradient: false,
    ),
  ];

  double get _totalBalance =>
      _wallets.fold(0, (sum, wallet) => sum + wallet.balance);

  void _onNavTap(int index) {
    if (index == 2) return; // FAB position
    setState(() => _currentNavIndex = index);
  }

  void _onRecordTap() {
    // TODO: Navigate to record transaction page
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
      body: Stack(
        children: [
          // Purple gradient background at top
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 280,
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.topCenter,
                  radius: 1.5,
                  colors: [
                    const Color(0xFFE8E0FF),
                    const Color(0xFFF4F1FF),
                    AppColors.bgPage,
                  ],
                ),
              ),
            ),
          ),

          // Main content
          SafeArea(
            bottom: false,
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),

                  // Header
                  DashboardHeader(
                    userName: 'Alexandria',
                    totalBalance: _totalBalance,
                    onNotificationTap: () {
                      // TODO: Navigate to notifications
                    },
                  ),
                  const SizedBox(height: 24),

                  // Wallet Cards
                  WalletCardsSection(
                    wallets: _wallets,
                    onWalletTap: (wallet) {
                      // TODO: Navigate to wallet detail
                    },
                  ),
                  const SizedBox(height: 24),

                  // Quick Summary
                  QuickSummarySection(
                    weeklyExpense: 1200000,
                    remainingBudgetPercent: 45,
                    onViewAll: () {
                      // TODO: Navigate to analytics
                    },
                  ),
                  const SizedBox(height: 24),

                  // Recent Transactions
                  RecentTransactionsSection(
                    transactions: _transactions,
                    onViewAll: () {
                      // TODO: Navigate to all transactions
                    },
                  ),
                  const SizedBox(height: 24),

                  // Explore Section
                  ExploreSection(
                    items: _exploreItems,
                    onItemTap: (item) {
                      // TODO: Navigate to explore item
                    },
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: DahuKuBottomNavBar(
        currentIndex: _currentNavIndex,
        onTap: _onNavTap,
        onFabPressed: _onRecordTap,
      ),
    );
  }
}
