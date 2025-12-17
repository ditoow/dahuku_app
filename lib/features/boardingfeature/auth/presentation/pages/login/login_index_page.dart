import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../bloc/auth_bloc.dart';
import 'components/login_app_bar.dart';
import 'components/login_bottom_section.dart';
import 'components/login_form_fields.dart';
import 'components/login_header.dart';
import 'components/login_mesh_background.dart';

/// Login index page - clean composition of components
class LoginIndexPage extends StatefulWidget {
  const LoginIndexPage({super.key});

  @override
  State<LoginIndexPage> createState() => _LoginIndexPageState();
}

class _LoginIndexPageState extends State<LoginIndexPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
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
                const LoginMeshBackground(),

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
                                      const LoginAppBar(),

                                      // Content
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 24,
                                        ),
                                        child: Column(
                                          children: [
                                            const SizedBox(height: 16),

                                            // Header
                                            const LoginHeader(),
                                            const SizedBox(height: 32),

                                            // Form Fields
                                            LoginFormFields(
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
                                LoginBottomSection(
                                  isLoading: state.status == AuthStatus.loading,
                                  onLoginPressed: () {
                                    // if (_formKey.currentState!.validate()) {
                                    //   context.read<AuthBloc>().add(
                                    //     AuthLoginRequested(
                                    //       email: _emailController.text,
                                    //       password: _passwordController.text,
                                    //     ),
                                    //   );
                                    // }
                                    Navigator.pushReplacementNamed(
                                      context,
                                      '/pin',
                                    );
                                  },
                                  onRegisterPressed: () {
                                    Navigator.pushReplacementNamed(
                                      context,
                                      '/register',
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
