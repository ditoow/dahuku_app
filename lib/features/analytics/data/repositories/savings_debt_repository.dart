import '../models/savings_debt_model.dart';
import '../services/savings_debt_service.dart';

/// Repository untuk Target Tabungan dan Hutang
class SavingsDebtRepository {
  final SavingsDebtService _service;

  SavingsDebtRepository(this._service);

  // Target Tabungan
  Future<List<SavingsGoalModel>> getSavingsGoals() =>
      _service.getSavingsGoals();
  Future<List<SavingsGoalModel>> getActiveSavingsGoals() =>
      _service.getActiveSavingsGoals();

  Future<SavingsGoalModel> createSavingsGoal({
    required String nama,
    String? deskripsi,
    required double jumlahTarget,
    String icon = 'savings',
    String warna = '#10B981',
    DateTime? tanggalTarget,
  }) => _service.createSavingsGoal(
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
  }) => _service.depositToGoal(
    targetId: targetId,
    jumlah: jumlah,
    catatan: catatan,
  );

  Future<void> deleteSavingsGoal(String id) => _service.deleteSavingsGoal(id);

  // Hutang
  Future<List<DebtModel>> getDebts() => _service.getDebts();
  Future<List<DebtModel>> getActiveDebts() => _service.getActiveDebts();

  Future<DebtModel> createDebt({
    required String nama,
    required String jenis,
    required double jumlah,
    double bungaPersen = 0,
    DateTime? tanggalJatuhTempo,
  }) => _service.createDebt(
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
  }) => _service.payDebt(hutangId: hutangId, jumlah: jumlah, catatan: catatan);

  Future<void> deleteDebt(String id) => _service.deleteDebt(id);
}
