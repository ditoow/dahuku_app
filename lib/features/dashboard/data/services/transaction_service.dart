import '../../../../core/data/services/supabase_service.dart';
import '../models/transaction_model.dart';
import '../models/dashboard_summary.dart';

/// Service untuk operasi Supabase transaksi
class TransactionService {
  static const String _tableName = 'transaksi';

  /// Get semua transaksi untuk user saat ini
  Future<List<TransactionModel>> getTransactions({
    int? limit,
    DateTime? startDate,
    DateTime? endDate,
    String? walletId,
    TransactionType? type,
  }) async {
    final userId = SupabaseService.currentUserId;
    if (userId == null) throw Exception('User belum login');

    var query = SupabaseService.client
        .from(_tableName)
        .select()
        .eq('id_pengguna', userId);

    if (walletId != null) {
      query = query.eq('id_dompet', walletId);
    }

    if (type != null) {
      final tipeValue = _mapTransactionType(type);
      query = query.eq('tipe', tipeValue);
    }

    if (startDate != null) {
      query = query.gte(
        'tanggal_transaksi',
        startDate.toIso8601String().split('T').first,
      );
    }

    if (endDate != null) {
      query = query.lte(
        'tanggal_transaksi',
        endDate.toIso8601String().split('T').first,
      );
    }

    final response = await query.order('tanggal_transaksi', ascending: false);

    if (limit != null) {
      return (response as List)
          .take(limit)
          .map((json) => TransactionModel.fromJson(json))
          .toList();
    }

    return (response as List)
        .map((json) => TransactionModel.fromJson(json))
        .toList();
  }

  /// Get transaksi terbaru
  Future<List<TransactionModel>> getRecentTransactions({int limit = 5}) async {
    return getTransactions(limit: limit);
  }

  /// Get transaksi berdasarkan ID
  Future<TransactionModel?> getTransactionById(String id) async {
    final userId = SupabaseService.currentUserId;
    if (userId == null) throw Exception('User belum login');

    final response = await SupabaseService.client
        .from(_tableName)
        .select()
        .eq('id', id)
        .eq('id_pengguna', userId)
        .maybeSingle();

    if (response == null) return null;
    return TransactionModel.fromJson(response);
  }

  /// Buat transaksi baru
  Future<TransactionModel> createTransaction(
    TransactionModel transaction,
  ) async {
    final response = await SupabaseService.client
        .from(_tableName)
        .insert(transaction.toJson())
        .select()
        .single();

    return TransactionModel.fromJson(response);
  }

  /// Update transaksi
  Future<TransactionModel> updateTransaction(
    TransactionModel transaction,
  ) async {
    final response = await SupabaseService.client
        .from(_tableName)
        .update(transaction.toJson())
        .eq('id', transaction.id)
        .select()
        .single();

    return TransactionModel.fromJson(response);
  }

  /// Hapus transaksi
  Future<void> deleteTransaction(String id) async {
    await SupabaseService.client.from(_tableName).delete().eq('id', id);
  }

  /// Get ringkasan dashboard menggunakan fungsi Supabase
  Future<DashboardSummary> getDashboardSummary() async {
    final userId = SupabaseService.currentUserId;
    if (userId == null) throw Exception('User belum login');

    final response = await SupabaseService.client.rpc(
      'dapatkan_ringkasan_dashboard',
      params: {'p_id_pengguna': userId},
    );

    if (response == null) return DashboardSummary.empty();
    return DashboardSummary.fromJson(response as Map<String, dynamic>);
  }

  /// Get total pengeluaran mingguan
  Future<double> getWeeklyExpense() async {
    final now = DateTime.now();
    final weekAgo = now.subtract(const Duration(days: 7));

    final transactions = await getTransactions(
      startDate: weekAgo,
      endDate: now,
      type: TransactionType.expense,
    );

    double total = 0.0;
    for (final t in transactions) {
      total += t.amount;
    }
    return total;
  }

  /// Map TransactionType ke nilai database Indonesia
  String _mapTransactionType(TransactionType type) {
    switch (type) {
      case TransactionType.income:
        return 'pemasukan';
      case TransactionType.expense:
        return 'pengeluaran';
      case TransactionType.transfer:
        return 'transfer';
    }
  }
}
