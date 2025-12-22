import '../../../../../core/data/repositories/base_repository.dart';
import '../models/questionnaire_model.dart';
import '../services/questionnaire_service.dart';

/// Repository untuk operasi kuesioner
class QuestionnaireRepository extends BaseRepository {
  final QuestionnaireService questionnaireService;

  QuestionnaireRepository({required this.questionnaireService});

  /// Simpan respon kuesioner
  Future<QuestionnaireModel> saveResponse({
    required double initialBelanja,
    required double initialTabungan,
    required double initialDarurat,
    bool hasDebt = false,
    double? debtAmount,
    String? debtType,
  }) {
    final model = QuestionnaireModel(
      initialBelanja: initialBelanja,
      initialTabungan: initialTabungan,
      initialDarurat: initialDarurat,
      hasDebt: hasDebt,
      debtAmount: debtAmount,
      debtType: debtType,
    );
    return questionnaireService.saveResponse(model);
  }

  /// Get respon kuesioner
  Future<QuestionnaireModel?> getResponse() =>
      questionnaireService.getResponse();

  /// Cek apakah sudah selesai
  Future<bool> hasCompleted() =>
      questionnaireService.hasCompletedQuestionnaire();
}
