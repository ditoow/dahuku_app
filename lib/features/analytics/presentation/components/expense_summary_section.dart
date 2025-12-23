import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../bloc/analytics_state.dart';

/// Expense summary card with bar chart and insights
class ExpenseSummarySection extends StatelessWidget {
  final double totalExpense;
  final double remainingBudget;
  final List<CategoryExpense> expensesByCategory;
  final String? insight;

  const ExpenseSummarySection({
    super.key,
    required this.totalExpense,
    required this.remainingBudget,
    required this.expensesByCategory,
    this.insight,
  });

  String _formatCurrency(double amount) {
    final absAmount = amount.abs();
    if (absAmount >= 1000000) {
      return '${(absAmount / 1000000).toStringAsFixed(1)}jt';
    }
    return absAmount
        .toStringAsFixed(0)
        .replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (m) => '${m[1]}.',
        );
  }

  String _formatFullCurrency(double amount) {
    return amount
        .toStringAsFixed(0)
        .replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (m) => '${m[1]}.',
        );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
            color: const Color(0xFF304AFF).withAlpha(77),
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
                    'Rp ${_formatFullCurrency(totalExpense)}',
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
                    '+Rp ${_formatCurrency(remainingBudget)}',
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
          if (expensesByCategory.isNotEmpty)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: expensesByCategory.map((category) {
                final isMax = category.percentage >= 0.95;
                return _buildExpenseBar(
                  category.category,
                  category.percentage,
                  isMax,
                );
              }).toList(),
            )
          else
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 30),
              child: Text(
                'Belum ada data pengeluaran',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: const Color(0xFFBBDEFB),
                ),
              ),
            ),
          if (insight != null) ...[
            const SizedBox(height: 16),
            // Insight box
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.black.withAlpha(26),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white.withAlpha(26)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.lightbulb, color: Colors.yellow, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      insight!,
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
              height: 80 * height.clamp(0.1, 1.0),
              decoration: BoxDecoration(
                color: isHighlighted
                    ? Colors.white.withAlpha(230)
                    : Colors.white.withAlpha(102),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(4),
                  topRight: Radius.circular(4),
                ),
                boxShadow: isHighlighted
                    ? [
                        BoxShadow(
                          color: Colors.white.withAlpha(77),
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
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
