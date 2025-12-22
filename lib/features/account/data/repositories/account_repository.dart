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

  Future<UserModel> fetchUser() => accountService.getUser();

  Future<SettingsModel> fetchSettings() => accountService.getSettings();

  Future<BackupModel> backupData() => backupService.backupData();

  Future<void> resetData() => localStorageService.resetData();
}
