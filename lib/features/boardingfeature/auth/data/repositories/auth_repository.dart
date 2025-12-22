import '../../../../../core/data/repositories/base_repository.dart';
import '../models/auth_user_model.dart';
import '../services/auth_service.dart';

/// Repository untuk operasi autentikasi
class AuthRepository extends BaseRepository {
  final AuthService authService;

  AuthRepository({required this.authService});

  /// Sign up user baru
  Future<AuthUserModel> signUp({
    required String email,
    required String password,
    required String name,
  }) => authService.signUp(email: email, password: password, name: name);

  /// Sign in user
  Future<AuthUserModel> signIn({
    required String email,
    required String password,
  }) => authService.signIn(email: email, password: password);

  /// Sign out
  Future<void> signOut() => authService.signOut();

  /// Get current user (nullable)
  Future<AuthUserModel?> getCurrentUser() => authService.getCurrentUser();

  /// Update user profile
  Future<AuthUserModel> updateProfile({
    String? name,
    String? avatarUrl,
    String? phone,
  }) =>
      authService.updateProfile(name: name, avatarUrl: avatarUrl, phone: phone);

  /// Cek apakah sudah login
  @override
  bool get isAuthenticated => authService.isAuthenticated;

  /// Kirim email reset password
  Future<void> sendPasswordResetEmail(String email) =>
      authService.sendPasswordResetEmail(email);
}
