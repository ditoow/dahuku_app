import '../models/backup_model.dart';

class BackupService {
  Future<BackupModel> backupData() async {
    await Future.delayed(const Duration(seconds: 1));
    return BackupModel(
      lastBackup: DateTime.now(),
      success: true,
    );
  }
}
