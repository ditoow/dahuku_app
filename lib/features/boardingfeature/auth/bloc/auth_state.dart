part of 'auth_bloc.dart';

enum AuthStatus { initial, loading, authenticated, unauthenticated, error }

class AuthState extends Equatable {
  final AuthStatus status;
  final String? errorMessage;
  final String? userId;
  final AuthUserModel? user;

  const AuthState({
    this.status = AuthStatus.initial,
    this.errorMessage,
    this.userId,
    this.user,
  });

  /// Check if user is authenticated
  bool get isAuthenticated => status == AuthStatus.authenticated;

  /// Get user name
  String get userName => user?.name ?? 'User';

  /// Get user email
  String get userEmail => user?.email ?? '';

  AuthState copyWith({
    AuthStatus? status,
    String? errorMessage,
    String? userId,
    AuthUserModel? user,
  }) {
    return AuthState(
      status: status ?? this.status,
      errorMessage: errorMessage,
      userId: userId ?? this.userId,
      user: user ?? this.user,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage, userId, user];
}
