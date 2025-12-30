import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/repositories/questionnaire_repository.dart';

part 'questionnaire_event.dart';
part 'questionnaire_state.dart';

class QuestionnaireBloc extends Bloc<QuestionnaireEvent, QuestionnaireState> {
  final QuestionnaireRepository repository;

  QuestionnaireBloc({required this.repository})
    : super(const QuestionnaireState()) {
    on<QuestionnaireAnswerSelected>(_onAnswerSelected);
    on<QuestionnaireNextPressed>(_onNextPressed);
    on<QuestionnairePreviousPressed>(_onPreviousPressed);
    on<QuestionnaireWalletBalancesUpdated>(_onWalletBalancesUpdated);
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

  void _onWalletBalancesUpdated(
    QuestionnaireWalletBalancesUpdated event,
    Emitter<QuestionnaireState> emit,
  ) {
    print(
      'QUESTIONNAIRE_DEBUG: Wallet balances updated - belanja: ${event.belanja}, tabungan: ${event.tabungan}, darurat: ${event.darurat}',
    );
    emit(
      state.copyWith(
        walletBelanja: event.belanja,
        walletTabungan: event.tabungan,
        walletDarurat: event.darurat,
      ),
    );
  }

  Future<void> _onSubmitted(
    QuestionnaireSubmitted event,
    Emitter<QuestionnaireState> emit,
  ) async {
    emit(state.copyWith(status: QuestionnaireStatus.loading));

    // Use wallet values from state (persisted from step 2)
    final walletBelanja = state.walletBelanja;
    final walletTabungan = state.walletTabungan;
    final walletDarurat = state.walletDarurat;

    print(
      'QUESTIONNAIRE_DEBUG: Submitting with wallet values - belanja: $walletBelanja, tabungan: $walletTabungan, darurat: $walletDarurat',
    );

    try {
      await repository.saveResponse(
        initialBelanja: walletBelanja,
        initialTabungan: walletTabungan,
        initialDarurat: walletDarurat,
        hasDebt: event.hasDebt,
        debtAmount: event.debtAmount,
        debtType: event.debtType,
      );
      emit(state.copyWith(status: QuestionnaireStatus.completed));
    } catch (e) {
      print('QUESTIONNAIRE_DEBUG: Submit failed: $e');
      // In a real app we would handle error state
      emit(state.copyWith(status: QuestionnaireStatus.completed));
    }
  }
}
