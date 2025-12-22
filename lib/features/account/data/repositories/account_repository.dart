import '../models/user_model.dart';
import '../models/settings_model.dart';
import '../models/backup_model.dart';
import '../services/account_service.dart';
import '../services/backup_service.dart';
import '../services/local_storage_service.dart';

class AccountRepository {
  final AccountService accountService;
  final BackupService backupService;
  final LocalStorageService localStorageService;

  AccountRepository({
    required this.accountService,
    required this.backupService,
    required this.localStorageService,
  });

  /// Fetch current user profile
  Future<UserModel?> fetchUser() => accountService.getCurrentUser();

  /// Fetch user settings
  Future<SettingsModel> fetchSettings() async {
    final settings = await accountService.getSettings();
    return settings ?? SettingsModel.defaults();
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
