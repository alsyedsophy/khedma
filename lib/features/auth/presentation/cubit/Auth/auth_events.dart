sealed class AuthEvents {}

class AuthSuccessEvent extends AuthEvents {
  final String message;
  AuthSuccessEvent(this.message);
}

class AuthErrorEvent extends AuthEvents {
  final String message;
  AuthErrorEvent(this.message);
}
