import '../../../../core/data/services/supabase_service.dart';
import '../models/wallet_model.dart';

/// Service untuk operasi Supabase dompet
class WalletService {
  static const String _tableName = 'dompet';

  /// Get semua dompet untuk user saat ini
  Future<List<WalletModel>> getWallets() async {
    final userId = SupabaseService.currentUserId;
    if (userId == null) throw Exception('User belum login');

    final response = await SupabaseService.client
        .from(_tableName)
        .select()
        .eq('id_pengguna', userId)
        .order('utama', ascending: false)
        .order('dibuat_pada');

    return (response as List)
        .map((json) => WalletModel.fromJson(json))
        .toList();
  }

  /// Get dompet berdasarkan ID
  Future<WalletModel?> getWalletById(String id) async {
    final userId = SupabaseService.currentUserId;
    if (userId == null) throw Exception('User belum login');

    final response = await SupabaseService.client
        .from(_tableName)
        .select()
        .eq('id', id)
        .eq('id_pengguna', userId)
        .maybeSingle();

    if (response == null) return null;
    return WalletModel.fromJson(response);
  }

  /// Buat dompet baru
  Future<WalletModel> createWallet(WalletModel wallet) async {
    final data = wallet.toJson();
    data.remove('id'); // Remove empty ID to let DB generate it

    final response = await SupabaseService.client
        .from(_tableName)
        .insert(data)
        .select()
        .single();

    return WalletModel.fromJson(response);
  }

  /// Update dompet
  Future<WalletModel> updateWallet(WalletModel wallet) async {
    final response = await SupabaseService.client
        .from(_tableName)
        .update(wallet.toJson())
        .eq('id', wallet.id)
        .select()
        .single();

    return WalletModel.fromJson(response);
  }

  /// Hapus dompet
  Future<void> deleteWallet(String id) async {
    await SupabaseService.client.from(_tableName).delete().eq('id', id);
  }

  /// Get total saldo semua dompet
  Future<double> getTotalBalance() async {
    final wallets = await getWallets();
    double total = 0.0;
    for (final wallet in wallets) {
      total += wallet.balance;
    }
    return total;
  }
}
