import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../bloc/auth_bloc.dart';
import 'components/register_app_bar.dart';
import 'components/register_bottom_section.dart';
import 'components/register_form_fields.dart';
import 'components/register_header.dart';
import 'components/register_mesh_background.dart';

/// Register index page - clean composition of components
class RegisterIndexPage extends StatefulWidget {
  const RegisterIndexPage({super.key});

  @override
  State<RegisterIndexPage> createState() => _RegisterIndexPageState();
}

class _RegisterIndexPageState extends State<RegisterIndexPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc(),
      child: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state.status == AuthStatus.authenticated) {
            Navigator.pushReplacementNamed(context, '/pin');
          } else if (state.status == AuthStatus.error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage ?? 'Terjadi kesalahan'),
                backgroundColor: AppColors.error,
              ),
            );
          }
        },
        builder: (context, state) {
          return Scaffold(
            backgroundColor: AppColors.bgPage,
            body: Stack(
              children: [
                // Background
                const RegisterMeshBackground(),

                // Main content
                LayoutBuilder(
                  builder: (context, constraints) {
                    return SingleChildScrollView(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: constraints.maxHeight,
                        ),
                        child: IntrinsicHeight(
                          child: Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                SafeArea(
                                  child: Column(
                                    children: [
                                      // App Bar
                                      const RegisterAppBar(),

                                      // Content
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 24,
                                        ),
                                        child: Column(
                                          children: [
                                            const SizedBox(height: 8),

                                            // Header
                                            const RegisterHeader(),
                                            const SizedBox(height: 28),

                                            // Form Fields
                                            RegisterFormFields(
                                              nameController: _nameController,
                                              emailController: _emailController,
                                              passwordController:
                                                  _passwordController,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // Spacer
                                const Spacer(),

                                // Bottom Section
                                RegisterBottomSection(
                                  isLoading: state.status == AuthStatus.loading,
                                  onRegisterPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      context.read<AuthBloc>().add(
                                        AuthRegisterRequested(
                                          name: _nameController.text,
                                          email: _emailController.text,
                                          password: _passwordController.text,
                                        ),
                                      );
                                    }
                                  },
                                  onLoginPressed: () {
                                    Navigator.pushReplacementNamed(
                                      context,
                                      '/login',
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
