import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'onboarding_event.dart';
part 'onboarding_state.dart';

class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  OnboardingBloc() : super(const OnboardingState()) {
    on<OnboardingPageChanged>(_onPageChanged);
    on<OnboardingNextPressed>(_onNextPressed);
    on<OnboardingSkipPressed>(_onSkipPressed);
    on<OnboardingCompleted>(_onCompleted);
  }

  void _onPageChanged(
    OnboardingPageChanged event,
    Emitter<OnboardingState> emit,
  ) {
    emit(state.copyWith(currentPage: event.pageIndex));
  }

  void _onNextPressed(
    OnboardingNextPressed event,
    Emitter<OnboardingState> emit,
  ) {
    if (state.isLastPage) {
      emit(state.copyWith(isCompleted: true));
    } else {
      emit(state.copyWith(currentPage: state.currentPage + 1));
    }
  }

  void _onSkipPressed(
    OnboardingSkipPressed event,
    Emitter<OnboardingState> emit,
  ) {
    emit(state.copyWith(isCompleted: true));
  }

  void _onCompleted(OnboardingCompleted event, Emitter<OnboardingState> emit) {
    emit(state.copyWith(isCompleted: true));
  }
}
