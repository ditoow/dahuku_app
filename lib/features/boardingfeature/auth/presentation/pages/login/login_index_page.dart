import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
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
  final _formKey = GlobalKey<FormState>();
  final _formFieldsKey = GlobalKey<LoginFormFieldsState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetIt.I<AuthBloc>(),
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state.status == AuthStatus.authenticated) {
            Navigator.pushReplacementNamed(context, '/dashboard');
          } else if (state.status == AuthStatus.error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage ?? 'Terjadi kesalahan'),
                backgroundColor: AppColors.error,
              ),
            );
          }
        },
        child: Scaffold(
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

                                          // Form Fields - manages its own controllers
                                          LoginFormFields(key: _formFieldsKey),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Spacer
                              const Spacer(),

                              // Bottom Section - gets state from BLoC
                              LoginBottomSection(
                                formKey: _formKey,
                                getEmail: () =>
                                    _formFieldsKey.currentState?.email ?? '',
                                getPassword: () =>
                                    _formFieldsKey.currentState?.password ?? '',
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
        ),
      ),
    );
  }
}
