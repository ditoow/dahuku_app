import 'package:flutter/material.dart';

import '../pages/edit_profile_page.dart';
import '../pages/change_pin_page.dart';
import 'account_menu_card.dart';

/// Edit Profile menu item - self-contained with navigation
class EditProfileMenuItem extends StatelessWidget {
  const EditProfileMenuItem({super.key});

  @override
  Widget build(BuildContext context) {
    return AccountMenuCard(
      icon: Icons.person,
      title: 'Edit Profil',
      subtitle: 'Ubah nama dan info pribadi',
      iconColor: const Color(0xFF304AFF),
      iconBg: Colors.blue.shade50,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const EditProfilePage()),
        );
      },
    );
  }
}

/// Change PIN menu item - self-contained with navigation
class ChangePinMenuItem extends StatelessWidget {
  const ChangePinMenuItem({super.key});

  @override
  Widget build(BuildContext context) {
    return AccountMenuCard(
      icon: Icons.lock,
      title: 'Ganti PIN',
      subtitle: 'Keamanan akses aplikasi',
      iconColor: const Color(0xFF304AFF),
      iconBg: Colors.blue.shade50,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ChangePinPage()),
        );
      },
    );
  }
}

/// Backup Data menu item
class BackupDataMenuItem extends StatelessWidget {
  const BackupDataMenuItem({super.key});

  @override
  Widget build(BuildContext context) {
    return AccountMenuCard(
      icon: Icons.cloud_upload,
      title: 'Backup Data',
      subtitle: 'Simpan data ke cloud',
      iconColor: const Color(0xFFA788FD),
      iconBg: Colors.purple.shade50,
      onTap: () {
        // TODO: Implement backup
      },
    );
  }
}

/// Restore Data menu item
class RestoreDataMenuItem extends StatelessWidget {
  const RestoreDataMenuItem({super.key});

  @override
  Widget build(BuildContext context) {
    return AccountMenuCard(
      icon: Icons.cloud_download,
      title: 'Restore Data Lokal',
      subtitle: 'Pulihkan dari cadangan',
      iconColor: const Color(0xFFA788FD),
      iconBg: Colors.purple.shade50,
      onTap: () {
        // TODO: Implement restore
      },
    );
  }
}

/// Reset Data menu item
class ResetDataMenuItem extends StatelessWidget {
  const ResetDataMenuItem({super.key});

  @override
  Widget build(BuildContext context) {
    return AccountMenuCard(
      icon: Icons.delete_forever,
      title: 'Reset Data',
      subtitle: 'Hapus semua transaksi',
      iconColor: Colors.red,
      iconBg: Colors.red.shade50,
      onTap: () {
        // TODO: Implement reset with confirmation
      },
    );
  }
}
