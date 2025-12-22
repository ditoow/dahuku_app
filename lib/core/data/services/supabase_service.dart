import 'package:supabase_flutter/supabase_flutter.dart';

/// Supabase service wrapper for easy access throughout the app
class SupabaseService {
  static SupabaseClient get client => Supabase.instance.client;

  /// Get current authenticated user
  static User? get currentUser => client.auth.currentUser;

  /// Get current user ID
  static String? get currentUserId => currentUser?.id;

  /// Check if user is authenticated
  static bool get isAuthenticated => currentUser != null;

  /// Auth state changes stream
  static Stream<AuthState> get authStateChanges =>
      client.auth.onAuthStateChange;

  /// Initialize Supabase - call this in main.dart
  static Future<void> initialize({
    required String url,
    required String anonKey,
  }) async {
    await Supabase.initialize(
      url: url,
      anonKey: anonKey,
      authOptions: const FlutterAuthClientOptions(
        authFlowType: AuthFlowType.pkce,
      ),
    );
  }
}
