import 'package:dartz/dartz.dart';
import 'package:khedma/core/errors/failures.dart';
import 'package:khedma/core/Utils/use_case.dart';
import 'package:khedma/features/Notification/domain/entities/notifcation_entity.dart';
import 'package:khedma/features/Notification/domain/repositories/notification_repo.dart';

class UpdatePreferencesParams {
  final NotificationPreferences prefs;
  final String userId;

  UpdatePreferencesParams(this.prefs, this.userId);
}

class UpdatePreferencesUseCase
    extends UseCase<void, UpdatePreferencesParams> {
  final NotificationRepo _repo;

  UpdatePreferencesUseCase(this._repo);

  @override
  Future<Either<Failure, void>> call(
    UpdatePreferencesParams params,
  ) async {
    return _repo.updatePreferences(params.prefs, params.userId);
  }
}