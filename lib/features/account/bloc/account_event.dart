abstract class AccountEvent {}

class LoadAccount extends AccountEvent {}

class ToggleOfflineMode extends AccountEvent {
  final bool value;
  ToggleOfflineMode(this.value);
}

class ChangeFontSize extends AccountEvent {
  final String size;
  ChangeFontSize(this.size);
}

class ToggleHighContrast extends AccountEvent {
  final bool value;
  ToggleHighContrast(this.value);
}

class UpdateProfile extends AccountEvent {
  final String? name;
  final String? phone;
  final String? avatarUrl;

  UpdateProfile({this.name, this.phone, this.avatarUrl});
}

class LogoutRequested extends AccountEvent {}
