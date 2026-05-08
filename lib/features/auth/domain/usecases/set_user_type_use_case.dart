import 'package:dartz/dartz.dart';
import 'package:khedma/core/constants/app_emums.dart';
import 'package:khedma/core/errors/failures.dart';
import 'package:khedma/features/auth/domain/repositories/auth_repo.dart';

class SetUserTypeUseCase {
  final AuthRepo authRepo;
  SetUserTypeUseCase(this.authRepo);

  Future<Either<Failure, void>> call({required UserType userType}) {
    return authRepo.setUserType(userType);
  }
}
