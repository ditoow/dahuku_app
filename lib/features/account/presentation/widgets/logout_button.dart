import 'package:flutter/material.dart';

class LogoutButton extends StatelessWidget {
  final VoidCallback onTap;

  const LogoutButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      icon: const Icon(Icons.logout, color: Colors.red),
      label: const Text('Keluar Akun', style: TextStyle(color: Colors.red)),
      onPressed: onTap,
    );
  }
}
