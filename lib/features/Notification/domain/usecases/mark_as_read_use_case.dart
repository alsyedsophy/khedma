import 'package:dartz/dartz.dart';
import 'package:khedma/core/errors/failures.dart';
import 'package:khedma/core/Utils/use_case.dart';
import 'package:khedma/features/Notification/domain/repositories/notification_repo.dart';

class MarkAsReadParams {
  final String id;
  final String userId;

  MarkAsReadParams(this.id, this.userId);
}

class MarkAsReadUseCase extends UseCase<void, MarkAsReadParams> {
  final NotificationRepo _repo;

  MarkAsReadUseCase(this._repo);

  @override
  Future<Either<Failure, void>> call(MarkAsReadParams params) async {
    return _repo.markAsRead(params.id, params.userId);
  }
}