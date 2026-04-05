import 'package:dartz/dartz.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:khedma/Core/errors/failures.dart';
import 'package:khedma/features/auth/domain/entities/user_entity.dart';
import 'package:khedma/features/auth/domain/repositories/auth_repo.dart';

class SetLocationAddressUseCase {
  final AuthRepo authRepo;

  SetLocationAddressUseCase(this.authRepo);

  Future<Either<Failure, void>> call(LatLng latLng, String address) {
    final location = LocationEntity(
      latitude: latLng.latitude,
      longitude: latLng.longitude,
      address: address,
    );
    return authRepo.setLocationAdress(location);
  }
}
