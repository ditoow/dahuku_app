import 'package:flutter/material.dart';

class ChangePinPage extends StatelessWidget {
  const ChangePinPage({super.key});

  @override
  Widget build(BuildContext context) {
    final oldPinController = TextEditingController();
    final newPinController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text('Ganti PIN')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: oldPinController,
              decoration: const InputDecoration(labelText: 'PIN Lama'),
              obscureText: true,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: newPinController,
              decoration: const InputDecoration(labelText: 'PIN Baru'),
              obscureText: true,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Simpan PIN'),
            ),
          ],
        ),
      ),
    );
  }
}
