import '../data/models/user_model.dart';
import '../data/models/settings_model.dart';

abstract class AccountState {}

class AccountLoading extends AccountState {}

class AccountLoaded extends AccountState {
  final UserModel user;
  final SettingsModel settings;

  AccountLoaded({required this.user, required this.settings});

  /// copyWith untuk update sebagian state
  AccountLoaded copyWith({UserModel? user, SettingsModel? settings}) {
    return AccountLoaded(
      user: user ?? this.user,
      settings: settings ?? this.settings,
    );
  }
}

class AccountError extends AccountState {
  final String message;
  AccountError(this.message);
}
