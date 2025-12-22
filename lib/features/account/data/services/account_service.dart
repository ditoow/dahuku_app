import '../models/user_model.dart';
import '../models/settings_model.dart';

class AccountService {
  Future<UserModel> getUser() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return UserModel(
      name: 'Rizky Pratama',
      email: 'rizky.pratama@example.com',
      avatarUrl: 'assets/avatar.png',
    );
  }

  Future<SettingsModel> getSettings() async {
    return SettingsModel(
      offlineMode: false,
      highContrast: false,
      fontSize: 'Sedang',
    );
  }
}
