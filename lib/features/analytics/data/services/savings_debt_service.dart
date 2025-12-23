import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/savings_debt_model.dart';

/// Service untuk operasi Target Tabungan dan Hutang dengan Supabase
class SavingsDebtService {
  final SupabaseClient _supabase = Supabase.instance.client;

  String? get _userId => _supabase.auth.currentUser?.id;

  // ==================
  // TARGET TABUNGAN
  // ==================

  /// Get semua target tabungan user
  Future<List<SavingsGoalModel>> getSavingsGoals() async {
    if (_userId == null) return [];

    final response = await _supabase
        .from('target_tabungan')
        .select()
        .eq('user_id', _userId!)
        .order('dibuat_pada', ascending: false);

    return (response as List)
        .map((json) => SavingsGoalModel.fromJson(json))
        .toList();
  }

  /// Get active (not completed) savings goals
  Future<List<SavingsGoalModel>> getActiveSavingsGoals() async {
    if (_userId == null) return [];

    final response = await _supabase
        .from('target_tabungan')
        .select()
        .eq('user_id', _userId!)
        .eq('selesai', false)
        .order('dibuat_pada', ascending: false);

    return (response as List)
        .map((json) => SavingsGoalModel.fromJson(json))
        .toList();
  }

  /// Create new savings goal
  Future<SavingsGoalModel> createSavingsGoal({
    required String nama,
    String? deskripsi,
    required double jumlahTarget,
    String icon = 'savings',
    String warna = '#10B981',
    DateTime? tanggalTarget,
  }) async {
    if (_userId == null) throw Exception('User tidak login');

    final data = {
      'user_id': _userId,
      'nama': nama,
      'deskripsi': deskripsi,
      'jumlah_target': jumlahTarget,
      'terkumpul': 0,
      'icon': icon,
      'warna': warna,
      'tanggal_target': tanggalTarget?.toIso8601String(),
    };

    final response = await _supabase
        .from('target_tabungan')
        .insert(data)
        .select()
        .single();

    return SavingsGoalModel.fromJson(response);
  }

  /// Deposit to savings goal (setor)
  /// Also deducts from dompet tabungan
  Future<SavingsGoalModel> depositToGoal({
    required String targetId,
    required double jumlah,
    String? catatan,
  }) async {
    if (_userId == null) throw Exception('User tidak login');

    // 1. Get dompet tabungan and deduct balance
    final walletResponse = await _supabase
        .from('dompet')
        .select()
        .eq('id_pengguna', _userId!)
        .eq('tipe', 'tabungan')
        .single();

    final currentWalletBalance = (walletResponse['saldo'] as num).toDouble();
    if (currentWalletBalance < jumlah) {
      throw Exception('Saldo dompet tabungan tidak cukup');
    }

    // 2. Deduct from wallet
    await _supabase
        .from('dompet')
        .update({
          'saldo': currentWalletBalance - jumlah,
          'diperbarui_pada': DateTime.now().toIso8601String(),
        })
        .eq('id', walletResponse['id']);

    // 3. Insert deposit record
    await _supabase.from('setor_tabungan').insert({
      'user_id': _userId,
      'target_id': targetId,
      'jumlah': jumlah,
      'catatan': catatan,
    });

    print('DEBUG: Step 3 Success');

    // 4. Update target terkumpul
    final targetResponse = await _supabase
        .from('target_tabungan')
        .select()
        .eq('id', targetId)
        .single();

    final currentAmount = (targetResponse['terkumpul'] as num).toDouble();
    final targetAmount = (targetResponse['jumlah_target'] as num).toDouble();
    final newAmount = currentAmount + jumlah;
    final isComplete = newAmount >= targetAmount;

    final updatedResponse = await _supabase
        .from('target_tabungan')
        .update({
          'terkumpul': newAmount,
          'selesai': isComplete,
          'diperbarui_pada': DateTime.now().toIso8601String(),
        })
        .eq('id', targetId)
        .select()
        .single();

    return SavingsGoalModel.fromJson(updatedResponse);
  }

  /// Delete savings goal
  Future<void> deleteSavingsGoal(String id) async {
    await _supabase.from('target_tabungan').delete().eq('id', id);
  }

  // ==================
  // HUTANG
  // ==================

  /// Get semua hutang user
  Future<List<DebtModel>> getDebts() async {
    if (_userId == null) return [];

    final response = await _supabase
        .from('hutang')
        .select()
        .eq('user_id', _userId!)
        .order('dibuat_pada', ascending: false);

    return (response as List).map((json) => DebtModel.fromJson(json)).toList();
  }

  /// Get active (not paid) debts
  Future<List<DebtModel>> getActiveDebts() async {
    if (_userId == null) return [];

    final response = await _supabase
        .from('hutang')
        .select()
        .eq('user_id', _userId!)
        .eq('lunas', false)
        .order('tanggal_jatuh_tempo', ascending: true);

    return (response as List).map((json) => DebtModel.fromJson(json)).toList();
  }

  /// Create new debt
  Future<DebtModel> createDebt({
    required String nama,
    required String jenis,
    required double jumlah,
    double bungaPersen = 0,
    DateTime? tanggalJatuhTempo,
  }) async {
    if (_userId == null) throw Exception('User tidak login');

    final data = {
      'user_id': _userId,
      'nama': nama,
      'jenis': jenis,
      'jumlah_awal': jumlah,
      'sisa_hutang': jumlah,
      'bunga_persen': bungaPersen,
      'tanggal_jatuh_tempo': tanggalJatuhTempo?.toIso8601String(),
    };

    final response = await _supabase
        .from('hutang')
        .insert(data)
        .select()
        .single();

    return DebtModel.fromJson(response);
  }

  /// Pay debt (bayar hutang)
  Future<DebtModel> payDebt({
    required String hutangId,
    required double jumlah,
    String? catatan,
  }) async {
    if (_userId == null) throw Exception('User tidak login');

    // 1. Insert payment record
    await _supabase.from('bayar_hutang').insert({
      'user_id': _userId,
      'hutang_id': hutangId,
      'jumlah': jumlah,
      'catatan': catatan,
    });

    // 2. Update sisa hutang
    final hutangResponse = await _supabase
        .from('hutang')
        .select()
        .eq('id', hutangId)
        .single();

    final currentRemaining = (hutangResponse['sisa_hutang'] as num).toDouble();
    final newRemaining = (currentRemaining - jumlah).clamp(0, double.infinity);
    final isLunas = newRemaining <= 0;

    final updatedResponse = await _supabase
        .from('hutang')
        .update({
          'sisa_hutang': newRemaining,
          'lunas': isLunas,
          'diperbarui_pada': DateTime.now().toIso8601String(),
        })
        .eq('id', hutangId)
        .select()
        .single();

    return DebtModel.fromJson(updatedResponse);
  }

  /// Delete debt
  Future<void> deleteDebt(String id) async {
    await _supabase.from('hutang').delete().eq('id', id);
  }
}
