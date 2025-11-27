sealed class SignupState {
  const SignupState();
}

class SignupInitial extends SignupState {
  const SignupInitial();
}

class SignupLoading extends SignupState {
  final String message;
  final int step;
  final int totalSteps;

  const SignupLoading({
    required this.message,
    required this.step,
    this.totalSteps = 6,
  });

  double get progress => step / totalSteps;
}

class SignupSuccess extends SignupState {
  const SignupSuccess();
}

class SignupError extends SignupState {
  final String message;
  final StackTrace? stackTrace;

  const SignupError(this.message, [this.stackTrace]);

  @override
  String toString() => 'SignupError{message: $message}';
}
