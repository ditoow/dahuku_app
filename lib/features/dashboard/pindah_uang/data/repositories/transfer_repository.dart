import '../services/transfer_service.dart';

/// Repository untuk transfer uang - abstraksi dari service
class TransferRepository {
  final TransferService _service;

  TransferRepository(this._service);

  /// Transfer uang dengan validasi
  Future<String> transfer({
    required String idDompetSumber,
    required String idDompetTujuan,
    required double jumlah,
    String? deskripsi,
  }) async {
    // Validasi jumlah
    if (jumlah <= 0) {
      throw Exception('Jumlah harus lebih dari 0');
    }

    // Validasi dompet berbeda
    if (idDompetSumber == idDompetTujuan) {
      throw Exception('Dompet sumber dan tujuan harus berbeda');
    }

    return await _service.transferUang(
      idDompetSumber: idDompetSumber,
      idDompetTujuan: idDompetTujuan,
      jumlah: jumlah,
      deskripsi: deskripsi,
    );
  }

  /// Ambil dompet berdasarkan tipe
  Future<Map<String, dynamic>?> getDompetByTipe(String tipe) {
    return _service.getDompetByTipe(tipe);
  }

  /// Ambil semua dompet
  Future<List<Map<String, dynamic>>> getAllDompet() {
    return _service.getAllDompet();
  }
}
