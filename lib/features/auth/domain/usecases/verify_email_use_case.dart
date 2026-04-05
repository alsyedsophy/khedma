import 'package:dartz/dartz.dart';
import 'package:khedma/Core/errors/failures.dart';
import 'package:khedma/features/auth/domain/repositories/auth_repo.dart';

class VerifyEmailUseCase {
  final AuthRepo authRepo;

  VerifyEmailUseCase(this.authRepo);

  Future<Either<Failure, void>> call() => authRepo.sendEmailVerification();
}
