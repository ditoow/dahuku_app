import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AnalyticsPage extends StatefulWidget {
  const AnalyticsPage({super.key});

  @override
  State<AnalyticsPage> createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends State<AnalyticsPage> {
  // State untuk tabungan dan hutang
  List<Map<String, dynamic>> savingsGoals = [
    {'name': 'MacBook Pro M3', 'progress': 0.75, 'current': 18000000, 'target': 24000000}
  ];
  List<Map<String, dynamic>> debts = [
    {'name': 'PayLater Belanja', 'amount': 750000, 'dueDate': '25 Nov', 'interest': 2.5}
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),
      body: Stack(
        children: [
          // Header gradient background
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 300,
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFE0D4FC), Color(0xFFF1EAFF), Colors.transparent],
                  stops: [0.0, 0.4, 0.7],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 12, 24, 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Analisis Keuangan',
                            style: GoogleFonts.poppins(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Pantau dan kendalikan keuanganmu',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF9E9E9E),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 20,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.insert_chart,
                          color: Color(0xFF304AFF),
                        ),
                      ),
                    ],
                  ),
                ),
                // Main content
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        // Total Pengeluaran Section
                        Container(
                          margin: const EdgeInsets.only(bottom: 24),
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Color(0xFF5E60CE), Color(0xFF304AFF)],
                            ),
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF304AFF).withOpacity(0.3),
                                blurRadius: 20,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Total Pengeluaran Bulan Ini',
                                        style: GoogleFonts.poppins(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color: const Color(0xFFBBDEFB),
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Rp 4.250.000',
                                        style: GoogleFonts.poppins(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        'Sisa Anggaran',
                                        style: GoogleFonts.poppins(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color: const Color(0xFFBBDEFB),
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '+Rp 1.8jt',
                                        style: GoogleFonts.poppins(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                          color: const Color(0xFFA788FD),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 24),
                              // Bar chart
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  _buildExpenseBar('Snack', 0.4, false),
                                  _buildExpenseBar('Makan', 0.75, false),
                                  _buildExpenseBar('Belanja', 1.0, true),
                                  _buildExpenseBar('Trans', 0.5, false),
                                  _buildExpenseBar('Lain', 0.3, false),
                                ],
                              ),
                              const SizedBox(height: 16),
                              // Insight box
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.1),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.lightbulb,
                                      color: Colors.yellow,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        'Insight: Pengeluaran kategori Belanja meningkat 25% dibanding minggu lalu.',
                                        style: GoogleFonts.poppins(
                                          fontSize: 12,
                                          color: const Color(0xFFE3F2FD),
                                          height: 1.4,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Target Tabungan Section
                        Container(
                          margin: const EdgeInsets.only(bottom: 24),
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.08),
                                blurRadius: 30,
                                offset: const Offset(0, 10),
                              ),
                            ],
                            border: Border.all(color: const Color(0xFFF5F5F5)),
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFC8E6C9),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: const Icon(
                                          Icons.savings,
                                          color: Colors.green,
                                          size: 20,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Text(
                                        'Target Tabungan',
                                        style: GoogleFonts.poppins(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ],
                                  ),
                                  ElevatedButton(
                                    onPressed: _showAddSavingsDialog,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF304AFF).withOpacity(0.1),
                                      foregroundColor: const Color(0xFF304AFF),
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      textStyle: GoogleFonts.poppins(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    child: const Text('+ Buat Baru'),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              ...savingsGoals.map((goal) {
                                return Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          goal['name'],
                                          style: GoogleFonts.poppins(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black87,
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFE8F5E8),
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          child: Text(
                                            '${(goal['progress'] * 100).toInt()}%',
                                            style: GoogleFonts.poppins(
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                              color: const Color(0xFF43A047),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    LinearProgressIndicator(
                                      value: goal['progress'],
                                      backgroundColor: const Color(0xFFEEEEEE),
                                      valueColor: const AlwaysStoppedAnimation<Color>(
                                        Color(0xFF66BB6A),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Terkumpul: Rp ${goal['current'].toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}',
                                          style: GoogleFonts.poppins(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                            color: const Color(0xFF9E9E9E),
                                          ),
                                        ),
                                        Text(
                                          'Target: Rp ${goal['target'].toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}',
                                          style: GoogleFonts.poppins(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                            color: const Color(0xFF9E9E9E),
                                          ),
                                        ),
                                      ],
                                    ),
                                    if (savingsGoals.length > 1) const SizedBox(height: 16),
                                  ],
                                );
                              }).toList(),
                              const SizedBox(height: 16),
                              const Divider(),
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        width: 32,
                                        height: 32,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFF5F5F5),
                                          borderRadius: BorderRadius.circular(16),
                                        ),
                                        child: const Icon(
                                          Icons.history,
                                          color: const Color(0xFFBDBDBD),
                                          size: 16,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Terakhir setor',
                                            style: GoogleFonts.poppins(
                                              fontSize: 10,
                                              color: const Color(0xFFBDBDBD),
                                            ),
                                          ),
                                          Text(
                                            'Rp 500.000 (Kemarin)',
                                            style: GoogleFonts.poppins(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black87,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Switch(
                                    value: true,
                                    onChanged: (value) {},
                                    activeColor: const Color(0xFF00BFA6),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        // Manajemen Hutang Section
                        Container(
                          margin: const EdgeInsets.only(bottom: 24),
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.08),
                                blurRadius: 30,
                                offset: const Offset(0, 10),
                              ),
                            ],
                            border: Border.all(color: const Color(0xFFFFB946).withOpacity(0.3)),
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFFFE0B2),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: const Icon(
                                          Icons.credit_card_off,
                                          color: Colors.orange,
                                          size: 20,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Text(
                                        'Manajemen Hutang',
                                        style: GoogleFonts.poppins(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ],
                                  ),
                                  TextButton(
                                    onPressed: _showAddDebtDialog,
                                    child: Text(
                                      '+ Hutang',
                                      style: GoogleFonts.poppins(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: const Color(0xFF304AFF),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              ...debts.map((debt) {
                                return Container(
                                  margin: const EdgeInsets.only(bottom: 12),
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFAFAFA),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: const Color(0xFFF5F5F5)),
                                  ),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                debt['name'],
                                                style: GoogleFonts.poppins(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black87,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Row(
                                                children: [
                                                  const Icon(
                                                    Icons.calendar_today,
                                                    size: 12,
                                                    color: Colors.red,
                                                  ),
                                                  const SizedBox(width: 4),
                                                  Text(
                                                    'Jatuh tempo: ${debt['dueDate']}',
                                                    style: GoogleFonts.poppins(
                                                      fontSize: 10,
                                                      color: const Color(0xFFF44336),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.end,
                                            children: [
                                              Text(
                                                'Rp ${debt['amount'].toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}',
                                                style: GoogleFonts.poppins(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black87,
                                                ),
                                              ),
                                              Text(
                                                '+ Bunga ${debt['interest']}%',
                                                style: GoogleFonts.poppins(
                                                  fontSize: 10,
                                                  color: const Color(0xFF9E9E9E),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      LinearProgressIndicator(
                                        value: 0.3, // Placeholder, bisa dihitung berdasarkan pembayaran
                                        backgroundColor: const Color(0xFFEEEEEE),
                                        valueColor: const AlwaysStoppedAnimation<Color>(
                                          Color(0xFFFFB946),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                              const SizedBox(height: 12),
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFFF9C4),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: const Color(0xFFFFF59D)),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.school,
                                      color: Color(0xFFFFD600),
                                      size: 20,
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Tips Bebas Hutang',
                                            style: GoogleFonts.poppins(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              color: const Color(0xFFFF8F00),
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            'Lunasi hutang dengan bunga tertinggi lebih dulu untuk menghemat pengeluaran jangka panjang.',
                                            style: GoogleFonts.poppins(
                                              fontSize: 10,
                                              color: const Color(0xFFFFC107),
                                              height: 1.3,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Riwayat Transaksi Section
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Riwayat Transaksi',
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 16),
                            // Search bar
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.search,
                                    color: const Color(0xFFBDBDBD),
                                    size: 20,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: TextField(
                                      decoration: InputDecoration(
                                        hintText: 'Cari transaksi...',
                                        hintStyle: GoogleFonts.poppins(
                                          fontSize: 14,
                                          color: const Color(0xFFBDBDBD),
                                        ),
                                        border: InputBorder.none,
                                        contentPadding: EdgeInsets.zero,
                                      ),
                                      style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        color: const Color(0xFF424242),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 12),
                            // Filter buttons
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  _buildFilterButton('Semua', true),
                                  const SizedBox(width: 8),
                                  _buildFilterButton('Pengeluaran', false),
                                  const SizedBox(width: 8),
                                  _buildFilterButton('Pemasukan', false),
                                  const SizedBox(width: 8),
                                  _buildFilterButton('Tanggal', false, hasIcon: true),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                            // Transaction list
                            _buildTransactionItem(
                              'Makan Malam',
                              'Hari ini, 19:30',
                              'Dompet Belanja',
                              -45000,
                              Icons.restaurant,
                              Colors.red,
                            ),
                            const SizedBox(height: 12),
                            _buildTransactionItem(
                              'Supermarket',
                              'Kemarin, 14:20',
                              'Dompet Belanja',
                              -350000,
                              Icons.shopping_cart,
                              Colors.blue,
                            ),
                            const SizedBox(height: 12),
                            _buildTransactionItem(
                              'Transfer Masuk',
                              '20 Okt 2023',
                              'Tabungan',
                              2000000,
                              Icons.payments,
                              Colors.green,
                              isIncome: true,
                            ),
                            const SizedBox(height: 12),
                            _buildTransactionItem(
                              'Netflix Premium',
                              '18 Okt 2023',
                              'Dompet Belanja',
                              -186000,
                              Icons.movie,
                              const Color(0xFFA788FD),
                            ),
                          ],
                        ),
                        const SizedBox(height: 100), // Space for bottom nav
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpenseBar(String label, double height, bool isHighlighted) {
    return Expanded(
      child: Column(
        children: [
          Container(
            height: 80,
            width: double.infinity,
            alignment: Alignment.bottomCenter,
            child: Container(
              width: 20,
              height: 80 * height,
              decoration: BoxDecoration(
                color: isHighlighted
                    ? Colors.white.withOpacity(0.9)
                    : Colors.white.withOpacity(0.4),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(4),
                  topRight: Radius.circular(4),
                ),
                boxShadow: isHighlighted
                    ? [
                        BoxShadow(
                          color: Colors.white.withOpacity(0.3),
                          blurRadius: 10,
                        ),
                      ]
                    : null,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 10,
              color: isHighlighted ? Colors.white : const Color(0xFFBBDEFB),
              fontWeight: isHighlighted ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterButton(String text, bool isActive, {bool hasIcon = false}) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: isActive ? const Color(0xFF304AFF) : Colors.white,
        foregroundColor: isActive ? Colors.white : const Color(0xFF6B7280),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: isActive ? 4 : 0,
        shadowColor: isActive ? Colors.blue.withOpacity(0.3) : Colors.transparent,
        side: isActive ? null : const BorderSide(color: Color(0xFFE5E7EB)),
      ),
      child: Row(
        children: [
          Text(
            text,
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          if (hasIcon) ...[
            const SizedBox(width: 4),
            const Icon(
              Icons.keyboard_arrow_down,
              size: 12,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTransactionItem(
    String title,
    String time,
    String wallet,
    int amount,
    IconData icon,
    Color iconColor, {
    bool isIncome = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.transparent),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Text(
                      time,
                      style: GoogleFonts.poppins(
                        fontSize: 10,
                        color: const Color(0xFFBDBDBD),
                      ),
                    ),
                    Text(
                      ' • ',
                      style: GoogleFonts.poppins(
                        fontSize: 10,
                        color: const Color(0xFFBDBDBD),
                      ),
                    ),
                    Text(
                      wallet,
                      style: GoogleFonts.poppins(
                        fontSize: 10,
                        color: const Color(0xFFBDBDBD),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Text(
            '${isIncome ? '+' : '-'}Rp ${amount.abs().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}',
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: isIncome ? const Color(0xFF00BFA6) : const Color(0xFFFF5252),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddSavingsDialog() {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController amountController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Tambah Target Tabungan',
            style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Nama Tabungan',
                  hintText: 'Contoh: MacBook Pro M3',
                  border: OutlineInputBorder(),
                ),
                style: GoogleFonts.poppins(),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: amountController,
                decoration: InputDecoration(
                  labelText: 'Jumlah Target (Rp)',
                  hintText: 'Contoh: 24000000',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                style: GoogleFonts.poppins(),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Batal', style: GoogleFonts.poppins()),
            ),
            ElevatedButton(
              onPressed: () {
                final String name = nameController.text.trim();
                final String amountText = amountController.text.trim();
                if (name.isNotEmpty && amountText.isNotEmpty) {
                  final int amount = int.tryParse(amountText) ?? 0;
                  if (amount > 0) {
                    setState(() {
                      savingsGoals.add({
                        'name': name,
                        'progress': 0.0,
                        'current': 0,
                        'target': amount,
                      });
                    });
                    Navigator.of(context).pop();
                  }
                }
              },
              child: Text('Tambah', style: GoogleFonts.poppins()),
            ),
          ],
        );
      },
    );
  }

  void _showAddDebtDialog() {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController amountController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Tambah Hutang',
            style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Nama Hutang',
                  hintText: 'Contoh: PayLater Belanja',
                  border: OutlineInputBorder(),
                ),
                style: GoogleFonts.poppins(),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: amountController,
                decoration: InputDecoration(
                  labelText: 'Jumlah Hutang (Rp)',
                  hintText: 'Contoh: 750000',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                style: GoogleFonts.poppins(),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Batal', style: GoogleFonts.poppins()),
            ),
            ElevatedButton(
              onPressed: () {
                final String name = nameController.text.trim();
                final String amountText = amountController.text.trim();
                if (name.isNotEmpty && amountText.isNotEmpty) {
                  final int amount = int.tryParse(amountText) ?? 0;
                  if (amount > 0) {
                    setState(() {
                      debts.add({
                        'name': name,
                        'amount': amount,
                        'dueDate': 'Belum ditentukan',
                        'interest': 0.0,
                      });
                    });
                    Navigator.of(context).pop();
                  }
                }
              },
              child: Text('Tambah', style: GoogleFonts.poppins()),
            ),
          ],
        );
      },
    );
  }
}