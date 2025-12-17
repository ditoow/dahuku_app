part of 'auth_bloc.dart';

enum AuthStatus { initial, loading, authenticated, unauthenticated, error }

class AuthState extends Equatable {
  final AuthStatus status;
  final String? errorMessage;
  final String? userId;

  const AuthState({
    this.status = AuthStatus.initial,
    this.errorMessage,
    this.userId,
  });

  AuthState copyWith({
    AuthStatus? status,
    String? errorMessage,
    String? userId,
  }) {
    return AuthState(
      status: status ?? this.status,
      errorMessage: errorMessage,
      userId: userId ?? this.userId,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage, userId];
}
