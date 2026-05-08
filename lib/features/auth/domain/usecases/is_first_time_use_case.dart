import 'package:dartz/dartz.dart';
import 'package:khedma/core/errors/failures.dart';
import 'package:khedma/features/auth/domain/repositories/auth_repo.dart';

class IsFirstTimeUseCase {
  final AuthRepo authRepo;
  IsFirstTimeUseCase(this.authRepo);

  Future<Either<Failure, bool>> call() {
    return authRepo.isFirstTime();
  }
}
