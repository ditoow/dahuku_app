import '../models/comic_model.dart';
import '../services/comic_service.dart';

/// Repository untuk operasi komik
class ComicRepository {
  final ComicService _service;

  ComicRepository(this._service);

  /// Get semua komik
  Future<List<ComicModel>> getComics() => _service.getComics();

  /// Get komik featured
  Future<List<ComicModel>> getFeaturedComics() => _service.getFeaturedComics();

  /// Get komik by ID
  Future<ComicModel?> getComicById(String id) => _service.getComicById(id);

  /// Get episodes untuk komik
  Future<List<EpisodeModel>> getEpisodes(String komikId) =>
      _service.getEpisodes(komikId);

  /// Get episode by ID
  Future<EpisodeModel?> getEpisodeById(String id) =>
      _service.getEpisodeById(id);

  /// Get progress user untuk komik
  Future<ComicProgressModel?> getProgress(String komikId) =>
      _service.getProgress(komikId);

  /// Update progress
  Future<ComicProgressModel> updateProgress({
    required String komikId,
    required int episodeTerakhir,
    required int halamanTerakhir,
    bool selesai = false,
  }) => _service.upsertProgress(
    komikId: komikId,
    episodeTerakhir: episodeTerakhir,
    halamanTerakhir: halamanTerakhir,
    selesai: selesai,
  );

  /// Get all progress untuk user
  Future<List<ComicProgressModel>> getAllProgress() =>
      _service.getAllProgress();
}
