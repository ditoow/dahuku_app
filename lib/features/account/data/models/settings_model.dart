import 'package:equatable/equatable.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'settings_model.g.dart';

/// Model pengaturan user
@HiveType(typeId: 9)
class SettingsModel extends Equatable {
  @HiveField(0)
  final bool offlineMode;
  @HiveField(1)
  final String fontSize;
  @HiveField(2)
  final bool highContrast;
  @HiveField(3)
  final String language;
  @HiveField(4)
  final bool notificationEnabled;
  @HiveField(5)
  final bool biometricEnabled;

  const SettingsModel({
    this.offlineMode = false,
    this.fontSize = 'sedang',
    this.highContrast = false,
    this.language = 'id',
    this.notificationEnabled = true,
    this.biometricEnabled = false,
  });

  /// Default settings
  factory SettingsModel.defaults() {
    return const SettingsModel();
  }

  /// Buat dari JSON (response Supabase - Indonesia)
  factory SettingsModel.fromJson(Map<String, dynamic> json) {
    return SettingsModel(
      offlineMode: json['mode_offline'] as bool? ?? false,
      fontSize: json['ukuran_font'] as String? ?? 'sedang',
      highContrast: json['kontras_tinggi'] as bool? ?? false,
      language: json['bahasa'] as String? ?? 'id',
      notificationEnabled: json['notifikasi_aktif'] as bool? ?? true,
      biometricEnabled: json['biometrik_aktif'] as bool? ?? false,
    );
  }

  /// Konversi ke JSON untuk Supabase (nama kolom Indonesia)
  Map<String, dynamic> toJson() {
    return {
      'mode_offline': offlineMode,
      'ukuran_font': fontSize,
      'kontras_tinggi': highContrast,
      'bahasa': language,
      'notifikasi_aktif': notificationEnabled,
      'biometrik_aktif': biometricEnabled,
      'diperbarui_pada': DateTime.now().toIso8601String(),
    };
  }

  /// Copy dengan perubahan
  SettingsModel copyWith({
    bool? offlineMode,
    String? fontSize,
    bool? highContrast,
    String? language,
    bool? notificationEnabled,
    bool? biometricEnabled,
  }) {
    return SettingsModel(
      offlineMode: offlineMode ?? this.offlineMode,
      fontSize: fontSize ?? this.fontSize,
      highContrast: highContrast ?? this.highContrast,
      language: language ?? this.language,
      notificationEnabled: notificationEnabled ?? this.notificationEnabled,
      biometricEnabled: biometricEnabled ?? this.biometricEnabled,
    );
  }

  @override
  List<Object?> get props => [
    offlineMode,
    fontSize,
    highContrast,
    language,
    notificationEnabled,
    biometricEnabled,
  ];
}
