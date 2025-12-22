import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../../core/data/services/supabase_service.dart';
import '../models/auth_user_model.dart';

/// Service untuk operasi autentikasi Supabase
class AuthService {
  static const String _usersTable = 'pengguna';

  /// Register user baru
  Future<AuthUserModel> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    // 1. Create auth user
    final authResponse = await SupabaseService.client.auth.signUp(
      email: email,
      password: password,
    );

    if (authResponse.user == null) {
      throw Exception('Gagal membuat akun');
    }

    // 2. Create user profile
    final userId = authResponse.user!.id;
    final now = DateTime.now().toIso8601String();

    await SupabaseService.client.from(_usersTable).insert({
      'id': userId,
      'nama': name,
      'email': email,
      'dibuat_pada': now,
      'diperbarui_pada': now,
    });

    return AuthUserModel(
      id: userId,
      email: email,
      name: name,
      createdAt: DateTime.now(),
    );
  }

  /// Login user
  Future<AuthUserModel> signIn({
    required String email,
    required String password,
  }) async {
    final authResponse = await SupabaseService.client.auth.signInWithPassword(
      email: email,
      password: password,
    );

    if (authResponse.user == null) {
      throw Exception('Email atau password salah');
    }

    // Get user profile
    final profile = await SupabaseService.client
        .from(_usersTable)
        .select()
        .eq('id', authResponse.user!.id)
        .single();

    return AuthUserModel.fromJson(profile);
  }

  /// Logout user
  Future<void> signOut() async {
    await SupabaseService.client.auth.signOut();
  }

  /// Get current user
  Future<AuthUserModel?> getCurrentUser() async {
    final userId = SupabaseService.currentUserId;
    if (userId == null) return null;

    final response = await SupabaseService.client
        .from(_usersTable)
        .select()
        .eq('id', userId)
        .maybeSingle();

    if (response == null) return null;
    return AuthUserModel.fromJson(response);
  }

  /// Update user profile
  Future<AuthUserModel> updateProfile({
    String? name,
    String? avatarUrl,
    String? phone,
  }) async {
    final userId = SupabaseService.currentUserId;
    if (userId == null) throw Exception('User belum login');

    final updates = <String, dynamic>{
      'diperbarui_pada': DateTime.now().toIso8601String(),
    };

    if (name != null) updates['nama'] = name;
    if (avatarUrl != null) updates['url_avatar'] = avatarUrl;
    if (phone != null) updates['telepon'] = phone;

    final response = await SupabaseService.client
        .from(_usersTable)
        .update(updates)
        .eq('id', userId)
        .select()
        .single();

    return AuthUserModel.fromJson(response);
  }

  /// Kirim email reset password
  Future<void> sendPasswordResetEmail(String email) async {
    await SupabaseService.client.auth.resetPasswordForEmail(email);
  }

  /// Cek apakah user sudah login
  bool get isAuthenticated => SupabaseService.isAuthenticated;

  /// Stream perubahan status auth
  Stream<AuthState> get authStateChanges =>
      SupabaseService.client.auth.onAuthStateChange;
}
