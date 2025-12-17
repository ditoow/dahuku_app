import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'questionnaire_event.dart';
part 'questionnaire_state.dart';

class QuestionnaireBloc extends Bloc<QuestionnaireEvent, QuestionnaireState> {
  QuestionnaireBloc() : super(const QuestionnaireState()) {
    on<QuestionnaireAnswerSelected>(_onAnswerSelected);
    on<QuestionnaireNextPressed>(_onNextPressed);
    on<QuestionnairePreviousPressed>(_onPreviousPressed);
    on<QuestionnaireSubmitted>(_onSubmitted);
  }

  void _onAnswerSelected(
    QuestionnaireAnswerSelected event,
    Emitter<QuestionnaireState> emit,
  ) {
    final newAnswers = Map<int, int>.from(state.answers);
    newAnswers[event.questionIndex] = event.answerIndex;
    emit(
      state.copyWith(
        answers: newAnswers,
        status: QuestionnaireStatus.inProgress,
      ),
    );
  }

  void _onNextPressed(
    QuestionnaireNextPressed event,
    Emitter<QuestionnaireState> emit,
  ) {
    if (!state.isLastQuestion) {
      emit(
        state.copyWith(currentQuestionIndex: state.currentQuestionIndex + 1),
      );
    }
  }

  void _onPreviousPressed(
    QuestionnairePreviousPressed event,
    Emitter<QuestionnaireState> emit,
  ) {
    if (!state.isFirstQuestion) {
      emit(
        state.copyWith(currentQuestionIndex: state.currentQuestionIndex - 1),
      );
    }
  }

  void _onSubmitted(
    QuestionnaireSubmitted event,
    Emitter<QuestionnaireState> emit,
  ) {
    // Save answers and mark as completed
    emit(state.copyWith(status: QuestionnaireStatus.completed));
  }
}
