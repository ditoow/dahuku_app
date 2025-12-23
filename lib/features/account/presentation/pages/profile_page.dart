import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/account_bloc.dart';
import '../../bloc/account_state.dart';
import '../components/profile_header.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profil Pengguna')),
      body: BlocBuilder<AccountBloc, AccountState>(
        builder: (context, state) {
          if (state is AccountLoaded) {
            return Center(child: ProfileHeader());
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
