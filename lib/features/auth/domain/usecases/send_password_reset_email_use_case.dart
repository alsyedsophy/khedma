import 'package:dartz/dartz.dart';
import 'package:khedma/Core/errors/failures.dart';
import 'package:khedma/features/auth/domain/repositories/auth_repo.dart';

class SendPasswordResetEmailUseCase {
  final AuthRepo authRepo;
  SendPasswordResetEmailUseCase(this.authRepo);

  Future<Either<Failure, void>> call({required String email}) {
    return authRepo.sendPasswordResetEmail(email);
  }
}
