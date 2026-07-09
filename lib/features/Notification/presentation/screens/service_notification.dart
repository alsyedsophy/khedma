import 'package:flutter/material.dart';
import 'package:khedma/features/Notification/presentation/screens/notification_list_screen.dart';

class ServiceNotification extends StatelessWidget {
  const ServiceNotification({super.key});

  @override
  Widget build(BuildContext context) {
    return const NotificationListScreen(title: 'Service Notifications');
  }
}
