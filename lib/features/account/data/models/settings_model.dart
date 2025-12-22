class SettingsModel {
  final bool offlineMode;
  final String fontSize;
  final bool highContrast;

  const SettingsModel({
    required this.offlineMode,
    required this.fontSize,
    required this.highContrast,
  });

  SettingsModel copyWith({
    bool? offlineMode,
    String? fontSize,
    bool? highContrast,
  }) {
    return SettingsModel(
      offlineMode: offlineMode ?? this.offlineMode,
      fontSize: fontSize ?? this.fontSize,
      highContrast: highContrast ?? this.highContrast,
    );
  }
}
