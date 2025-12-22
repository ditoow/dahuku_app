import 'package:flutter_bloc/flutter_bloc.dart';
import 'account_event.dart';
import 'account_state.dart';
import '../data/repositories/account_repository.dart';

class AccountBloc extends Bloc<AccountEvent, AccountState> {
  final AccountRepository repository;

  AccountBloc(this.repository) : super(AccountLoading()) {
    // =========================
    // LOAD DATA AWAL
    // =========================
    on<LoadAccount>((event, emit) async {
      final user = await repository.fetchUser();
      final settings = await repository.fetchSettings();
      emit(AccountLoaded(user: user, settings: settings));
    });

    // =========================
    // OFFLINE MODE
    // =========================
    on<ToggleOfflineMode>((event, emit) {
      if (state is AccountLoaded) {
        final current = state as AccountLoaded;
        emit(
          current.copyWith(
            settings: current.settings.copyWith(
              offlineMode: event.value,
            ),
          ),
        );
      }
    });

    // =========================
    // FONT SIZE
    // =========================
    on<ChangeFontSize>((event, emit) {
      if (state is AccountLoaded) {
        final current = state as AccountLoaded;
        emit(
          current.copyWith(
            settings: current.settings.copyWith(
              fontSize: event.size,
            ),
          ),
        );
      }
    });

    // =========================
    // HIGH CONTRAST
    // =========================
    on<ToggleHighContrast>((event, emit) {
      if (state is AccountLoaded) {
        final current = state as AccountLoaded;
        emit(
          current.copyWith(
            settings: current.settings.copyWith(
              highContrast: event.value,
            ),
          ),
        );
      }
    });
  }
}
