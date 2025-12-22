import 'package:equatable/equatable.dart';

/// Model user untuk fitur account
class UserModel extends Equatable {
  final String id;
  final String name;
  final String email;
  final String? avatarUrl;
  final String? phone;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.avatarUrl,
    this.phone,
    this.createdAt,
    this.updatedAt,
  });

  /// Default user untuk state awal
  factory UserModel.empty() {
    return const UserModel(id: '', name: '', email: '');
  }

  /// Buat dari JSON (response Supabase - Indonesia)
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      name: json['nama'] as String,
      email: json['email'] as String,
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
      'nama': name,
      'email': email,
      'url_avatar': avatarUrl,
      'telepon': phone,
      'diperbarui_pada': DateTime.now().toIso8601String(),
    };
  }

  /// Copy dengan perubahan
  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? avatarUrl,
    String? phone,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      phone: phone ?? this.phone,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    email,
    avatarUrl,
    phone,
    createdAt,
    updatedAt,
  ];
}
