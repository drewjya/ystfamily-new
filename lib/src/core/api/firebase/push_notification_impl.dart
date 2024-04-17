import 'dart:convert';
import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ystfamily/firebase_options.dart';
import 'package:ystfamily/main.dart';
import 'package:ystfamily/src/core/api/firebase/push_notification.dart';
import 'package:ystfamily/src/core/core.dart';

@pragma('vm:entry-point')
Future<void> backgroundHandler(RemoteMessage message) async {
  log("MEssage Here $message");
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  var localNotificationPlugin = FlutterLocalNotificationsPlugin();
  if (sl.isRegistered<FlutterLocalNotificationsPlugin>()) {
  } else {
    sl.registerLazySingleton(() => localNotificationPlugin);
  }
  if (sl.isRegistered<PushNotification>()) {
  } else {
    sl.registerLazySingleton<PushNotification>(
      () => IPushNotification(
        flutterLocalNotificationsPlugin: sl<FlutterLocalNotificationsPlugin>(),
        firebaseMessaging: FirebaseMessaging.instance,
      ),
    );
  }

  await sl<PushNotification>().initPushNotification().then((value) {
    sl<PushNotification>().setPushNotificationListeners(isFromBackground: true);
  });

  await sl<PushNotification>()
      .onReceivePushNotification(message: message, isFromBackground: true);
}

Future<void> initPushNotif() async {
  var localNotificationPlugin = FlutterLocalNotificationsPlugin();
  if (sl.isRegistered<FlutterLocalNotificationsPlugin>()) {
  } else {
    sl.registerLazySingleton(() => localNotificationPlugin);
  }
  if (sl.isRegistered<PushNotification>()) {
  } else {
    sl.registerLazySingleton<PushNotification>(
      () => IPushNotification(
        flutterLocalNotificationsPlugin: sl<FlutterLocalNotificationsPlugin>(),
        firebaseMessaging: FirebaseMessaging.instance,
      ),
    );
  }
}

class IPushNotification implements PushNotification {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  final FirebaseMessaging firebaseMessaging;
  IPushNotification({
    required this.flutterLocalNotificationsPlugin,
    required this.firebaseMessaging,
  });

  @override
  AndroidNotificationChannel getAndroidChannel() {
    return const AndroidNotificationChannel(
      'yst_family_channel', // id
      'YST Family', // title
      importance: Importance.high,
      playSound: true,
      sound: RawResourceAndroidNotificationSound('notification'),
    );
  }

  @override
  Future<void> initPushNotification() async {
    const permission = Permission.notification;
    var status = await permission.status;

    if (!status.isGranted) {
      status = await permission.request();
    }
    const initializationSettingsAndroid =
        AndroidInitializationSettings('ic_launcher');

    const DarwinInitializationSettings iosInitializationSettings =
        DarwinInitializationSettings(
      defaultPresentAlert: true,
      defaultPresentBadge: true,
      defaultPresentSound: true,
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    /// initialize for bot system
    const initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: iosInitializationSettings);
    flutterLocalNotificationsPlugin = flutterLocalNotificationsPlugin
      ..initialize(initializationSettings)
      ..resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(getAndroidChannel())
      ..resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>();
    await firebaseMessaging.requestPermission();
    await firebaseMessaging.setForegroundNotificationPresentationOptions(
        alert: true, badge: true, sound: false);
  }

  @override
  Future<void> onReceivePushNotification(
      {required RemoteMessage message, required bool isFromBackground}) async {
    RemoteNotification? remoteNotification = message.notification;
    var payload = {};
    String? notificationTitle;
    String? notificationBody;
    String? notificationBanner;
    if (remoteNotification != null) {
      if (remoteNotification.title == "webinar" ||
          remoteNotification.title == 'Top Up' ||
          (remoteNotification.title == null
              ? false
              : remoteNotification.title!.toLowerCase().contains("webinar"))) {
        if (isFromBackground) {
        } else {
          notificationTitle = remoteNotification.title ?? "Saham Rakyat";
          notificationBody = remoteNotification.body;
          payload = {
            "type": remoteNotification.title == 'Top Up' ? "topup" : "webinar",
            "data": message.data,
            "isFromBackground": isFromBackground,
          };
        }
      } else {
        var data = message.data;
        notificationTitle = ((data['title'] ?? '') as String).isNotEmpty
            ? data['title']
            : remoteNotification.title;
        notificationBody = ((data['message'] ?? '') as String).isNotEmpty
            ? data['message']
            : remoteNotification.body;
        notificationBanner = data['image_url'];
        payload = {
          "type": data['type'] ?? {},
          "data": data['data'] ?? {},
          "isFromBackground": isFromBackground,
        };
      }
    } else {
      var data = message.data;
      notificationTitle = data['title'];
      notificationBody = data['message'];
      notificationBanner = data['image_url'];
      payload = {
        "type": data['type'] ?? {},
        "data": data['data'] ?? {},
        "isFromBackground": isFromBackground,
      };
    }

    // reset data payload if indicated with deep link
    //
    // get data value
    var payloadDeeplink = message.data['data'];
    log('validate deeplink payload $payloadDeeplink');

    // add condition is data null and must be string
    if (payloadDeeplink != null && payloadDeeplink is String) {
      payloadDeeplink = jsonDecode(payloadDeeplink);
      // get page_position from decoded data
      final pagePosition = payloadDeeplink['page_position'];
      // add condition if pagePosition not null than update parameter data on [payload]
      if (pagePosition != null) {
        payload.addAll({'data': message.data});
      }
    }

    log('Notif Title => $notificationTitle, Body => $notificationBody');
    if (notificationTitle != null && notificationBody != null) {
      List<DarwinNotificationAttachment>? iosNotificationAttachments =
          notificationBanner == null ? null : List.empty(growable: true);
      BigPictureStyleInformation? androidNotificationStyle;
      if (notificationBanner != null) {
        log("notificationBanner $notificationBanner");
      }
      if (kIsWeb) {
        snackbarKey.currentState?.showSnackBar(
          SnackBar(
            content: Text(notificationBody),
            backgroundColor: VColor.chipBackground,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }

      // condition to avoid duplicate notification by matching current state

      final androidChannel = getAndroidChannel();
      flutterLocalNotificationsPlugin.show(
        remoteNotification.hashCode,
        notificationTitle,
        notificationBody,
        getNotificationDetails(
            channelId: androidChannel.id,
            channelName: androidChannel.name,
            androidNotifStyle: androidNotificationStyle ??
                BigTextStyleInformation(notificationBody),
            iosNotifAttach: iosNotificationAttachments),
        payload: jsonEncode(payload),
      );
      return;
    }
  }

  NotificationDetails getNotificationDetails(
      {required String channelId,
      required String channelName,
      StyleInformation? androidNotifStyle,
      List<DarwinNotificationAttachment>? iosNotifAttach}) {
    return NotificationDetails(
      android: AndroidNotificationDetails(
        channelId,
        channelName,
        icon: 'ic_launcher',
        color: VColor.backgroundColor,
        autoCancel: true,
        styleInformation: androidNotifStyle,
        priority: Priority.high,
        importance: Importance.max,
        playSound: true,
        sound: const RawResourceAndroidNotificationSound('notification'),
      ),
      iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
          attachments: iosNotifAttach,
          sound: 'notification.wav'),
    );
  }

  @override
  void setPushNotificationListeners({bool isFromBackground = false}) {
    if (!isFromBackground) {
      firebaseMessaging.getToken().then((fcmToken) {
        log("[DEBUG]: [firebaseMessaging] -> FCM_TOKEN $fcmToken");
      });
      FirebaseMessaging.onMessage.listen((message) async {
        log("firebase on message $message ${message.data} msg from ${message.from}");
        await onReceivePushNotification(
            message: message, isFromBackground: isFromBackground);
      });
    }
  }
}
