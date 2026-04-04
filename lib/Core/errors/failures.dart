import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  const Failure(this.message);
  @override
  List<Object> get props => [message];
}

class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'تحقق من الاتصال بالانترنت']);
}

class AuthFailure extends Failure {
  const AuthFailure(super.message);
}

class UserNotFoundFailure extends Failure {
  const UserNotFoundFailure([super.message = 'المستخدم غير موجود']);
}

class WrongPasswordFailure extends Failure {
  const WrongPasswordFailure([super.message = 'كلمة المرور غير صحيحه']);
}

class EmailAlreadyInUseFailure extends Failure {
  const EmailAlreadyInUseFailure([
    super.message = 'البريد الاكترونى مسجل بالفعل',
  ]);
}

class WeakPasswordFailure extends Failure {
  const WeakPasswordFailure([super.message = 'كلمة المرور ضعيفه']);
}

class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}

class CacheFailure extends Failure {
  const CacheFailure(super.message);
}

class PermissionFailure extends Failure {
  const PermissionFailure([super.message = 'لا يوجد صلاحية للوصول']);
}

class SubscriptionFailure extends Failure {
  const SubscriptionFailure([super.message = 'الاشتراك منتهي أو غير موجود']);
}

class UnKnowFailure extends Failure {
  const UnKnowFailure([super.message = 'خطأ غير معروف']);
}
