import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';
import 'package:khedma/Core/constants/app_emums.dart';
import 'package:khedma/Core/errors/failures.dart';
import 'package:khedma/features/auth/domain/entities/user_entity.dart';

// واجهة المستودع (Repository) للمصادقة
abstract class AuthRepo {
  Future<Either<Failure, UserEntity>> loginWithEmail(
    UserType userType,
    String email,
    String password,
  );

  Future<Either<Failure, UserEntity>> registerWithEmail(
    UserType userType,
    String email,
    String password,
  );

  Future<Either<Failure, UserEntity>> loginWithGoogle(UserType userType);

  Future<Either<Failure, UserEntity>> loginWithFacebook(UserType userType);

  Future<Either<Failure, void>> sendEmailVerification();

  Future<Either<Failure, bool>> checkEmailVerified();

  Future<Either<Failure, void>> sendPasswordResetEmail(String email);

  Future<Either<Failure, void>> logout();

  Future<Either<Failure, void>> updateUserProfile({
    String? name,
    String? phone,
    LocationEntity? location,
    XFile? image,
  });

  // الحصول على المستخدم المخزن محلياً
  Future<Either<Failure, UserEntity?>> getCachedUser();
  // التحقق مما إذا كانت هذه أول مرة للمستخدم
  Future<Either<Failure, bool>> isFirstTime();

  // تعيين أن المستخدم تجاوز شاشة الترحيب
  Future<Either<Failure, void>> setFirstTimeDone();

  // تعيين نوع المستخدم (service أو provider)
  Future<Either<Failure, void>> setUserType(UserType userType);

  // تعيين أن المستخدم اختار موقعه
  Future<Either<Failure, void>> setLocationSelected();

  Future<Either<Failure, void>> setLocationAdress(LocationEntity location);

  // تعيين أن المستخدم أكمل ملفه الشخصي
  Future<Either<Failure, void>> setProfileCompleted();
}
