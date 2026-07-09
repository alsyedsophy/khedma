import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseNotificationService {
  final FirebaseMessaging _messaging;

  FirebaseNotificationService({required FirebaseMessaging messaging})
    : _messaging = messaging;

  final StreamController<RemoteMessage> _foregroundController =
      StreamController<RemoteMessage>.broadcast();
  final StreamController<RemoteMessage> _openedAppController =
      StreamController<RemoteMessage>.broadcast();
  final StreamController<String> _tokenController =
      StreamController<String>.broadcast();

  Stream<RemoteMessage> get onForegroundMessage => _foregroundController.stream;
  Stream<RemoteMessage> get onMessageOpenedApp => _openedAppController.stream;
  Stream<String> get onTokenRefresh => _tokenController.stream;

  Future<void> initialize() async {
    await _requestPermission();

    FirebaseMessaging.onMessage.listen((message) {
      _foregroundController.add(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      _openedAppController.add(message);
    });

    _messaging.onTokenRefresh.listen((token) {
      _tokenController.add(token);
    });
  }

  Future<RemoteMessage?> getInitialMessage() {
    return _messaging.getInitialMessage();
  }

  Future<String?> getToken() {
    return _messaging.getToken();
  }

  Future<void> deleteToken() {
    return _messaging.deleteToken();
  }

  Future<void> subscribeToTopic(String topic) {
    return _messaging.subscribeToTopic(topic);
  }

  Future<void> unsubscribeFromTopic(String topic) {
    return _messaging.unsubscribeFromTopic(topic);
  }

  Future<NotificationSettings> _requestPermission() {
    return _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );
  }

  void dispose() {
    _foregroundController.close();
    _openedAppController.close();
    _tokenController.close();
  }
}
