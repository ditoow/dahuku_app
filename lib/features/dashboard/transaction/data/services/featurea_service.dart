import '../models/featurea_model.dart';

class FeatureAService {
  Future<List<FeatureATransaction>> fetchTransactions() async {
    await Future.delayed(const Duration(milliseconds: 500));

    return [
      FeatureATransaction(
        title: 'Makan Siang',
        subtitle: 'Hari Ini',
        amount: -45000,
        icon: '🍴',
      ),
      FeatureATransaction(
        title: 'Isi Bensin',
        subtitle: 'Kemarin',
        amount: -30000,
        icon: '⛽',
      ),
      FeatureATransaction(
        title: 'Minimarket',
        subtitle: '2 Hari lalu',
        amount: -125500,
        icon: '🛒',
      ),
    ];
  }
}
