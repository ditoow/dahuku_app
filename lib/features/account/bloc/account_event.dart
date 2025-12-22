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


class LogoutRequested extends AccountEvent {}
