import '../models/featurea_model.dart';
import '../services/featurea_service.dart';

class FeatureARepository {
  final FeatureAService service;

  FeatureARepository(this.service);

  Future<List<FeatureATransaction>> getTransactions() {
    return service.fetchTransactions();
  }
}
