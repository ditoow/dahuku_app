part of 'pin_bloc.dart';

enum PinStatus { initial, enteringPin, confirmingPin, success, error }

class PinState extends Equatable {
  final String pin;
  final String confirmPin;
  final PinStatus status;
  final String? errorMessage;

  const PinState({
    this.pin = '',
    this.confirmPin = '',
    this.status = PinStatus.initial,
    this.errorMessage,
  });

  bool get isPinComplete => pin.length == 6;
  bool get isConfirmPinComplete => confirmPin.length == 6;

  PinState copyWith({
    String? pin,
    String? confirmPin,
    PinStatus? status,
    String? errorMessage,
  }) {
    return PinState(
      pin: pin ?? this.pin,
      confirmPin: confirmPin ?? this.confirmPin,
      status: status ?? this.status,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [pin, confirmPin, status, errorMessage];
}
