import 'package:dartz/dartz.dart';
import 'package:khedma/Core/errors/failures.dart';
import 'package:khedma/features/auth/domain/entities/user_entity.dart';
import 'package:khedma/features/auth/domain/repositories/auth_repo.dart';

class GetCachedUserUseCase {
  final AuthRepo authRepo;

  GetCachedUserUseCase(this.authRepo);

  Future<Either<Failure, UserEntity?>> call() {
    return authRepo.getCachedUser();
  }
}
