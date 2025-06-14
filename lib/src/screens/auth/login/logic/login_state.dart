abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final dynamic data;
  AuthSuccess(this.data);
}

class AuthError extends AuthState {
  final String message;
  AuthError(this.message);
}

class EmailVerificationRequired extends AuthState {
  final String email;
  EmailVerificationRequired(this.email);
}
