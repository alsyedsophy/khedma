import 'package:dartz/dartz.dart';
import 'package:khedma/Core/errors/failures.dart';
import 'package:khedma/features/auth/domain/repositories/auth_repo.dart';

class CheckEmailVerifiedUseCase {
  final AuthRepo authRepo;
  CheckEmailVerifiedUseCase(this.authRepo);

  Future<Either<Failure, bool>> call() {
    return authRepo.checkEmailVerified();
  }
}
