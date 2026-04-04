import 'package:dartz/dartz.dart';
import 'package:khedma/Core/errors/failures.dart';
import 'package:khedma/features/auth/domain/entities/user_entity.dart';
import 'package:khedma/features/auth/domain/repositories/auth_repo.dart';

class SetLocationAddressUseCase {
  final AuthRepo authRepo;

  SetLocationAddressUseCase(this.authRepo);

  Future<Either<Failure, void>> call(LocationEntity location) {
    return authRepo.setLocationAdress(location);
  }
}
