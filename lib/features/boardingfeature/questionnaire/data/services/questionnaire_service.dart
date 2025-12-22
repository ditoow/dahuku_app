import '../../../../../core/data/services/supabase_service.dart';
import '../models/questionnaire_model.dart';

/// Service untuk operasi kuesioner Supabase
class QuestionnaireService {
  static const String _tableName = 'respon_kuesioner';

  /// Simpan respon kuesioner
  Future<QuestionnaireModel> saveResponse(QuestionnaireModel response) async {
    final userId = SupabaseService.currentUserId;
    if (userId == null) throw Exception('User belum login');

    final data = response.toJson();
    data['id_pengguna'] = userId;

    final result = await SupabaseService.client
        .from(_tableName)
        .upsert(data, onConflict: 'id_pengguna')
        .select()
        .single();

    // Buat dompet berdasarkan input
    await _createWallets(userId, response);

    return QuestionnaireModel.fromJson(result);
  }

  /// Buat 3 dompet awal
  Future<void> _createWallets(
    String userId,
    QuestionnaireModel response,
  ) async {
    final wallets = [
      {
        'id_pengguna': userId,
        'nama': 'Dompet Belanja',
        'tipe': 'belanja',
        'saldo': response.initialBelanja,
        'utama': true,
        'nama_ikon': 'shopping_bag',
        'warna_hex': 'FF304AFF',
      },
      {
        'id_pengguna': userId,
        'nama': 'Dompet Tabungan',
        'tipe': 'tabungan',
        'saldo': response.initialTabungan,
        'utama': false,
        'nama_ikon': 'savings',
        'warna_hex': 'FF00C853',
      },
      {
        'id_pengguna': userId,
        'nama': 'Dompet Darurat',
        'tipe': 'darurat',
        'saldo': response.initialDarurat,
        'utama': false,
        'nama_ikon': 'medical_services',
        'warna_hex': 'FFD50000',
      },
    ];

    // Gunakan upsert agar tidak duplikat jika dijalankan ulang
    // Namun idealnya dompet punya ID unik. Kita asumsikan insert baru.
    // Jika ingin idempotent, kita perlu logic cek dulu.
    // Untuk onboarding, kita insert saja.

    await SupabaseService.client.from('dompet').insert(wallets);
  }

  /// Get respon kuesioner user saat ini
  Future<QuestionnaireModel?> getResponse() async {
    final userId = SupabaseService.currentUserId;
    if (userId == null) return null;

    final response = await SupabaseService.client
        .from(_tableName)
        .select()
        .eq('id_pengguna', userId)
        .maybeSingle();

    if (response == null) return null;
    return QuestionnaireModel.fromJson(response);
  }

  /// Cek apakah user sudah menyelesaikan kuesioner
  Future<bool> hasCompletedQuestionnaire() async {
    final response = await getResponse();
    return response != null;
  }
}
