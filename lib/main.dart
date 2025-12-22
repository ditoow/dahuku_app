import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'app.dart';
import 'core/di/injection_container.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // TODO: Ganti dengan Supabase URL dan Anon Key kamu
  // Dapatkan dari: Supabase Dashboard > Project Settings > API
  await Supabase.initialize(
    url: 'https://qhtumpwsagfqtspvorhh.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InFodHVtcHdzYWdmcXRzcHZvcmhoIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjIwMTczMjgsImV4cCI6MjA3NzU5MzMyOH0.EBUL89n3e3LjK7GPANccU9c1u8L3ys_4yIsj_zFNk08',
  );

  // Initialize Dependency Injection
  await initializeDependencies();

  runApp(const DahuKuApp());
}
