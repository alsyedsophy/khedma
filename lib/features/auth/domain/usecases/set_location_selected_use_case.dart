import 'package:dartz/dartz.dart';
import 'package:khedma/Core/errors/failures.dart';
import 'package:khedma/features/auth/domain/repositories/auth_repo.dart';

class SetLocationSelectedUseCase {
  final AuthRepo authRepo;
  SetLocationSelectedUseCase(this.authRepo);

  Future<Either<Failure, void>> call() {
    return authRepo.setLocationSelected();
  }
}
