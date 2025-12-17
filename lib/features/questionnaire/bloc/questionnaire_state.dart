part of 'questionnaire_bloc.dart';

enum QuestionnaireStatus { initial, inProgress, completed, error }

class QuestionnaireState extends Equatable {
  final int currentQuestionIndex;
  final Map<int, int> answers;
  final QuestionnaireStatus status;
  final String? errorMessage;

  const QuestionnaireState({
    this.currentQuestionIndex = 0,
    this.answers = const {},
    this.status = QuestionnaireStatus.initial,
    this.errorMessage,
  });

  bool get isFirstQuestion => currentQuestionIndex == 0;
  bool get isLastQuestion => currentQuestionIndex == 2; // 3 questions total
  bool get hasCurrentAnswer => answers.containsKey(currentQuestionIndex);

  QuestionnaireState copyWith({
    int? currentQuestionIndex,
    Map<int, int>? answers,
    QuestionnaireStatus? status,
    String? errorMessage,
  }) {
    return QuestionnaireState(
      currentQuestionIndex: currentQuestionIndex ?? this.currentQuestionIndex,
      answers: answers ?? this.answers,
      status: status ?? this.status,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    currentQuestionIndex,
    answers,
    status,
    errorMessage,
  ];
}
