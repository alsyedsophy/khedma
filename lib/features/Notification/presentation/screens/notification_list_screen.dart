import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:khedma/app/routing/app_routs.dart';
import 'package:khedma/core/Widgets/app_empty_state.dart';
import 'package:khedma/core/Widgets/app_error_widget.dart';
import 'package:khedma/core/Widgets/app_loading.dart';
import 'package:khedma/core/di/dependency_injections.dart';
import 'package:khedma/core/extensions/app_extensions.dart';
import 'package:khedma/core/extensions/date_time_extensions.dart';
import 'package:khedma/features/auth/presentation/cubit/Auth/auth_cubit.dart';
import 'package:khedma/features/Notification/domain/entities/notifcation_entity.dart';
import 'package:khedma/features/Notification/presentation/cubit/notification_cubit.dart';
import 'package:khedma/features/Notification/presentation/cubit/notification_state.dart';

/// Reusable notification list screen.
///
/// Role-specific screens (Provider/Service) wrap this with their own [title].
/// Requires an authenticated user so the current id can be resolved from
/// [AuthCubit]; when no user is available the screen shows a signed-out state
/// instead of attempting a fetch.
class NotificationListScreen extends StatelessWidget {
  const NotificationListScreen({super.key, this.title = 'Notifications'});
  final String title;

  @override
  Widget build(BuildContext context) {
    final userId = sl<AuthCubit>().state.user?.id;
    return BlocProvider(
      create: (_) {
        final cubit = sl<NotificationCubit>();
        if (userId != null) cubit.fetch(userId: userId);
        return cubit;
      },
      child: _NotificationListView(title: title, userId: userId),
    );
  }
}

class _NotificationListView extends StatelessWidget {
  const _NotificationListView({required this.title, required this.userId});
  final String title;
  final String? userId;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<NotificationCubit>();
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          if (userId != null)
            IconButton(
              icon: const Icon(Icons.done_all),
              tooltip: 'Mark all as read',
              onPressed: () => cubit.markAllAsRead(userId: userId!),
            ),
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'Notification settings',
            onPressed: () => context.pushNamed(AppRoutes.notificationSettings),
          ),
        ],
      ),
      body: userId == null
          ? const AppEmptyState(
              title: 'Sign in required',
              subTitle: 'You need to sign in to view your notifications.',
              icon: Icons.notifications_off_outlined,
            )
          : BlocBuilder<NotificationCubit, NotificationState>(
              builder: (context, state) {
                if (state is NotificationLoading ||
                    state is NotificationInitial) {
                  return const AppLoading();
                }
                if (state is NotificationError) {
                  return AppErrorWidget(
                    message: state.message,
                    onRetry: () => cubit.fetch(userId: userId!),
                  );
                }
                if (state is NotificationLoaded) {
                  final notifications = state.notifications;
                  if (notifications.isEmpty) {
                    return const AppEmptyState(
                      title: 'No notifications',
                      subTitle: 'You are all caught up.',
                      icon: Icons.notifications_none_outlined,
                    );
                  }
                  return RefreshIndicator(
                    onRefresh: () => cubit.fetch(userId: userId!),
                    child: ListView.separated(
                      itemCount: notifications.length,
                      separatorBuilder: (_, _) => const Divider(height: 1),
                      itemBuilder: (context, index) =>
                          _NotificationTile(notification: notifications[index]),
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  const _NotificationTile({required this.notification});
  final NotificationEntity notification;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<NotificationCubit>();
    final userId = context.read<AuthCubit>().state.user?.id;
    return ListTile(
      leading: notification.isRead
          ? null
          : const Icon(Icons.circle, size: 10, color: Colors.blue),
      title: Text(
        notification.title,
        style: TextStyle(
          fontWeight: notification.isRead ? FontWeight.normal : FontWeight.bold,
        ),
      ),
      subtitle: Text(notification.body),
      trailing: Text(notification.timestamp.timeAgo),
      onTap: userId != null && !notification.isRead
          ? () => cubit.markAsRead(id: notification.id, userId: userId)
          : null,
    );
  }
}
