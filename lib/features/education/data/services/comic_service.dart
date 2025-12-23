import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/comic_model.dart';

/// Service untuk operasi komik dengan Supabase
class ComicService {
  final SupabaseClient _supabase = Supabase.instance.client;

  /// Get semua komik
  Future<List<ComicModel>> getComics() async {
    final response = await _supabase
        .from('komik')
        .select()
        .order('dibuat_pada', ascending: false);

    return (response as List).map((json) => ComicModel.fromJson(json)).toList();
  }

  /// Get komik featured
  Future<List<ComicModel>> getFeaturedComics() async {
    final response = await _supabase
        .from('komik')
        .select()
        .eq('is_featured', true)
        .order('dibuat_pada', ascending: false);

    return (response as List).map((json) => ComicModel.fromJson(json)).toList();
  }

  /// Get komik by ID
  Future<ComicModel?> getComicById(String id) async {
    final response = await _supabase
        .from('komik')
        .select()
        .eq('id', id)
        .maybeSingle();

    if (response == null) return null;
    return ComicModel.fromJson(response);
  }

  /// Get episodes untuk komik
  Future<List<EpisodeModel>> getEpisodes(String komikId) async {
    final response = await _supabase
        .from('episode_komik')
        .select()
        .eq('komik_id', komikId)
        .order('nomor_episode', ascending: true);

    return (response as List)
        .map((json) => EpisodeModel.fromJson(json))
        .toList();
  }

  /// Get episode by ID
  Future<EpisodeModel?> getEpisodeById(String id) async {
    final response = await _supabase
        .from('episode_komik')
        .select()
        .eq('id', id)
        .maybeSingle();

    if (response == null) return null;
    return EpisodeModel.fromJson(response);
  }

  /// Get progress user untuk komik
  Future<ComicProgressModel?> getProgress(String komikId) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return null;

    final response = await _supabase
        .from('progres_komik')
        .select()
        .eq('user_id', userId)
        .eq('komik_id', komikId)
        .maybeSingle();

    if (response == null) return null;
    return ComicProgressModel.fromJson(response);
  }

  /// Update atau create progress
  Future<ComicProgressModel> upsertProgress({
    required String komikId,
    required int episodeTerakhir,
    required int halamanTerakhir,
    bool selesai = false,
  }) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) {
      throw Exception('User tidak login');
    }

    final data = {
      'user_id': userId,
      'komik_id': komikId,
      'episode_terakhir': episodeTerakhir,
      'halaman_terakhir': halamanTerakhir,
      'selesai': selesai,
      'diperbarui_pada': DateTime.now().toIso8601String(),
    };

    final response = await _supabase
        .from('progres_komik')
        .upsert(data, onConflict: 'user_id,komik_id')
        .select()
        .single();

    return ComicProgressModel.fromJson(response);
  }

  /// Get all progress untuk user (untuk dashboard)
  Future<List<ComicProgressModel>> getAllProgress() async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return [];

    final response = await _supabase
        .from('progres_komik')
        .select()
        .eq('user_id', userId);

    return (response as List)
        .map((json) => ComicProgressModel.fromJson(json))
        .toList();
  }
}
