import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:khedma/features/Notification/domain/usecases/get_notifications_use_case.dart';
import 'package:khedma/features/Notification/domain/usecases/mark_as_read_use_case.dart';
import 'package:khedma/features/Notification/domain/usecases/mark_all_as_read_use_case.dart';
import 'notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  final GetNotificationsUseCase _getNotifications;
  final MarkAsReadUseCase _markAsRead;
  final MarkAllAsReadUseCase _markAllAsRead;

  NotificationCubit({
    required GetNotificationsUseCase getNotifications,
    required MarkAsReadUseCase markAsRead,
    required MarkAllAsReadUseCase markAllAsRead,
  })  : _getNotifications = getNotifications,
        _markAsRead = markAsRead,
        _markAllAsRead = markAllAsRead,
        super(NotificationInitial());

  Future<void> fetch({
    String? type,
    bool? isRead,
    int? limit,
    DateTime? startAfter,
    required String userId,
  }) async {
    emit(NotificationLoading());
    final result = await _getNotifications(
      GetNotificationsParams(
        type: type,
        isRead: isRead,
        limit: limit,
        startAfter: startAfter,
        userId: userId,
      ),
    );
    result.fold(
      (failure) => emit(NotificationError(failure.message)),
      (notifications) => emit(NotificationLoaded(notifications)),
    );
  }

  Future<void> markAsRead({required String id, required String userId}) async {
    final result = await _markAsRead(MarkAsReadParams(id, userId));
    result.fold(
      (failure) => emit(NotificationError(failure.message)),
      (_) => fetch(userId: userId), // refresh list
    );
  }

  Future<void> markAllAsRead({required String userId}) async {
    final result = await _markAllAsRead(MarkAllAsReadParams(userId));
    result.fold(
      (failure) => emit(NotificationError(failure.message)),
      (_) => fetch(userId: userId),
    );
  }
}
