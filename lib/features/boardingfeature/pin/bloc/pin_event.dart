part of 'pin_bloc.dart';

abstract class PinEvent extends Equatable {
  const PinEvent();

  @override
  List<Object> get props => [];
}

class PinDigitEntered extends PinEvent {
  final String digit;
  final bool isConfirmation;

  const PinDigitEntered({required this.digit, this.isConfirmation = false});

  @override
  List<Object> get props => [digit, isConfirmation];
}

class PinDigitRemoved extends PinEvent {
  final bool isConfirmation;

  const PinDigitRemoved({this.isConfirmation = false});

  @override
  List<Object> get props => [isConfirmation];
}

class PinSubmitted extends PinEvent {}

class PinReset extends PinEvent {}
