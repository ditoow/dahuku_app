import 'package:equatable/equatable.dart';

/// Events untuk SavingsDebtBloc
abstract class SavingsDebtEvent extends Equatable {
  const SavingsDebtEvent();

  @override
  List<Object?> get props => [];
}

/// Load all data (savings goals dan hutang)
class LoadSavingsDebt extends SavingsDebtEvent {
  const LoadSavingsDebt();
}

/// Refresh data
class RefreshSavingsDebt extends SavingsDebtEvent {
  const RefreshSavingsDebt();
}

/// Create new savings goal
class CreateSavingsGoal extends SavingsDebtEvent {
  final String nama;
  final String? deskripsi;
  final double jumlahTarget;
  final String icon;
  final String warna;
  final DateTime? tanggalTarget;

  const CreateSavingsGoal({
    required this.nama,
    this.deskripsi,
    required this.jumlahTarget,
    this.icon = 'savings',
    this.warna = '#10B981',
    this.tanggalTarget,
  });

  @override
  List<Object?> get props => [nama, jumlahTarget];
}

/// Deposit to savings goal (setor)
class DepositToGoal extends SavingsDebtEvent {
  final String targetId;
  final double jumlah;
  final String? catatan;

  const DepositToGoal({
    required this.targetId,
    required this.jumlah,
    this.catatan,
  });

  @override
  List<Object?> get props => [targetId, jumlah];
}

/// Delete savings goal
class DeleteSavingsGoal extends SavingsDebtEvent {
  final String id;

  const DeleteSavingsGoal(this.id);

  @override
  List<Object?> get props => [id];
}

/// Create new debt
class CreateDebt extends SavingsDebtEvent {
  final String nama;
  final String jenis;
  final double jumlah;
  final double bungaPersen;
  final DateTime? tanggalJatuhTempo;

  const CreateDebt({
    required this.nama,
    required this.jenis,
    required this.jumlah,
    this.bungaPersen = 0,
    this.tanggalJatuhTempo,
  });

  @override
  List<Object?> get props => [nama, jenis, jumlah];
}

/// Pay debt (bayar hutang)
class PayDebt extends SavingsDebtEvent {
  final String hutangId;
  final double jumlah;
  final String? catatan;

  const PayDebt({required this.hutangId, required this.jumlah, this.catatan});

  @override
  List<Object?> get props => [hutangId, jumlah];
}

/// Delete debt
class DeleteDebt extends SavingsDebtEvent {
  final String id;

  const DeleteDebt(this.id);

  @override
  List<Object?> get props => [id];
}
