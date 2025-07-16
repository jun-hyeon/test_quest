sealed class AuthState {}

class AuthLoading extends AuthState {}

class Authenticated extends AuthState {
  Authenticated();
}

class Unauthenticated extends AuthState {
  final String? errorMessage;
  Unauthenticated({this.errorMessage});

  @override
  String toString() => 'Unauthenticated{errorMessage: $errorMessage}';
}

class AuthFormInvalid extends AuthState {
  final String? emailError;
  final String? passwordError;
  AuthFormInvalid(this.emailError, this.passwordError);

  @override
  String toString() =>
      'AuthFormInvalid{emailError: $emailError, passwordError: $passwordError}';
}
