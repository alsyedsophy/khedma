import 'package:dartz/dartz.dart';
import 'package:khedma/core/errors/failures.dart';
import 'package:khedma/core/Utils/use_case.dart';
import 'package:khedma/features/Notification/domain/entities/notifcation_entity.dart';
import 'package:khedma/features/Notification/domain/repositories/notification_repo.dart';

class GetPreferencesParams {
  final String userId;

  GetPreferencesParams(this.userId);
}

class GetPreferencesUseCase
    extends UseCase<NotificationPreferences, GetPreferencesParams> {
  final NotificationRepo _repo;

  GetPreferencesUseCase(this._repo);

  @override
  Future<Either<Failure, NotificationPreferences>> call(
    GetPreferencesParams params,
  ) async {
    return _repo.getPreferences(params.userId);
  }
}