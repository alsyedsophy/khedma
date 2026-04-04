import 'package:dartz/dartz.dart';
import 'package:khedma/Core/errors/failures.dart';
import 'package:khedma/features/auth/domain/repositories/auth_repo.dart';

class SetFirstTimeDoneUseCase {
  final AuthRepo authRepo;
  SetFirstTimeDoneUseCase(this.authRepo);

  Future<Either<Failure, void>> call() {
    return authRepo.setFirstTimeDone();
  }
}
