sealed class SignupState {
  const SignupState();
}

enum SignupStep { account, profile }

class SignupInitial extends SignupState {
  final SignupStep step;
  const SignupInitial({this.step = SignupStep.account});
}

class SignupLoading extends SignupState {}

class SignupSuccess extends SignupState {}

class SignupError extends SignupState {
  final String message;
  SignupError(this.message);
  @override
  String toString() => 'SignupError{message: $message}';
}
