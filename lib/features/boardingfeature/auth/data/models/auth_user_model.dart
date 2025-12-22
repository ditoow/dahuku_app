import 'package:equatable/equatable.dart';

/// Model user untuk autentikasi Supabase
class AuthUserModel extends Equatable {
  final String id;
  final String email;
  final String name;
  final String? avatarUrl;
  final String? phone;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const AuthUserModel({
    required this.id,
    required this.email,
    required this.name,
    this.avatarUrl,
    this.phone,
    this.createdAt,
    this.updatedAt,
  });

  /// Buat dari JSON (response Supabase - Indonesia)
  factory AuthUserModel.fromJson(Map<String, dynamic> json) {
    return AuthUserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['nama'] as String,
      avatarUrl: json['url_avatar'] as String?,
      phone: json['telepon'] as String?,
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
      'email': email,
      'nama': name,
      'url_avatar': avatarUrl,
      'telepon': phone,
    };
  }

  /// Copy dengan perubahan
  AuthUserModel copyWith({
    String? id,
    String? email,
    String? name,
    String? avatarUrl,
    String? phone,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AuthUserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      phone: phone ?? this.phone,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    email,
    name,
    avatarUrl,
    phone,
    createdAt,
    updatedAt,
  ];
}
