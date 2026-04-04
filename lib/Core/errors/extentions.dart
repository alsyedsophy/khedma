class ServerException implements Exception {
  final String message;
  ServerException({required this.message});
}

class NetworkException implements Exception {
  final String message;
  NetworkException({this.message = 'تحقق من الاتصال بالانترنت'});
}

class AuthException implements Exception {
  final String message;
  AuthException({required this.message});
}

class ValidationException implements Exception {
  final String message;
  ValidationException({required this.message});
}

class CacheException implements Exception {
  final String message;
  const CacheException(this.message);
}

class SubscriptionException implements Exception {
  final String message;
  const SubscriptionException([this.message = 'الاشتراك منتهي أو غير موجود']);
}

class UnKnowException implements Exception {
  final String message;
  UnKnowException({required this.message});
}
