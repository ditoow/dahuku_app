import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../dashboard/data/models/transaction_model.dart';
import '../../bloc/analytics_state.dart';

/// Transaction history section with search and filters
class TransactionHistorySection extends StatelessWidget {
  final List<TransactionModel> transactions;
  final TransactionFilter currentFilter;
  final String searchQuery;
  final ValueChanged<TransactionFilter> onFilterChanged;
  final ValueChanged<String> onSearchChanged;

  const TransactionHistorySection({
    super.key,
    required this.transactions,
    required this.currentFilter,
    required this.searchQuery,
    required this.onFilterChanged,
    required this.onSearchChanged,
  });

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
        // Search bar
        TextField(
          onChanged: onSearchChanged,
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
              _buildFilterButton(
                'Semua',
                currentFilter == TransactionFilter.all,
                () => onFilterChanged(TransactionFilter.all),
              ),
              const SizedBox(width: 8),
              _buildFilterButton(
                'Pengeluaran',
                currentFilter == TransactionFilter.expense,
                () => onFilterChanged(TransactionFilter.expense),
              ),
              const SizedBox(width: 8),
              _buildFilterButton(
                'Pemasukan',
                currentFilter == TransactionFilter.income,
                () => onFilterChanged(TransactionFilter.income),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // Transaction list
        if (transactions.isEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                children: [
                  Icon(
                    Icons.receipt_long_outlined,
                    size: 48,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    searchQuery.isNotEmpty
                        ? 'Tidak ada transaksi ditemukan'
                        : 'Belum ada transaksi bulan ini',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          ...transactions.map(
            (t) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _buildTransactionItem(t),
            ),
          ),
      ],
    );
  }

  Widget _buildFilterButton(String text, bool isActive, VoidCallback onTap) {
    return ElevatedButton(
      onPressed: onTap,
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
      child: Text(
        text,
        style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget _buildTransactionItem(TransactionModel transaction) {
    final isIncome = transaction.type == TransactionType.income;
    final icon = _getTransactionIcon(transaction.title);
    final color = isIncome ? Colors.green : Colors.red;

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
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withAlpha(26),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.title,
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
                      _formatDate(transaction.transactionDate),
                      style: GoogleFonts.poppins(
                        fontSize: 10,
                        color: const Color(0xFFBDBDBD),
                      ),
                    ),
                    if (transaction.description != null) ...[
                      Text(
                        ' • ',
                        style: GoogleFonts.poppins(
                          fontSize: 10,
                          color: const Color(0xFFBDBDBD),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          transaction.description!,
                          style: GoogleFonts.poppins(
                            fontSize: 10,
                            color: const Color(0xFFBDBDBD),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          Text(
            '${isIncome ? '+' : '-'}Rp ${_formatNumber(transaction.amount.toInt().abs())}',
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

  IconData _getTransactionIcon(String title) {
    final lowerTitle = title.toLowerCase();
    if (lowerTitle.contains('makan') || lowerTitle.contains('resto')) {
      return Icons.restaurant;
    } else if (lowerTitle.contains('belanja') || lowerTitle.contains('shop')) {
      return Icons.shopping_cart;
    } else if (lowerTitle.contains('transport') ||
        lowerTitle.contains('bensin')) {
      return Icons.directions_car;
    } else if (lowerTitle.contains('gaji') || lowerTitle.contains('salary')) {
      return Icons.payments;
    } else if (lowerTitle.contains('transfer')) {
      return Icons.swap_horiz;
    } else {
      return Icons.receipt;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inDays == 0) {
      return 'Hari ini, ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } else if (diff.inDays == 1) {
      return 'Kemarin, ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } else {
      return '${date.day} ${_getMonthName(date.month)} ${date.year}';
    }
  }

  String _getMonthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'Mei',
      'Jun',
      'Jul',
      'Agu',
      'Sep',
      'Okt',
      'Nov',
      'Des',
    ];
    return months[month - 1];
  }

  String _formatNumber(int number) {
    return number.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    );
  }
}
