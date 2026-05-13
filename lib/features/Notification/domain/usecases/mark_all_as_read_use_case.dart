import 'package:dartz/dartz.dart';
import 'package:khedma/core/errors/failures.dart';
import 'package:khedma/core/Utils/use_case.dart';
import 'package:khedma/features/Notification/domain/repositories/notification_repo.dart';

class MarkAllAsReadParams {
  final String userId;

  MarkAllAsReadParams(this.userId);
}

class MarkAllAsReadUseCase extends UseCase<void, MarkAllAsReadParams> {
  final NotificationRepo _repo;

  MarkAllAsReadUseCase(this._repo);

  @override
  Future<Either<Failure, void>> call(MarkAllAsReadParams params) async {
    return _repo.markAllAsRead(params.userId);
  }
}