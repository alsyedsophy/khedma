import 'package:dartz/dartz.dart';
import 'package:khedma/Core/errors/failures.dart';
import 'package:khedma/features/auth/domain/repositories/auth_repo.dart';

class VerifiyEmailUseCase {
  final AuthRepo authRepo;

  VerifiyEmailUseCase(this.authRepo);

  Future<Either<Failure, void>> call() => authRepo.sendEmailVerification();
}
