import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'pin_event.dart';
part 'pin_state.dart';

class PinBloc extends Bloc<PinEvent, PinState> {
  PinBloc() : super(const PinState()) {
    on<PinDigitEntered>(_onDigitEntered);
    on<PinDigitRemoved>(_onDigitRemoved);
    on<PinSubmitted>(_onSubmitted);
    on<PinReset>(_onReset);
  }

  void _onDigitEntered(PinDigitEntered event, Emitter<PinState> emit) {
    if (event.isConfirmation) {
      if (state.confirmPin.length < 6) {
        emit(
          state.copyWith(
            confirmPin: state.confirmPin + event.digit,
            status: PinStatus.confirmingPin,
          ),
        );
      }
    } else {
      if (state.pin.length < 6) {
        final newPin = state.pin + event.digit;
        emit(
          state.copyWith(
            pin: newPin,
            status: newPin.length == 6
                ? PinStatus.confirmingPin
                : PinStatus.enteringPin,
          ),
        );
      }
    }
  }

  void _onDigitRemoved(PinDigitRemoved event, Emitter<PinState> emit) {
    if (event.isConfirmation) {
      if (state.confirmPin.isNotEmpty) {
        emit(
          state.copyWith(
            confirmPin: state.confirmPin.substring(
              0,
              state.confirmPin.length - 1,
            ),
          ),
        );
      }
    } else {
      if (state.pin.isNotEmpty) {
        emit(
          state.copyWith(
            pin: state.pin.substring(0, state.pin.length - 1),
            status: PinStatus.enteringPin,
          ),
        );
      }
    }
  }

  void _onSubmitted(PinSubmitted event, Emitter<PinState> emit) {
    if (state.pin == state.confirmPin) {
      emit(state.copyWith(status: PinStatus.success));
    } else {
      emit(
        state.copyWith(
          status: PinStatus.error,
          errorMessage: 'PIN tidak cocok',
          confirmPin: '',
        ),
      );
    }
  }

  void _onReset(PinReset event, Emitter<PinState> emit) {
    emit(const PinState());
  }
}
