part of 'questionnaire_bloc.dart';

enum QuestionnaireStatus { initial, loading, inProgress, completed, error }

class QuestionnaireState extends Equatable {
  final int currentQuestionIndex;
  final Map<int, int> answers;
  final QuestionnaireStatus status;
  final String? errorMessage;

  // Wallet balances - persist across steps
  final double walletBelanja;
  final double walletTabungan;
  final double walletDarurat;

  const QuestionnaireState({
    this.currentQuestionIndex = 0,
    this.answers = const {},
    this.status = QuestionnaireStatus.initial,
    this.errorMessage,
    this.walletBelanja = 0,
    this.walletTabungan = 0,
    this.walletDarurat = 0,
  });

  bool get isFirstQuestion => currentQuestionIndex == 0;
  bool get isLastQuestion => currentQuestionIndex == 2; // 3 questions total
  bool get hasCurrentAnswer => answers.containsKey(currentQuestionIndex);

  QuestionnaireState copyWith({
    int? currentQuestionIndex,
    Map<int, int>? answers,
    QuestionnaireStatus? status,
    String? errorMessage,
    double? walletBelanja,
    double? walletTabungan,
    double? walletDarurat,
  }) {
    return QuestionnaireState(
      currentQuestionIndex: currentQuestionIndex ?? this.currentQuestionIndex,
      answers: answers ?? this.answers,
      status: status ?? this.status,
      errorMessage: errorMessage,
      walletBelanja: walletBelanja ?? this.walletBelanja,
      walletTabungan: walletTabungan ?? this.walletTabungan,
      walletDarurat: walletDarurat ?? this.walletDarurat,
    );
  }

  @override
  List<Object?> get props => [
    currentQuestionIndex,
    answers,
    status,
    errorMessage,
    walletBelanja,
    walletTabungan,
    walletDarurat,
  ];
}
