import 'package:equatable/equatable.dart';

/// Tipe dompet
enum WalletType { belanja, tabungan, darurat }

/// Model dompet untuk Supabase
class WalletModel extends Equatable {
  final String id;
  final String userId;
  final String name;
  final WalletType type;
  final double balance;
  final bool isPrimary;
  final String? iconName;
  final String? colorHex;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const WalletModel({
    required this.id,
    required this.userId,
    required this.name,
    required this.type,
    this.balance = 0,
    this.isPrimary = false,
    this.iconName,
    this.colorHex,
    this.createdAt,
    this.updatedAt,
  });

  /// Buat dari JSON (response Supabase - Indonesia)
  factory WalletModel.fromJson(Map<String, dynamic> json) {
    return WalletModel(
      id: json['id'] as String,
      userId: json['id_pengguna'] as String,
      name: json['nama'] as String,
      type: WalletType.values.firstWhere(
        (e) => e.name == json['tipe'],
        orElse: () => WalletType.belanja,
      ),
      balance: (json['saldo'] as num?)?.toDouble() ?? 0,
      isPrimary: json['utama'] as bool? ?? false,
      iconName: json['nama_ikon'] as String?,
      colorHex: json['warna_hex'] as String?,
      createdAt: json['dibuat_pada'] != null
          ? DateTime.parse(json['dibuat_pada'] as String)
          : null,
      updatedAt: json['diperbarui_pada'] != null
          ? DateTime.parse(json['diperbarui_pada'] as String)
          : null,
    );
  }

  /// Konversi ke JSON untuk Supabase (nama kolom Indonesia)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'id_pengguna': userId,
      'nama': name,
      'tipe': type.name,
      'saldo': balance,
      'utama': isPrimary,
      'nama_ikon': iconName,
      'warna_hex': colorHex,
    };
  }

  /// Copy dengan perubahan
  WalletModel copyWith({
    String? id,
    String? userId,
    String? name,
    WalletType? type,
    double? balance,
    bool? isPrimary,
    String? iconName,
    String? colorHex,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return WalletModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      type: type ?? this.type,
      balance: balance ?? this.balance,
      isPrimary: isPrimary ?? this.isPrimary,
      iconName: iconName ?? this.iconName,
      colorHex: colorHex ?? this.colorHex,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    userId,
    name,
    type,
    balance,
    isPrimary,
    iconName,
    colorHex,
    createdAt,
    updatedAt,
  ];
}
