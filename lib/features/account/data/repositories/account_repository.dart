import '../models/user_model.dart';
import '../models/settings_model.dart';
import '../models/backup_model.dart';
import '../services/account_service.dart';
import '../services/backup_service.dart';
import '../services/local_storage_service.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../../core/services/offline_mode_service.dart';

class AccountRepository {
  final AccountService accountService;
  final BackupService backupService;
  final LocalStorageService localStorageService;
  final Box<UserModel> userBox;
  final Box<SettingsModel> settingsBox;
  final OfflineModeService offlineModeService;

  AccountRepository({
    required this.accountService,
    required this.backupService,
    required this.localStorageService,
    required this.userBox,
    required this.settingsBox,
    required this.offlineModeService,
  });

  /// Fetch current user profile
  Future<UserModel?> fetchUser() async {
    if (offlineModeService.isOfflineMode) {
      if (userBox.isNotEmpty) {
        return userBox.getAt(0);
      }
      return null;
    }

    try {
      final user = await accountService.getCurrentUser();
      if (user != null) {
        await userBox.put('current_user', user);
      }
      return user;
    } catch (e) {
      if (userBox.isNotEmpty) {
        return userBox.get('current_user');
      }
      return null;
    }
  }

  /// Fetch user settings
  Future<SettingsModel> fetchSettings() async {
    if (offlineModeService.isOfflineMode) {
      if (settingsBox.isNotEmpty) {
        return settingsBox.getAt(0)!;
      }
      return SettingsModel.defaults();
    }

    try {
      final settings = await accountService.getSettings();
      if (settings != null) {
        await settingsBox.put('settings', settings);
      }
      return settings ?? SettingsModel.defaults();
    } catch (e) {
      if (settingsBox.isNotEmpty) {
        return settingsBox.get('settings') ?? SettingsModel.defaults();
      }
      return SettingsModel.defaults();
    }
  }

  /// Update user profile
  Future<UserModel> updateUser(UserModel user) =>
      accountService.updateUser(user);

  /// Update user settings
  Future<SettingsModel> updateSettings(SettingsModel settings) =>
      accountService.updateSettings(settings);

  /// Backup data
  Future<BackupModel> backupData() => backupService.backupData();

  /// Reset all local data
  Future<void> resetData() => localStorageService.resetData();
}
