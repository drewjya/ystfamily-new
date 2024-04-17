import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

abstract class PushNotification {
  Future<void> initPushNotification();
  Future<void> onReceivePushNotification({required RemoteMessage message, required bool isFromBackground});
  void setPushNotificationListeners({bool isFromBackground});
  AndroidNotificationChannel getAndroidChannel();
  
}
