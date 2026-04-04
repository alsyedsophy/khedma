import 'package:dartz/dartz.dart';
import 'package:khedma/Core/constants/app_emums.dart';
import 'package:khedma/Core/errors/failures.dart';
import 'package:khedma/features/auth/domain/entities/user_entity.dart';
import 'package:khedma/features/auth/domain/repositories/auth_repo.dart';

class LoginWithFacebookUseCase {
  final AuthRepo authRepo;

  LoginWithFacebookUseCase(this.authRepo);

  Future<Either<Failure, UserEntity>> call({required UserType userType}) =>
      authRepo.loginWithFacebook(userType);
}
