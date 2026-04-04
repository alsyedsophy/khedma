abstract class VerifyEmailState {}

class VerifyEmailInitial extends VerifyEmailState {}

class VerifyEmailCounting extends VerifyEmailState {
  final int secondsLeft;

  VerifyEmailCounting(this.secondsLeft);
}

class VerifyEmailFinished extends VerifyEmailState {}
