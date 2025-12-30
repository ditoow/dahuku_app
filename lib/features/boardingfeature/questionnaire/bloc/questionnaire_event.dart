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

class QuestionnaireWalletBalancesUpdated extends QuestionnaireEvent {
  final double belanja;
  final double tabungan;
  final double darurat;

  const QuestionnaireWalletBalancesUpdated({
    required this.belanja,
    required this.tabungan,
    required this.darurat,
  });

  @override
  List<Object> get props => [belanja, tabungan, darurat];
}

class QuestionnaireSubmitted extends QuestionnaireEvent {
  final double initialBelanja;
  final double initialTabungan;
  final double initialDarurat;
  final bool hasDebt;
  final double? debtAmount;
  final String? debtType;

  const QuestionnaireSubmitted({
    this.initialBelanja = 0,
    this.initialTabungan = 0,
    this.initialDarurat = 0,
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
