import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'notification_config.dart';

class LocalNotificationService {
  final FlutterLocalNotificationsPlugin _plugin;

  LocalNotificationService(this._plugin);

  Future<void> initialize({required void Function(String?) onTap}) async {
    const android = AndroidInitializationSettings(
      NotificationConfig.defaultIcon,
    );

    const settings = InitializationSettings(
      android: android,
      iOS: DarwinInitializationSettings(),
    );

    await _plugin.initialize(
      settings: settings,
      onDidReceiveNotificationResponse: (response) {
        onTap(response.payload);
      },
    );

    await _createChannel();
  }

  Future<void> show({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    await _plugin.show(
      id: id,
      title: title,
      body: body,
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          NotificationConfig.channelId,
          NotificationConfig.channelName,
          channelDescription: NotificationConfig.channelDescription,
          importance: Importance.max,
          priority: Priority.high,
        ),
        iOS: const DarwinNotificationDetails(),
      ),
      payload: payload,
    );
  }

  Future<void> cancel(int id) {
    return _plugin.cancel(id: id);
  }

  Future<void> cancelAll() {
    return _plugin.cancelAll();
  }

  Future<void> _createChannel() async {
    final android = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    if (android == null) return;

    await android.createNotificationChannel(
      const AndroidNotificationChannel(
        NotificationConfig.channelId,
        NotificationConfig.channelName,
        description: NotificationConfig.channelDescription,
        importance: Importance.high,
      ),
    );
  }
}
