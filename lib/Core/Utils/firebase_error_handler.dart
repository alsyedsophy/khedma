import 'package:firebase_auth/firebase_auth.dart';
import '../errors/failures.dart';

class FirebaseErrorHandler {
  FirebaseErrorHandler._();

  static Failure handle(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return const UserNotFoundFailure();
      case 'wrong-password':
        return const WrongPasswordFailure();
      case 'email-already-in-use':
        return const EmailAlreadyInUseFailure();
      case 'weak-password':
        return const WeakPasswordFailure();
      case 'invalid-email':
        return const AuthFailure('صيغة البريد الإلكتروني غير صحيحة');
      case 'user-disabled':
        return const AuthFailure('تم تعطيل هذا الحساب');
      case 'too-many-requests':
        return const AuthFailure('محاولات كثيرة، يرجى المحاولة لاحقاً');
      case 'network-request-failed':
        return const NetworkFailure();
      default:
        return UnKnowFailure();
    }
  }

  static Failure handleFirestoreError(Exception e) {
    if (e.toString().contains('network')) {
      return const NetworkFailure();
    }
    return const ServerFailure('حدث خطأ في قاعدة البيانات');
  }
}
