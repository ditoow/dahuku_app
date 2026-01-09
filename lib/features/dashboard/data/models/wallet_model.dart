import 'package:equatable/equatable.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'wallet_model.g.dart';

/// Tipe dompet
@HiveType(typeId: 4)
enum WalletType {
  @HiveField(0)
  belanja,
  @HiveField(1)
  tabungan,
  @HiveField(2)
  darurat,
}

/// Model dompet untuk Supabase
@HiveType(typeId: 1)
class WalletModel extends Equatable {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String userId;
  @HiveField(2)
  final String name;
  @HiveField(3)
  final WalletType type;
  @HiveField(4)
  final double balance;
  @HiveField(5)
  final bool isPrimary;
  @HiveField(6)
  final String? iconName;
  @HiveField(7)
  final String? colorHex;
  @HiveField(8)
  final DateTime? createdAt;
  @HiveField(9)
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
