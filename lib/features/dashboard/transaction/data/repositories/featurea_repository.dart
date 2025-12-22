import '../services/featurea_service.dart';

class FeatureaRepository {
  final FeatureaService service;

  FeatureaRepository(this.service);

  Future<void> save() async {
    await service.saveTransaction();
  }
}
