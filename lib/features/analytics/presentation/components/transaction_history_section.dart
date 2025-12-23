import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Transaction history section with search and filters
/// TODO: Connect to transactions BLoC for real data
class TransactionHistorySection extends StatelessWidget {
  const TransactionHistorySection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
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
        // Search bar - simple input
        TextField(
          decoration: InputDecoration(
            hintText: 'Cari transaksi...',
            hintStyle: GoogleFonts.poppins(
              fontSize: 14,
              color: const Color(0xFF9E9E9E),
            ),
            prefixIcon: const Icon(
              Icons.search_rounded,
              color: Color(0xFF9E9E9E),
              size: 20,
            ),
            filled: true,
            fillColor: const Color(0xFFF5F5F7),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: const Color(0xFF424242),
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
    );
  }

  Widget _buildFilterButton(
    String text,
    bool isActive, {
    bool hasIcon = false,
  }) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: isActive ? const Color(0xFF304AFF) : Colors.white,
        foregroundColor: isActive ? Colors.white : const Color(0xFF6B7280),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: isActive ? 4 : 0,
        shadowColor: isActive ? Colors.blue.withAlpha(77) : Colors.transparent,
        side: isActive
            ? BorderSide.none
            : const BorderSide(color: Color(0xFFE5E7EB)),
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
            const Icon(Icons.keyboard_arrow_down, size: 12),
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
            color: Colors.black.withAlpha(13),
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
              color: iconColor.withAlpha(26),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(icon, color: iconColor, size: 20),
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
            '${isIncome ? '+' : '-'}Rp ${_formatNumber(amount.abs())}',
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: isIncome
                  ? const Color(0xFF00BFA6)
                  : const Color(0xFFFF5252),
            ),
          ),
        ],
      ),
    );
  }

  String _formatNumber(int number) {
    return number.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    );
  }
}
