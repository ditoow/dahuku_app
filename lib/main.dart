import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'app.dart';
import 'core/di/injection_container.dart';
import 'core/local_storage/hive_setup.dart';
import 'core/services/sync_service.dart';
import 'package:get_it/get_it.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://qhtumpwsagfqtspvorhh.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InFodHVtcHdzYWdmcXRzcHZvcmhoIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjIwMTczMjgsImV4cCI6MjA3NzU5MzMyOH0.EBUL89n3e3LjK7GPANccU9c1u8L3ys_4yIsj_zFNk08',
  );

  // Initialize Hive
  await HiveSetup.init();

  // Initialize Dependency Injection
  await initializeDependencies();

  // Trigger Background Sync (Fire and Forget)
  GetIt.I<SyncService>().syncAllData();

  runApp(const DahuKuApp());
}
