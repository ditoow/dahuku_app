import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../bloc/dashboard_bloc.dart';
import '../../bloc/dashboard_state.dart';

/// Ringkasan Cepat section matching HTML mockup (smart component)
class QuickSummarySection extends StatelessWidget {
  const QuickSummarySection({super.key});

  String _formatCurrency(double amount) {
    if (amount >= 1000000) {
      return 'Rp ${(amount / 1000000).toStringAsFixed(1)}jt';
    }
    final formatted = amount
        .toStringAsFixed(0)
        .replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]}.',
        );
    return 'Rp $formatted';
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardBloc, DashboardState>(
      builder: (context, state) {
        final weeklyExpense = state.summary.weeklyExpense;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Pengeluaran',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textMain,
                ),
              ),
              const SizedBox(height: 16),

              // Pengeluaran card (white)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade100),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(10),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.red.shade50,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Icon(
                            Icons.arrow_downward,
                            size: 16,
                            color: Colors.red.shade500,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'PENGELUARAN MINGGU INI',
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                            color: Colors.grey.shade400,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _formatCurrency(weeklyExpense),
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textMain,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Quick action buttons
              // Row(
              //   children: [
              //     Expanded(
              //       child: _QuickActionButton(
              //         icon: Icons.school_outlined,
              //         label: 'Belajar',
              //         isPrimary: true,
              //         onTap: () {
              //           // Navigate to education/belajar
              //           Navigator.pushNamed(context, '/education');
              //         },
              //       ),
              //     ),
              //     const SizedBox(width: 16),
              //     Expanded(
              //       child: _QuickActionButton(
              //         icon: Icons.history,
              //         label: 'Riwayat',
              //         isPrimary: false,
              //         onTap: () {
              //           // Navigate to history (todo)
              //         },
              //       ),
              //     ),
              //   ],
              // ),
            ],
          ),
        );
      },
    );
  }
}

/// Quick action button widget
// class _QuickActionButton extends StatelessWidget {
//   final IconData icon;
//   final String label;
//   final bool isPrimary;
//   final VoidCallback? onTap;

//   const _QuickActionButton({
//     required this.icon,
//     required this.label,
//     this.isPrimary = false,
//     this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
//         decoration: BoxDecoration(
//           color: isPrimary ? Colors.blue.shade50 : Colors.grey.shade50,
//           borderRadius: BorderRadius.circular(12),
//           border: Border.all(
//             color: isPrimary ? Colors.blue.shade100 : Colors.grey.shade200,
//           ),
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(
//               icon,
//               size: 20,
//               color: isPrimary ? AppColors.primary : Colors.grey.shade600,
//             ),
//             const SizedBox(width: 8),
//             Text(
//               label,
//               style: TextStyle(
//                 fontSize: 14,
//                 fontWeight: FontWeight.w600,
//                 color: isPrimary ? AppColors.primary : Colors.grey.shade600,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
