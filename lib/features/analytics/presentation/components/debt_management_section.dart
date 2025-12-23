import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

/// Debt management section - manages debts
/// Uses internal state for now, can be connected to BLoC later
class DebtManagementSection extends StatefulWidget {
  const DebtManagementSection({super.key});

  @override
  State<DebtManagementSection> createState() => _DebtManagementSectionState();
}

class _DebtManagementSectionState extends State<DebtManagementSection> {
  List<Map<String, dynamic>> debts = [
    {
      'name': 'PayLater Belanja',
      'amount': 750000,
      'originalAmount': 750000,
      'dueDate': '25 Nov',
      'interest': 2.5,
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
        border: Border.all(color: const Color(0xFFFFB946).withAlpha(77)),
      ),
      child: Column(
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
              Expanded(
                child: Text(
                  'Manajemen Hutang',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
              TextButton(
                onPressed: _showAddDebtDialog,
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  '+ Hutang',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF304AFF),
                  ),
                ),
              ),
              TextButton(
                onPressed: _showPayDebtDialog,
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  'Bayar',
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
                            'Rp ${_formatNumber(debt['amount'])}',
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
                    value: debt['originalAmount'] > 0
                        ? (debt['originalAmount'] - debt['amount']) /
                              debt['originalAmount']
                        : 0.0,
                    backgroundColor: const Color(0xFFEEEEEE),
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Color(0xFFFFB946),
                    ),
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: 12),
          // Tips box
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF9C4),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFFFF59D)),
            ),
            child: Row(
              children: [
                const Icon(Icons.school, color: Color(0xFFFFD600), size: 20),
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
    );
  }

  String _formatNumber(int number) {
    return number.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    );
  }

  void _showAddDebtDialog() {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController amountController = TextEditingController();
    final TextEditingController interestController = TextEditingController();
    final TextEditingController dueDateController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Tambah Hutang',
            style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Nama Hutang',
                    hintText: 'Contoh: PayLater Belanja',
                    border: OutlineInputBorder(),
                  ),
                  style: GoogleFonts.poppins(),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: amountController,
                  decoration: const InputDecoration(
                    labelText: 'Jumlah Hutang (Rp)',
                    hintText: 'Contoh: 750000',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  style: GoogleFonts.poppins(),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: interestController,
                  decoration: const InputDecoration(
                    labelText: 'Bunga Hutang (% per bulan)',
                    hintText: 'Contoh: 2.5',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  style: GoogleFonts.poppins(),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: dueDateController,
                  decoration: const InputDecoration(
                    labelText: 'Tanggal Jatuh Tempo',
                    hintText: 'Pilih tanggal',
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  readOnly: true,
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2100),
                    );
                    if (pickedDate != null) {
                      dueDateController.text = DateFormat(
                        'dd MMM',
                      ).format(pickedDate);
                    }
                  },
                  style: GoogleFonts.poppins(),
                ),
              ],
            ),
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
                final String interestText = interestController.text.trim();
                final String dueDateText = dueDateController.text.trim();
                if (name.isNotEmpty &&
                    amountText.isNotEmpty &&
                    interestText.isNotEmpty &&
                    dueDateText.isNotEmpty) {
                  final int amount = int.tryParse(amountText) ?? 0;
                  final double interest = double.tryParse(interestText) ?? 0.0;
                  if (amount > 0) {
                    setState(() {
                      debts.add({
                        'name': name,
                        'amount': amount,
                        'originalAmount': amount,
                        'dueDate': dueDateText,
                        'interest': interest,
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

  void _showPayDebtDialog() {
    String? selectedDebt = debts.isNotEmpty ? debts.first['name'] : null;
    final TextEditingController amountController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Bayar Hutang',
            style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                value: selectedDebt,
                decoration: const InputDecoration(
                  labelText: 'Pilih Hutang',
                  border: OutlineInputBorder(),
                ),
                items: debts.map((debt) {
                  return DropdownMenuItem<String>(
                    value: debt['name'],
                    child: Text(debt['name'], style: GoogleFonts.poppins()),
                  );
                }).toList(),
                onChanged: (value) {
                  selectedDebt = value;
                },
                style: GoogleFonts.poppins(color: Colors.black87),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: amountController,
                decoration: const InputDecoration(
                  labelText: 'Nominal Bayar (Rp)',
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
                if (selectedDebt != null && amountText.isNotEmpty) {
                  final int amount = int.tryParse(amountText) ?? 0;
                  if (amount > 0) {
                    setState(() {
                      final debt = debts.firstWhere(
                        (d) => d['name'] == selectedDebt,
                      );
                      debt['amount'] -= amount;
                      if (debt['amount'] < 0) debt['amount'] = 0;
                    });
                    Navigator.of(context).pop();
                  }
                }
              },
              child: Text('Bayar', style: GoogleFonts.poppins()),
            ),
          ],
        );
      },
    );
  }
}
