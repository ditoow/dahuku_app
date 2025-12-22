/// Categories for expense transactions
enum ExpenseCategory {
  makanan,
  transportasi,
  rumah,
  anak,
  kesehatan,
  lainnya,
}

/// Income sources for income transactions
enum IncomeSource {
  gaji,
  usaha,
  bantuan,
  hadiah,
  lainnya,
}

/// Extension for expense category display
extension ExpenseCategoryExtension on ExpenseCategory {
  String get displayName {
    switch (this) {
      case ExpenseCategory.makanan:
        return 'Makanan';
      case ExpenseCategory.transportasi:
        return 'Transportasi';
      case ExpenseCategory.rumah:
        return 'Rumah';
      case ExpenseCategory.anak:
        return 'Anak';
      case ExpenseCategory.kesehatan:
        return 'Kesehatan';
      case ExpenseCategory.lainnya:
        return 'Lainnya';
    }
  }

  String get iconName {
    switch (this) {
      case ExpenseCategory.makanan:
        return 'restaurant';
      case ExpenseCategory.transportasi:
        return 'directions_car';
      case ExpenseCategory.rumah:
        return 'home';
      case ExpenseCategory.anak:
        return 'child_care';
      case ExpenseCategory.kesehatan:
        return 'local_hospital';
      case ExpenseCategory.lainnya:
        return 'grid_view';
    }
  }
}

/// Extension for income source display
extension IncomeSourceExtension on IncomeSource {
  String get displayName {
    switch (this) {
      case IncomeSource.gaji:
        return 'Gaji';
      case IncomeSource.usaha:
        return 'Usaha';
      case IncomeSource.bantuan:
        return 'Bantuan';
      case IncomeSource.hadiah:
        return 'Hadiah';
      case IncomeSource.lainnya:
        return 'Lainnya';
    }
  }

  String get iconName {
    switch (this) {
      case IncomeSource.gaji:
        return 'attach_money';
      case IncomeSource.usaha:
        return 'business';
      case IncomeSource.bantuan:
        return 'volunteer_activism';
      case IncomeSource.hadiah:
        return 'card_giftcard';
      case IncomeSource.lainnya:
        return 'grid_view';
    }
  }
}

/// Wallet model for transaction source/destination
class WalletData {
  final String id;
  final String name;
  final double balance;
  final String type;

  const WalletData({
    required this.id,
    required this.name,
    required this.balance,
    required this.type,
  });

  /// Default wallet for demo
  static const WalletData defaultWallet = WalletData(
    id: 'belanja',
    name: 'Belanja',
    balance: 2150000,
    type: 'shopping',
  );
}
