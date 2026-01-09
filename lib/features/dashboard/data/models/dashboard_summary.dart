import 'package:equatable/equatable.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'dashboard_summary.g.dart';

/// Model ringkasan dashboard dari fungsi Supabase
@HiveType(typeId: 5)
class DashboardSummary extends Equatable {
  @HiveField(0)
  final double totalBalance;
  @HiveField(1)
  final double weeklyExpense;
  @HiveField(2)
  final double monthlyBudget;
  @HiveField(3)
  final double monthlySpent;

  const DashboardSummary({
    required this.totalBalance,
    required this.weeklyExpense,
    required this.monthlyBudget,
    required this.monthlySpent,
  });

  /// Factory untuk data kosong
  factory DashboardSummary.empty() {
    return const DashboardSummary(
      totalBalance: 0,
      weeklyExpense: 0,
      monthlyBudget: 0,
      monthlySpent: 0,
    );
  }

  /// Buat dari JSON (response fungsi Supabase - Indonesia)
  factory DashboardSummary.fromJson(Map<String, dynamic> json) {
    return DashboardSummary(
      totalBalance: (json['total_saldo'] as num?)?.toDouble() ?? 0,
      weeklyExpense: (json['pengeluaran_mingguan'] as num?)?.toDouble() ?? 0,
      monthlyBudget: (json['anggaran_bulanan'] as num?)?.toDouble() ?? 0,
      monthlySpent: (json['terpakai_bulanan'] as num?)?.toDouble() ?? 0,
    );
  }

  /// Sisa anggaran
  double get remainingBudget => monthlyBudget - monthlySpent;

  /// Progress anggaran (0.0 - 1.0)
  double get budgetProgress {
    if (monthlyBudget <= 0) return 0;
    final progress = monthlySpent / monthlyBudget;
    return progress.clamp(0.0, 1.0);
  }

  /// Konversi ke JSON
  Map<String, dynamic> toJson() {
    return {
      'total_saldo': totalBalance,
      'pengeluaran_mingguan': weeklyExpense,
      'anggaran_bulanan': monthlyBudget,
      'terpakai_bulanan': monthlySpent,
    };
  }

  /// Copy dengan perubahan
  DashboardSummary copyWith({
    double? totalBalance,
    double? weeklyExpense,
    double? monthlyBudget,
    double? monthlySpent,
  }) {
    return DashboardSummary(
      totalBalance: totalBalance ?? this.totalBalance,
      weeklyExpense: weeklyExpense ?? this.weeklyExpense,
      monthlyBudget: monthlyBudget ?? this.monthlyBudget,
      monthlySpent: monthlySpent ?? this.monthlySpent,
    );
  }

  @override
  List<Object?> get props => [
    totalBalance,
    weeklyExpense,
    monthlyBudget,
    monthlySpent,
  ];
}
