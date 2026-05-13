import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:khedma/core/extensions/date_time_extensions.dart';
import 'package:khedma/features/Notification/domain/entities/notifcation_entity.dart';
import 'package:khedma/features/Notification/presentation/cubit/notification_cubit.dart';
import 'package:khedma/features/Notification/presentation/cubit/notification_state.dart';

class NotificationListScreen extends StatelessWidget {
  const NotificationListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = GetIt.I<NotificationCubit>();
    // TODO: replace with real user id retrieval
    const userId = 'user-id-placeholder';
    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: BlocProvider(
        create: (_) => cubit..fetch(userId: userId),
        child: BlocBuilder<NotificationCubit, NotificationState>(
          builder: (context, state) {
            if (state is NotificationLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is NotificationError) {
              return Center(child: Text(state.message));
            }
            if (state is NotificationLoaded) {
              final notifications = state.notifications;
              return RefreshIndicator(
                onRefresh: () => cubit.fetch(userId: userId),
                child: ListView.separated(
                  itemCount: notifications.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final n = notifications[index];
                    return ListTile(
                      title: Text(
                        n.title,
                        style: TextStyle(
                          fontWeight: n.isRead
                              ? FontWeight.normal
                              : FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(n.body),
                      trailing: Text(n.timestamp.formattedDate),
                      onTap: () => cubit.markAsRead(id: n.id, userId: userId),
                    );
                  },
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
