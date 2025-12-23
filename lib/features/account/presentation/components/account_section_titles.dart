import 'package:flutter/material.dart';

/// Account section title - "AKUN & KEAMANAN"
class AccountSecurityTitle extends StatelessWidget {
  const AccountSecurityTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        'AKUN & KEAMANAN',
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.grey,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}

/// Data section title - "DATA & PENYIMPANAN"
class DataStorageTitle extends StatelessWidget {
  const DataStorageTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        'DATA & PENYIMPANAN',
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.grey,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}
