part of 'questionnaire_bloc.dart';

abstract class QuestionnaireEvent extends Equatable {
  const QuestionnaireEvent();

  @override
  List<Object> get props => [];
}

class QuestionnaireAnswerSelected extends QuestionnaireEvent {
  final int questionIndex;
  final int answerIndex;

  const QuestionnaireAnswerSelected({
    required this.questionIndex,
    required this.answerIndex,
  });

  @override
  List<Object> get props => [questionIndex, answerIndex];
}

class QuestionnaireNextPressed extends QuestionnaireEvent {}

class QuestionnairePreviousPressed extends QuestionnaireEvent {}

class QuestionnaireSubmitted extends QuestionnaireEvent {}
