import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Savings goals section - manages savings targets
/// Uses internal state for now, can be connected to BLoC later
class SavingsGoalsSection extends StatefulWidget {
  const SavingsGoalsSection({super.key});

  @override
  State<SavingsGoalsSection> createState() => _SavingsGoalsSectionState();
}

class _SavingsGoalsSectionState extends State<SavingsGoalsSection> {
  List<Map<String, dynamic>> savingsGoals = [
    {
      'name': 'MacBook Pro M3',
      'progress': 0.75,
      'current': 18000000,
      'target': 24000000,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(20),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
        border: Border.all(color: const Color(0xFFF5F5F5)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFC8E6C9),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.savings, color: Colors.green, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Target Tabungan',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
              TextButton(
                onPressed: _showAddSavingsDialog,
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  '+ Baru',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF304AFF),
                  ),
                ),
              ),
              TextButton(
                onPressed: _showDepositDialog,
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  'Setor',
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
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
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
                      'Terkumpul: Rp ${_formatNumber(goal['current'])}',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF9E9E9E),
                      ),
                    ),
                    Text(
                      'Target: Rp ${_formatNumber(goal['target'])}',
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
          }),
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
                decoration: const InputDecoration(
                  labelText: 'Nama Tabungan',
                  hintText: 'Contoh: MacBook Pro M3',
                  border: OutlineInputBorder(),
                ),
                style: GoogleFonts.poppins(),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: amountController,
                decoration: const InputDecoration(
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

  void _showDepositDialog() {
    String? selectedGoal = savingsGoals.isNotEmpty
        ? savingsGoals.first['name']
        : null;
    final TextEditingController amountController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Setor Tabungan',
            style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                value: selectedGoal,
                decoration: const InputDecoration(
                  labelText: 'Pilih Target Tabungan',
                  border: OutlineInputBorder(),
                ),
                items: savingsGoals.map((goal) {
                  return DropdownMenuItem<String>(
                    value: goal['name'],
                    child: Text(goal['name'], style: GoogleFonts.poppins()),
                  );
                }).toList(),
                onChanged: (value) {
                  selectedGoal = value;
                },
                style: GoogleFonts.poppins(color: Colors.black87),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: amountController,
                decoration: const InputDecoration(
                  labelText: 'Nominal Setor (Rp)',
                  hintText: 'Contoh: 500000',
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
                final String amountText = amountController.text.trim();
                if (selectedGoal != null && amountText.isNotEmpty) {
                  final int amount = int.tryParse(amountText) ?? 0;
                  if (amount > 0) {
                    setState(() {
                      final goal = savingsGoals.firstWhere(
                        (g) => g['name'] == selectedGoal,
                      );
                      goal['current'] += amount;
                      goal['progress'] = goal['current'] / goal['target'];
                      if (goal['progress'] > 1.0) goal['progress'] = 1.0;
                    });
                    Navigator.of(context).pop();
                  }
                }
              },
              child: Text('Setor', style: GoogleFonts.poppins()),
            ),
          ],
        );
      },
    );
  }
}
