import 'package:equatable/equatable.dart';

/// Model untuk Komik
class ComicModel extends Equatable {
  final String id;
  final String judul;
  final String? deskripsi;
  final String? coverUrl;
  final String kategori;
  final int totalEpisode;
  final bool isFeatured;
  final String warnaTema;
  final DateTime? dibuatPada;
  final DateTime? diperbaruiPada;

  const ComicModel({
    required this.id,
    required this.judul,
    this.deskripsi,
    this.coverUrl,
    this.kategori = 'menabung',
    this.totalEpisode = 0,
    this.isFeatured = false,
    this.warnaTema = '#304AFF',
    this.dibuatPada,
    this.diperbaruiPada,
  });

  factory ComicModel.fromJson(Map<String, dynamic> json) {
    return ComicModel(
      id: json['id'] as String,
      judul: json['judul'] as String,
      deskripsi: json['deskripsi'] as String?,
      coverUrl: json['cover_url'] as String?,
      kategori: json['kategori'] as String? ?? 'menabung',
      totalEpisode: json['total_episode'] as int? ?? 0,
      isFeatured: json['is_featured'] as bool? ?? false,
      warnaTema: json['warna_tema'] as String? ?? '#304AFF',
      dibuatPada: json['dibuat_pada'] != null
          ? DateTime.parse(json['dibuat_pada'] as String)
          : null,
      diperbaruiPada: json['diperbarui_pada'] != null
          ? DateTime.parse(json['diperbarui_pada'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'judul': judul,
      'deskripsi': deskripsi,
      'cover_url': coverUrl,
      'kategori': kategori,
      'total_episode': totalEpisode,
      'is_featured': isFeatured,
      'warna_tema': warnaTema,
    };
  }

  @override
  List<Object?> get props => [
    id,
    judul,
    deskripsi,
    coverUrl,
    kategori,
    totalEpisode,
    isFeatured,
    warnaTema,
  ];
}

/// Model untuk Episode Komik
class EpisodeModel extends Equatable {
  final String id;
  final String komikId;
  final int nomorEpisode;
  final String judul;
  final List<String> gambarUrls;
  final DateTime? dibuatPada;

  const EpisodeModel({
    required this.id,
    required this.komikId,
    required this.nomorEpisode,
    required this.judul,
    required this.gambarUrls,
    this.dibuatPada,
  });

  factory EpisodeModel.fromJson(Map<String, dynamic> json) {
    return EpisodeModel(
      id: json['id'] as String,
      komikId: json['komik_id'] as String,
      nomorEpisode: json['nomor_episode'] as int,
      judul: json['judul'] as String,
      gambarUrls:
          (json['gambar_urls'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      dibuatPada: json['dibuat_pada'] != null
          ? DateTime.parse(json['dibuat_pada'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'komik_id': komikId,
      'nomor_episode': nomorEpisode,
      'judul': judul,
      'gambar_urls': gambarUrls,
    };
  }

  @override
  List<Object?> get props => [id, komikId, nomorEpisode, judul, gambarUrls];
}

/// Model untuk Progress Komik User
class ComicProgressModel extends Equatable {
  final String id;
  final String userId;
  final String komikId;
  final int episodeTerakhir;
  final int halamanTerakhir;
  final bool selesai;
  final DateTime? dibuatPada;
  final DateTime? diperbaruiPada;

  const ComicProgressModel({
    required this.id,
    required this.userId,
    required this.komikId,
    this.episodeTerakhir = 0,
    this.halamanTerakhir = 0,
    this.selesai = false,
    this.dibuatPada,
    this.diperbaruiPada,
  });

  factory ComicProgressModel.fromJson(Map<String, dynamic> json) {
    return ComicProgressModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      komikId: json['komik_id'] as String,
      episodeTerakhir: json['episode_terakhir'] as int? ?? 0,
      halamanTerakhir: json['halaman_terakhir'] as int? ?? 0,
      selesai: json['selesai'] as bool? ?? false,
      dibuatPada: json['dibuat_pada'] != null
          ? DateTime.parse(json['dibuat_pada'] as String)
          : null,
      diperbaruiPada: json['diperbarui_pada'] != null
          ? DateTime.parse(json['diperbarui_pada'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'komik_id': komikId,
      'episode_terakhir': episodeTerakhir,
      'halaman_terakhir': halamanTerakhir,
      'selesai': selesai,
    };
  }

  ComicProgressModel copyWith({
    int? episodeTerakhir,
    int? halamanTerakhir,
    bool? selesai,
  }) {
    return ComicProgressModel(
      id: id,
      userId: userId,
      komikId: komikId,
      episodeTerakhir: episodeTerakhir ?? this.episodeTerakhir,
      halamanTerakhir: halamanTerakhir ?? this.halamanTerakhir,
      selesai: selesai ?? this.selesai,
      dibuatPada: dibuatPada,
      diperbaruiPada: DateTime.now(),
    );
  }

  @override
  List<Object?> get props => [
    id,
    userId,
    komikId,
    episodeTerakhir,
    halamanTerakhir,
    selesai,
  ];
}
