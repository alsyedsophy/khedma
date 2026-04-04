import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';
import 'package:khedma/Core/errors/failures.dart';
import 'package:khedma/features/auth/domain/entities/user_entity.dart';
import 'package:khedma/features/auth/domain/repositories/auth_repo.dart';

class UpdateUserUseCase {
  final AuthRepo authRepo;

  UpdateUserUseCase(this.authRepo);

  Future<Either<Failure, void>> call({
    String? name,
    String? phone,
    LocationEntity? location,
    XFile? image,
  }) => authRepo.updateUserProfile(
    name: name,
    phone: phone,
    location: location,
    image: image,
  );
}
