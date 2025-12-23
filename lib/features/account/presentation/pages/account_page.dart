import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/account_bloc.dart';
import '../../bloc/account_event.dart';
import '../../bloc/account_state.dart';

import '../components/profile_header.dart';
import '../components/account_section_titles.dart';
import '../components/account_menu_items.dart';
import '../components/logout_section.dart';
import 'settings_page.dart';

/// Account page - refactored to use const Column pattern
class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  @override
  void initState() {
    super.initState();
    context.read<AccountBloc>().add(LoadAccount());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: const Text(
          'Profil Pengguna',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.black87),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingsPage()),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<AccountBloc, AccountState>(
        builder: (context, state) {
          if (state is! AccountLoaded) {
            return const Center(child: CircularProgressIndicator());
          }

          return CustomScrollView(
            slivers: [
              /// ===== HEADER PROFIL (SCROLLABLE)
              const SliverToBoxAdapter(child: ProfileHeader()),

              /// ===== CONTENT
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 40),
                sliver: SliverList(
                  delegate: SliverChildListDelegate(const [
                    AccountSecurityTitle(),
                    EditProfileMenuItem(),
                    SizedBox(height: 12),
                    ChangePinMenuItem(),
                    SizedBox(height: 28),
                    DataStorageTitle(),
                    BackupDataMenuItem(),
                    SizedBox(height: 12),
                    RestoreDataMenuItem(),
                    SizedBox(height: 12),
                    ResetDataMenuItem(),
                    SizedBox(height: 32),
                    LogoutSection(),
                    SizedBox(height: 24),
                    AppVersionText(),
                  ]),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
