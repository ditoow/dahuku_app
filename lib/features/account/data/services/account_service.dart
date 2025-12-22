import '../../../../core/data/services/supabase_service.dart';
import '../models/user_model.dart';
import '../models/settings_model.dart';

/// Service untuk operasi akun Supabase
class AccountService {
  static const String _usersTable = 'pengguna';
  static const String _settingsTable = 'pengaturan_pengguna';

  /// Get user profile saat ini
  Future<UserModel?> getCurrentUser() async {
    final userId = SupabaseService.currentUserId;
    if (userId == null) return null;

    final response = await SupabaseService.client
        .from(_usersTable)
        .select()
        .eq('id', userId)
        .maybeSingle();

    if (response == null) return null;
    return UserModel.fromJson(response);
  }

  /// Update user profile
  Future<UserModel> updateUser(UserModel user) async {
    final userId = SupabaseService.currentUserId;
    if (userId == null) throw Exception('User belum login');

    final response = await SupabaseService.client
        .from(_usersTable)
        .update(user.toJson())
        .eq('id', userId)
        .select()
        .single();

    return UserModel.fromJson(response);
  }

  /// Get user settings
  Future<SettingsModel?> getSettings() async {
    final userId = SupabaseService.currentUserId;
    if (userId == null) return null;

    final response = await SupabaseService.client
        .from(_settingsTable)
        .select()
        .eq('id_pengguna', userId)
        .maybeSingle();

    if (response == null) {
      // Create default settings jika belum ada
      return await _createDefaultSettings(userId);
    }

    return SettingsModel.fromJson(response);
  }

  /// Create default settings
  Future<SettingsModel> _createDefaultSettings(String userId) async {
    final defaultSettings = SettingsModel(
      offlineMode: false,
      fontSize: 'sedang',
      highContrast: false,
      language: 'id',
      notificationEnabled: true,
      biometricEnabled: false,
    );

    final response = await SupabaseService.client
        .from(_settingsTable)
        .insert({'id_pengguna': userId, ...defaultSettings.toJson()})
        .select()
        .single();

    return SettingsModel.fromJson(response);
  }

  /// Update user settings
  Future<SettingsModel> updateSettings(SettingsModel settings) async {
    final userId = SupabaseService.currentUserId;
    if (userId == null) throw Exception('User belum login');

    final response = await SupabaseService.client
        .from(_settingsTable)
        .update(settings.toJson())
        .eq('id_pengguna', userId)
        .select()
        .single();

    return SettingsModel.fromJson(response);
  }
}
