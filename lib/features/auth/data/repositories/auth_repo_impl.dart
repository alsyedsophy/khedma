import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';
import 'package:khedma/Core/constants/app_emums.dart';
import 'package:khedma/Core/errors/extentions.dart';
import 'package:khedma/Core/errors/failures.dart';
import 'package:khedma/Core/network/network_info.dart';
import 'package:khedma/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:khedma/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:khedma/features/auth/data/models/user_model.dart';
import 'package:khedma/features/auth/domain/entities/user_entity.dart';
import 'package:khedma/features/auth/domain/repositories/auth_repo.dart';

class AuthRepositoryImpl implements AuthRepo {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, UserEntity>> loginWithEmail(
    UserType userType,
    String email,
    String password,
  ) async {
    return _performAuthAction(
      () => remoteDataSource.loginWithEmail(userType, email, password),
    );
  }

  @override
  Future<Either<Failure, UserEntity>> registerWithEmail(
    UserType userType,
    String email,
    String password,
  ) async {
    return _performAuthAction(
      () => remoteDataSource.registerWithEmail(userType, email, password),
    );
  }

  @override
  Future<Either<Failure, UserEntity>> loginWithGoogle(UserType userType) async {
    return _performAuthAction(() => remoteDataSource.loginWithGoogle(userType));
  }

  @override
  Future<Either<Failure, UserEntity>> loginWithFacebook(
    UserType userType,
  ) async {
    return _performAuthAction(
      () => remoteDataSource.loginWithFacebook(userType),
    );
  }

  // دالة مساعدة لتنفيذ عمليات المصادقة وتخزين النتيجة محلياً
  Future<Either<Failure, UserEntity>> _performAuthAction(
    Future<UserModel> Function() action,
  ) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure('No internet connection'));
    }
    try {
      final user = await action();
      await localDataSource.cacheUser(user);
      log("user in cached in auth repo impl is : $user");
      return Right(user);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } on ValidationException catch (e) {
      return Left(ValidationFailure(e.message));
    } on UnKnowException catch (e) {
      return Left(UnKnowFailure(e.message));
    } catch (e) {
      return Left(UnKnowFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> sendEmailVerification() async {
    try {
      await remoteDataSource.sendEmailVerification();
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } on ValidationException catch (e) {
      return Left(ValidationFailure(e.message));
    } on UnKnowException catch (e) {
      return Left(UnKnowFailure(e.message));
    } catch (e) {
      return Left(UnKnowFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> checkEmailVerified() async {
    try {
      final isVerified = await remoteDataSource.checkEmailVerified();
      if (isVerified) {
        // تحديث حالة التحقق في التخزين المحلي
        log('is Verified : $isVerified');
        final cachedUser = await localDataSource.getCachedUser();
        log('cached User : $cachedUser');
        if (cachedUser != null) {
          final updatedUser = cachedUser.copyWith(isEmailVerified: true);
          await localDataSource.cacheUser(UserModel.fromEntity(updatedUser));
        }
      }
      return Right(isVerified);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } on ValidationException catch (e) {
      return Left(ValidationFailure(e.message));
    } on UnKnowException catch (e) {
      return Left(UnKnowFailure(e.message));
    } catch (e) {
      return Left(UnKnowFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> sendPasswordResetEmail(String email) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure('No internet connection'));
    }
    try {
      await remoteDataSource.sendPasswordResetEmail(email);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } on ValidationException catch (e) {
      return Left(ValidationFailure(e.message));
    } on UnKnowException catch (e) {
      return Left(UnKnowFailure(e.message));
    } catch (e) {
      return Left(UnKnowFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await remoteDataSource.logout();
      await localDataSource.clearUser();
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, UserEntity?>> getCachedUser() async {
    // try {
    final user = await localDataSource.getCachedUser();
    return Right(user);
    // } on CacheException catch (e) {
    //   return Left(CacheFailure(e.message));
    // }
  }

  @override
  Future<Either<Failure, bool>> isFirstTime() async {
    try {
      final result = await localDataSource.isFirstTime();
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } on ValidationException catch (e) {
      return Left(ValidationFailure(e.message));
    } on UnKnowException catch (e) {
      return Left(UnKnowFailure(e.message));
    } catch (e) {
      return Left(UnKnowFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> setFirstTimeDone() async {
    try {
      await localDataSource.setFirstTimeDone();
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } on ValidationException catch (e) {
      return Left(ValidationFailure(e.message));
    } on UnKnowException catch (e) {
      return Left(UnKnowFailure(e.message));
    } catch (e) {
      return Left(UnKnowFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> setUserType(UserType userType) async {
    try {
      // await remoteDataSource.updateUserProfile(userType: userType);
      final cachedUser = await localDataSource.getCachedUser();
      if (cachedUser != null) {
        final updatedUser = cachedUser.copyWith(userType: userType);
        await localDataSource.cacheUser(UserModel.fromEntity(updatedUser));
      }
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } on ValidationException catch (e) {
      return Left(ValidationFailure(e.message));
    } on UnKnowException catch (e) {
      return Left(UnKnowFailure(e.message));
    } catch (e) {
      return Left(UnKnowFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> setLocationSelected() async {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure('N Internet Connection'));
    }

    try {
      await remoteDataSource.setLocationSelected();
      final cachedUser = await localDataSource.getCachedUser();
      if (cachedUser != null) {
        final updated = cachedUser.copyWith(isLocationSelected: true);
        await localDataSource.cacheUser(UserModel.fromEntity(updated));
      }
      return Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } on ValidationException catch (e) {
      return Left(ValidationFailure(e.message));
    } on UnKnowException catch (e) {
      return Left(UnKnowFailure(e.message));
    } catch (e) {
      return Left(UnKnowFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> setLocationAdress(
    LocationEntity location,
  ) async {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure('Not Internet Connected'));
    }
    try {
      await remoteDataSource.setLocationAddress(
        LocationModel.fromEntity(location),
      );
      final cachedUser = await localDataSource.getCachedUser();
      if (cachedUser != null) {
        final updated = cachedUser.copyWith(
          location: LocationModel.fromEntity(location),
        );
        await localDataSource.cacheUser(UserModel.fromEntity(updated));
      }
      return Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } on ValidationException catch (e) {
      return Left(ValidationFailure(e.message));
    } on UnKnowException catch (e) {
      return Left(UnKnowFailure(e.message));
    } catch (e) {
      return Left(UnKnowFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> setProfileCompleted() async {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure('N Internet Connection'));
    }

    try {
      await remoteDataSource.setProfileCompleted();
      final cachedUser = await localDataSource.getCachedUser();
      if (cachedUser != null) {
        final updated = cachedUser.copyWith(isProfileCompleted: true);
        await localDataSource.cacheUser(UserModel.fromEntity(updated));
      }
      return Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } on ValidationException catch (e) {
      return Left(ValidationFailure(e.message));
    } on UnKnowException catch (e) {
      return Left(UnKnowFailure(e.message));
    } catch (e) {
      return Left(UnKnowFailure(e.toString()));
    }
  }

  // معايا مشكله مع هذه الداله
  // دالة مساعدة لتحديث حقل معين في Firestore والمحلي
  // Future<Either<Failure, void>> _updateUserField(
  //   String field,
  //   var value,
  // ) async {
  //   try {
  //     final uid = FirebaseAuth.instance.currentUser?.uid;
  //     if (uid == null) return const Left(AuthFailure('Not authenticated'));
  //     await FirebaseFirestore.instance.collection('users').doc(uid).update({
  //       field: value,
  //     });
  //     final cachedUser = await localDataSource.getCachedUser();
  //     if (cachedUser != null) {
  //       final updatedUser = cachedUser.copyWith(
  //         isLocationSelected: field == 'isLocationSelected'
  //             ? value
  //             : cachedUser.isLocationSelected,
  //         isProfileCompleted: field == 'isProfileCompleted'
  //             ? value
  //             : cachedUser.isProfileCompleted,
  //       );
  //       await localDataSource.cacheUser(UserModel.fromEntity(updatedUser));
  //     }
  //     return const Right(null);
  //   } catch (e) {
  //     return Left(ServerFailure('Failed to update $field'));
  //   }
  // }

  @override
  Future<Either<Failure, void>> updateUserProfile({
    String? name,
    String? phone,
    LocationEntity? location,
    XFile? image,
  }) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure('No internet connection'));
    }
    try {
      await remoteDataSource.updateUserProfile(
        name: name,
        phone: phone,
        location: location != null ? LocationModel.fromEntity(location) : null,
        imageFile: image,
      );
      // تحديث التخزين المحلي
      final cachedUser = await localDataSource.getCachedUser();
      if (cachedUser != null) {
        final updatedUser = cachedUser.copyWith(
          name: name ?? cachedUser.name,
          phone: phone ?? cachedUser.phone,
          location: location ?? cachedUser.location,

          // الصورة تحتاج إلى معالجة منفصلة (لنحصل على الرابط الجديد)
        );
        // للحصول على رابط الصورة الجديد، يمكن قراءة المستخدم المحدث من remote
        // هنا نبسطها ونترك المستخدم المحلي كما هو، وسيتم تحديثه لاحقاً عند getCachedUser
        await localDataSource.cacheUser(UserModel.fromEntity(updatedUser));
      }
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } on ValidationException catch (e) {
      return Left(ValidationFailure(e.message));
    } on UnKnowException catch (e) {
      return Left(UnKnowFailure(e.message));
    } catch (e) {
      return Left(UnKnowFailure(e.toString()));
    }
  }
}
