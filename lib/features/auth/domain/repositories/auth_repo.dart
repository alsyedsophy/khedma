import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';
import 'package:khedma/core/constants/app_emums.dart';
import 'package:khedma/core/errors/failures.dart';
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

  Future<Either<Failure, UserEntity?>> getCachedUser();

  Future<Either<Failure, bool>> isFirstTime();

  Future<Either<Failure, void>> setFirstTimeDone();

  Future<Either<Failure, void>> setUserType(UserType userType);

  Future<Either<Failure, void>> setLocationSelected();

  Future<Either<Failure, void>> setLocationAdress(LocationEntity location);

  Future<Either<Failure, void>> setProfileCompleted();
}
