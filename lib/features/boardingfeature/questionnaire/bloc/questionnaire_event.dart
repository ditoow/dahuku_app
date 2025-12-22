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

class QuestionnaireSubmitted extends QuestionnaireEvent {
  final double initialBelanja;
  final double initialTabungan;
  final double initialDarurat;
  final bool hasDebt;
  final double? debtAmount;
  final String? debtType;

  const QuestionnaireSubmitted({
    required this.initialBelanja,
    required this.initialTabungan,
    required this.initialDarurat,
    this.hasDebt = false,
    this.debtAmount,
    this.debtType,
  });

  @override
  List<Object> get props => [
    initialBelanja,
    initialTabungan,
    initialDarurat,
    hasDebt,
    debtAmount ?? 0,
    debtType ?? '',
  ];
}
