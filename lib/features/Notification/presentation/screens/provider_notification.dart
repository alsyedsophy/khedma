import 'package:flutter/material.dart';
import 'package:khedma/features/Notification/presentation/screens/notification_list_screen.dart';

class ProviderNotification extends StatelessWidget {
  const ProviderNotification({super.key});

  @override
  Widget build(BuildContext context) {
    return const NotificationListScreen(title: 'Provider Notifications');
  }
}
