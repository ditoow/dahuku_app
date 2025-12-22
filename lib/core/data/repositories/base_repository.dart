import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/supabase_service.dart';

/// Base repository with common Supabase operations
abstract class BaseRepository {
  /// Get Supabase client
  SupabaseClient get client => SupabaseService.client;

  /// Get current user ID or throw if not authenticated
  String get userId {
    final id = SupabaseService.currentUserId;
    if (id == null) {
      throw Exception('User not authenticated');
    }
    return id;
  }

  /// Check if user is authenticated
  bool get isAuthenticated => SupabaseService.isAuthenticated;
}
