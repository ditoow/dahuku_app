import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tentang Aplikasi')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'DahuKu',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('Versi Aplikasi 2.4.0'),
            SizedBox(height: 16),
            Text(
              'DahuKu adalah aplikasi pencatatan keuangan sederhana '
              'yang dirancang untuk membantu pengguna mengelola '
              'pemasukan dan pengeluaran secara mudah.',
            ),
          ],
        ),
      ),
    );
  }
}
