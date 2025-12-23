import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import '../../../../../../core/constants/app_colors.dart';
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
  final _formKey = GlobalKey<FormState>();
  final _formFieldsKey = GlobalKey<RegisterFormFieldsState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetIt.I<AuthBloc>(),
      child: BlocListener<AuthBloc, AuthState>(
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
        child: Scaffold(
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

                                          // Form Fields - manages its own controllers
                                          RegisterFormFields(
                                            key: _formFieldsKey,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Spacer
                              const Spacer(),

                              // Bottom Section - gets state from BLoC
                              RegisterBottomSection(
                                formKey: _formKey,
                                getName: () =>
                                    _formFieldsKey.currentState?.name ?? '',
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
