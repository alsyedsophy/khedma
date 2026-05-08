import 'package:dartz/dartz.dart';
import 'package:khedma/core/constants/app_emums.dart';
import 'package:khedma/core/errors/failures.dart';
import 'package:khedma/features/auth/domain/entities/user_entity.dart';
import 'package:khedma/features/auth/domain/repositories/auth_repo.dart';

class CreateAcountUseCase {
  final AuthRepo authRepo;

  CreateAcountUseCase(this.authRepo);

  Future<Either<Failure, UserEntity>> call({
    required String email,
    required String password,

    required UserType userType,
  }) => authRepo.registerWithEmail(userType, email, password);
}
