import '../models/savings_debt_model.dart';
import '../services/savings_debt_service.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../../core/services/offline_mode_service.dart';

/// Repository untuk Target Tabungan dan Hutang
class SavingsDebtRepository {
  final SavingsDebtService
  service; // Changed from _service to service to match DI
  final Box<SavingsGoalModel> savingsBox;
  final Box<DebtModel> debtBox;
  final OfflineModeService offlineModeService;

  SavingsDebtRepository({
    required this.service,
    required this.savingsBox,
    required this.debtBox,
    required this.offlineModeService,
  });

  // Target Tabungan
  Future<List<SavingsGoalModel>> getSavingsGoals() async {
    if (offlineModeService.isOfflineMode) {
      return savingsBox.values.toList();
    }

    try {
      final goals = await service.getSavingsGoals();
      // Cache goals
      await savingsBox.clear(); // Clear old cache or update strategy
      for (var goal in goals) {
        await savingsBox.put(goal.id, goal);
      }
      return goals;
    } catch (e) {
      return savingsBox.values.toList();
    }
  }

  Future<List<SavingsGoalModel>> getActiveSavingsGoals() async {
    if (offlineModeService.isOfflineMode) {
      return savingsBox.values.where((g) => !g.selesai).toList();
    }

    try {
      final goals = await service.getActiveSavingsGoals();
      // We don't necessarily cache here if getSavingsGoals covers it, but to be safe:
      // Ideally getSavingsGoals caches everything.
      // Let's rely on getSavingsGoals for caching mostly.
      return goals;
    } catch (e) {
      return savingsBox.values.where((g) => !g.selesai).toList();
    }
  }

  Future<SavingsGoalModel> createSavingsGoal({
    required String nama,
    String? deskripsi,
    required double jumlahTarget,
    String icon = 'savings',
    String warna = '#10B981',
    DateTime? tanggalTarget,
  }) => service.createSavingsGoal(
    nama: nama,
    deskripsi: deskripsi,
    jumlahTarget: jumlahTarget,
    icon: icon,
    warna: warna,
    tanggalTarget: tanggalTarget,
  );

  Future<SavingsGoalModel> depositToGoal({
    required String targetId,
    required double jumlah,
    String? catatan,
  }) => service.depositToGoal(
    targetId: targetId,
    jumlah: jumlah,
    catatan: catatan,
  );

  Future<void> deleteSavingsGoal(String id) => service.deleteSavingsGoal(id);

  // Hutang
  Future<List<DebtModel>> getDebts() async {
    if (offlineModeService.isOfflineMode) {
      return debtBox.values.toList();
    }

    try {
      final debts = await service.getDebts();
      await debtBox.clear();
      for (var debt in debts) {
        await debtBox.put(debt.id, debt);
      }
      return debts;
    } catch (e) {
      return debtBox.values.toList();
    }
  }

  Future<List<DebtModel>> getActiveDebts() async {
    if (offlineModeService.isOfflineMode) {
      return debtBox.values.where((d) => !d.lunas).toList();
    }

    try {
      return await service.getActiveDebts();
    } catch (e) {
      return debtBox.values.where((d) => !d.lunas).toList();
    }
  }

  Future<DebtModel> createDebt({
    required String nama,
    required String jenis,
    required double jumlah,
    double bungaPersen = 0,
    DateTime? tanggalJatuhTempo,
  }) => service.createDebt(
    nama: nama,
    jenis: jenis,
    jumlah: jumlah,
    bungaPersen: bungaPersen,
    tanggalJatuhTempo: tanggalJatuhTempo,
  );

  Future<DebtModel> payDebt({
    required String hutangId,
    required double jumlah,
    String? catatan,
  }) => service.payDebt(hutangId: hutangId, jumlah: jumlah, catatan: catatan);

  Future<void> deleteDebt(String id) => service.deleteDebt(id);
}
