import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'app.dart';
import 'core/di/injection_container.dart';
import 'core/local_storage/hive_setup.dart';
import 'core/services/sync_service.dart';
import 'package:get_it/get_it.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  await dotenv.load(fileName: ".env");

  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );

  // Initialize Hive
  await HiveSetup.init();

  // Initialize Dependency Injection
  await initializeDependencies();

  // Trigger Background Sync (Fire and Forget)
  GetIt.I<SyncService>().syncAllData();

  runApp(const DahuKuApp());
}
