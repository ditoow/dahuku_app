import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../../core/data/services/supabase_service.dart';

/// Service untuk transfer uang antar dompet via Supabase
class TransferService {
  final SupabaseClient _client = SupabaseService.client;

  /// Transfer uang dari dompet sumber ke dompet tujuan
  /// Returns transaction ID jika sukses
  Future<String> transferUang({
    required String idDompetSumber,
    required String idDompetTujuan,
    required double jumlah,
    String? deskripsi,
  }) async {
    final userId = SupabaseService.currentUserId;
    if (userId == null) {
      throw Exception('User tidak terautentikasi');
    }

    // Insert transaksi transfer
    final response = await _client
        .from('transaksi')
        .insert({
          'id_pengguna': userId,
          'id_dompet': idDompetSumber,
          'id_dompet_tujuan': idDompetTujuan,
          'judul': 'Transfer Antar Dompet',
          'deskripsi': deskripsi ?? 'Transfer dari dompet',
          'jumlah': jumlah,
          'tipe': 'transfer',
          'tanggal_transaksi': DateTime.now().toIso8601String().split('T')[0],
        })
        .select('id')
        .single();

    return response['id'] as String;
  }

  /// Ambil dompet berdasarkan tipe untuk user saat ini
  Future<Map<String, dynamic>?> getDompetByTipe(String tipe) async {
    final userId = SupabaseService.currentUserId;
    if (userId == null) return null;

    final response = await _client
        .from('dompet')
        .select()
        .eq('id_pengguna', userId)
        .eq('tipe', tipe)
        .maybeSingle();

    return response;
  }

  /// Ambil semua dompet user
  Future<List<Map<String, dynamic>>> getAllDompet() async {
    final userId = SupabaseService.currentUserId;
    if (userId == null) return [];

    final response = await _client
        .from('dompet')
        .select()
        .eq('id_pengguna', userId)
        .order('utama', ascending: false);

    return List<Map<String, dynamic>>.from(response);
  }
}
