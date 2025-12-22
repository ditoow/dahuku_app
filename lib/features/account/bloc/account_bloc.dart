import 'package:flutter_bloc/flutter_bloc.dart';
import 'account_event.dart';
import 'account_state.dart';
import '../data/models/user_model.dart';
import '../data/repositories/account_repository.dart';

class AccountBloc extends Bloc<AccountEvent, AccountState> {
  final AccountRepository repository;

  AccountBloc(this.repository) : super(AccountLoading()) {
    // =========================
    // LOAD DATA AWAL
    // =========================
    on<LoadAccount>((event, emit) async {
      emit(AccountLoading());
      try {
        final user = await repository.fetchUser();
        final settings = await repository.fetchSettings();
        emit(
          AccountLoaded(user: user ?? UserModel.empty(), settings: settings),
        );
      } catch (e) {
        emit(AccountError(e.toString()));
      }
    });

    // =========================
    // OFFLINE MODE
    // =========================
    on<ToggleOfflineMode>((event, emit) async {
      if (state is AccountLoaded) {
        final current = state as AccountLoaded;
        final newSettings = current.settings.copyWith(offlineMode: event.value);

        // Update locally first
        emit(current.copyWith(settings: newSettings));

        // Then save to Supabase
        try {
          await repository.updateSettings(newSettings);
        } catch (e) {
          // Revert on error
          emit(current);
        }
      }
    });

    // =========================
    // FONT SIZE
    // =========================
    on<ChangeFontSize>((event, emit) async {
      if (state is AccountLoaded) {
        final current = state as AccountLoaded;
        final newSettings = current.settings.copyWith(fontSize: event.size);

        emit(current.copyWith(settings: newSettings));

        try {
          await repository.updateSettings(newSettings);
        } catch (e) {
          emit(current);
        }
      }
    });

    // =========================
    // HIGH CONTRAST
    // =========================
    on<ToggleHighContrast>((event, emit) async {
      if (state is AccountLoaded) {
        final current = state as AccountLoaded;
        final newSettings = current.settings.copyWith(
          highContrast: event.value,
        );

        emit(current.copyWith(settings: newSettings));

        try {
          await repository.updateSettings(newSettings);
        } catch (e) {
          emit(current);
        }
      }
    });

    // =========================
    // UPDATE PROFILE
    // =========================
    on<UpdateProfile>((event, emit) async {
      if (state is AccountLoaded) {
        final current = state as AccountLoaded;
        emit(AccountLoading());

        try {
          final updatedUser = await repository.updateUser(
            current.user.copyWith(
              name: event.name ?? current.user.name,
              phone: event.phone ?? current.user.phone,
              avatarUrl: event.avatarUrl ?? current.user.avatarUrl,
            ),
          );
          emit(current.copyWith(user: updatedUser));
        } catch (e) {
          emit(AccountError(e.toString()));
        }
      }
    });
  }
}
