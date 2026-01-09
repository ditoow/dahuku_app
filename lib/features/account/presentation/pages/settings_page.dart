import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/account_bloc.dart';
import '../../bloc/account_event.dart';
import '../../bloc/account_state.dart';
import '../../bloc/offline_mode_cubit.dart';

import '../components/account_menu_card.dart';
import '../widgets/setting_toggle_tile.dart';
import '../widgets/font_size_selector.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: const Text(
          'Pengaturan',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
      ),

      body: BlocBuilder<AccountBloc, AccountState>(
        builder: (context, state) {
          if (state is! AccountLoaded) {
            return const Center(child: CircularProgressIndicator());
          }

          final settings = state.settings;

          return CustomScrollView(
            slivers: [
              /// ===== HEADER (BACKGROUND + ICON)
              SliverToBoxAdapter(
                child: Container(
                  padding: const EdgeInsets.fromLTRB(16, 24, 16, 32),
                  decoration: const BoxDecoration(
                    gradient: RadialGradient(
                      center: Alignment(1.2, -0.6),
                      radius: 1.2,
                      colors: [
                        Color(0xFFE0D4FC),
                        Color(0xFFF1EAFF),
                        Color(0xFFF8F9FE),
                      ],
                    ),
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(36),
                    ),
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: 96,
                        height: 96,
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withAlpha(13),
                              blurRadius: 20,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.tune,
                          size: 40,
                          color: Color(0xFF304AFF),
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Pengaturan Aplikasi',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Sesuaikan pengalaman aplikasi sesuai kebutuhan Anda',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),

              /// ===== CONTENT
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 40),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    const _SectionTitle('UMUM'),

                    BlocBuilder<OfflineModeCubit, bool>(
                      builder: (context, isOffline) {
                        return SettingToggleTile(
                          title: 'Mode Offline / Sync',
                          subtitle: isOffline
                              ? 'Mode Offline Aktif'
                              : 'Sinkronisasi data otomatis',
                          icon: isOffline ? Icons.cloud_off : Icons.cloud_sync,
                          iconColor: const Color(0xFF304AFF),
                          iconBg: Colors.blue.shade50,
                          value: isOffline,
                          onChanged: (val) {
                            context.read<OfflineModeCubit>().toggleOfflineMode(
                              val,
                            );
                          },
                        );
                      },
                    ),

                    const SizedBox(height: 12),

                    AccountMenuCard(
                      icon: Icons.notifications_outlined,
                      title: 'Notifikasi',
                      subtitle: 'Atur preferensi pemberitahuan',
                      iconColor: const Color(0xFF304AFF),
                      iconBg: Colors.blue.shade50,
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Pengaturan notifikasi belum tersedia',
                            ),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 12),

                    AccountMenuCard(
                      icon: Icons.language,
                      title: 'Bahasa',
                      subtitle: 'Indonesia (Default)',
                      iconColor: Colors.grey,
                      iconBg: Colors.grey.shade200,
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Fitur bahasa akan segera tersedia'),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 28),
                    const _SectionTitle('TAMPILAN'),

                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: _cardDecoration(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Ukuran Font',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 12),
                          FontSizeSelector(
                            currentSize: settings.fontSize,
                            onSelected: (size) {
                              context.read<AccountBloc>().add(
                                ChangeFontSize(size),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    SettingToggleTile(
                      title: 'Kontras Tinggi',
                      subtitle: 'Meningkatkan keterbacaan',
                      icon: Icons.contrast,
                      iconColor: const Color(0xFFA788FD),
                      iconBg: Colors.purple.shade50,
                      value: settings.highContrast,
                      onChanged: (val) {
                        context.read<AccountBloc>().add(
                          ToggleHighContrast(val),
                        );
                      },
                    ),

                    const SizedBox(height: 28),
                    const _SectionTitle('DUKUNGAN'),

                    AccountMenuCard(
                      icon: Icons.help_outline,
                      title: 'Bantuan',
                      subtitle: 'Pusat bantuan & FAQ',
                      iconColor: const Color(0xFF304AFF),
                      iconBg: Colors.blue.shade50,
                      onTap: () {},
                    ),
                    const SizedBox(height: 12),

                    AccountMenuCard(
                      icon: Icons.info_outline,
                      title: 'Tentang Aplikasi',
                      subtitle: 'Kebijakan privasi & lisensi',
                      iconColor: const Color(0xFFA788FD),
                      iconBg: Colors.purple.shade50,
                      onTap: () {},
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

/// ===== CARD DECORATION
BoxDecoration _cardDecoration() {
  return BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(20),
    border: Border.all(color: Colors.grey.shade100),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withAlpha(13),
        blurRadius: 20,
        offset: const Offset(0, 4),
      ),
    ],
  );
}
