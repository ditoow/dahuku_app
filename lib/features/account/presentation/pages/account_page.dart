import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/account_bloc.dart';
import '../../bloc/account_event.dart';
import '../../bloc/account_state.dart';
import '../../../boardingfeature/auth/bloc/auth_bloc.dart';

import '../components/profile_header.dart';
import '../components/account_menu_card.dart';
import '../widgets/logout_button.dart';

import 'settings_page.dart';
import 'edit_profile_page.dart';
import 'change_pin_page.dart';

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
              SliverToBoxAdapter(child: ProfileHeader(user: state.user)),

              /// ===== CONTENT
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 40),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    const _SectionTitle('AKUN & KEAMANAN'),
                    AccountMenuCard(
                      icon: Icons.person,
                      title: 'Edit Profil',
                      subtitle: 'Ubah nama dan info pribadi',
                      iconColor: const Color(0xFF304AFF),
                      iconBg: Colors.blue.shade50,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const EditProfilePage(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 12),
                    AccountMenuCard(
                      icon: Icons.lock,
                      title: 'Ganti PIN',
                      subtitle: 'Keamanan akses aplikasi',
                      iconColor: const Color(0xFF304AFF),
                      iconBg: Colors.blue.shade50,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ChangePinPage(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 28),
                    const _SectionTitle('DATA & PENYIMPANAN'),
                    AccountMenuCard(
                      icon: Icons.cloud_upload,
                      title: 'Backup Data',
                      subtitle: 'Simpan data ke cloud',
                      iconColor: const Color(0xFFA788FD),
                      iconBg: Colors.purple.shade50,
                      onTap: () {},
                    ),
                    const SizedBox(height: 12),
                    AccountMenuCard(
                      icon: Icons.cloud_download,
                      title: 'Restore Data Lokal',
                      subtitle: 'Pulihkan dari cadangan',
                      iconColor: const Color(0xFFA788FD),
                      iconBg: Colors.purple.shade50,
                      onTap: () {},
                    ),
                    const SizedBox(height: 12),
                    AccountMenuCard(
                      icon: Icons.delete_forever,
                      title: 'Reset Data',
                      subtitle: 'Hapus semua transaksi',
                      iconColor: Colors.red,
                      iconBg: Colors.red.shade50,
                      onTap: () {},
                    ),
                    const SizedBox(height: 32),
                    LogoutButton(
                      onTap: () {
                        _showLogoutConfirmation(context);
                      },
                    ),
                    const SizedBox(height: 24),
                    const Center(
                      child: Text(
                        'Versi Aplikasi 2.4.0',
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ),
                  ]),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Keluar Akun'),
        content: const Text('Apakah Anda yakin ingin keluar dari akun ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              context.read<AuthBloc>().add(AuthLogoutRequested());
            },
            child: const Text('Keluar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

/// ===== SECTION TITLE
class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.grey,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}
