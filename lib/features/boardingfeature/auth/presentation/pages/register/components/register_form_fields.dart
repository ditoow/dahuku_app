import 'package:flutter/material.dart';
import '../../../widgets/auth_text_field.dart';

/// Form fields for register page - manages its own controllers
class RegisterFormFields extends StatefulWidget {
  const RegisterFormFields({super.key});

  @override
  State<RegisterFormFields> createState() => RegisterFormFieldsState();
}

class RegisterFormFieldsState extends State<RegisterFormFields> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  /// Getters for parent access via GlobalKey
  String get name => _nameController.text;
  String get email => _emailController.text;
  String get password => _passwordController.text;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Name field
        AuthTextField(
          label: 'Nama Lengkap',
          hint: 'Cth: Budi Santoso',
          prefixIcon: Icons.person_outline,
          controller: _nameController,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Nama tidak boleh kosong';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),

        // Email field
        AuthTextField(
          label: 'Email',
          hint: 'Cth: budi@email.com',
          prefixIcon: Icons.mail_outline,
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Email tidak boleh kosong';
            }
            // Validasi format email
            final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
            if (!emailRegex.hasMatch(value)) {
              return 'Format email tidak valid';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),

        // Password field
        AuthTextField(
          label: 'Kata Sandi',
          hint: 'Minimal 8 karakter',
          prefixIcon: Icons.lock_outline,
          isPassword: true,
          controller: _passwordController,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Kata sandi tidak boleh kosong';
            }
            if (value.length < 8) {
              return 'Kata sandi minimal 8 karakter';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
