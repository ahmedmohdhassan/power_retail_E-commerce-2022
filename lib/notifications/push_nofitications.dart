import 'dart:convert';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:gomla/classes/notification.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../notifications/local_notif_service.dart';

class PushNotificationManager {
  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  void init() async {
    if (Platform.isIOS) {
      NotificationSettings settings = await firebaseMessaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );
      // ignore: avoid_print
      print(settings);
      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
    }

    firebaseMessaging.getToken().then((token) async {
      String firebaseToken = token.toString();
      SharedPreferences preferences = await SharedPreferences.getInstance();
      preferences.setString('firebase_token', firebaseToken);
      // ignore: avoid_print
      print(firebaseToken);
    });

    // get the App from terminated state
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) async {
      if (message != null) {
        // ignore: avoid_print
        print(message.notification!.title);
        // ignore: avoid_print
        print(message.notification!.body);
        final notication = NotificationModel(
          title: message.notification!.title,
          message: message.notification!.body,
        );

        final noticationJson = jsonEncode(notication.toJson());
        SharedPreferences preferences = await SharedPreferences.getInstance();
        if (preferences.getStringList('notifications_list') != null) {
          preferences
              .getStringList('notifications_list')!
              .insert(0, noticationJson);
        } else {
          List<String>? notifications = [];
          notifications.add(noticationJson);
          preferences.setStringList('notifications_list', notifications);
        }
      }
    });
    // Foreground notifications
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      if (message.notification != null) {
        // ignore: avoid_print
        print(message.notification!.title);
        // ignore: avoid_print
        print(message.notification!.body);
        final notication = NotificationModel(
          title: message.notification!.title,
          message: message.notification!.body,
        );
        final noticationJson = jsonEncode(notication.toJson());
        SharedPreferences preferences = await SharedPreferences.getInstance();
        if (preferences.getStringList('notifications_list') != null) {
          preferences
              .getStringList('notifications_list')!
              .insert(0, noticationJson);
        } else {
          List<String>? notifications = [];
          notifications.add(noticationJson);
          preferences.setStringList('notifications_list', notifications);
        }
      }
      LocalNotificationService.display(message);
    });
    // background but not terminated
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      if (message.notification != null) {
        // ignore: avoid_print
        print(message.notification!.title);
        // ignore: avoid_print
        print(message.notification!.body);
        final notication = NotificationModel(
          title: message.notification!.title,
          message: message.notification!.body,
        );
        final noticationJson = jsonEncode(notication.toJson());
        SharedPreferences preferences = await SharedPreferences.getInstance();
        if (preferences.getStringList('notifications_list') != null) {
          preferences
              .getStringList('notifications_list')!
              .insert(0, noticationJson);
        } else {
          List<String>? notifications = [];
          notifications.add(noticationJson);
          preferences.setStringList('notifications_list', notifications);
        }
      }
    });
  }
}

//background notifications a Top-level function.
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  if (message.notification != null) {
    // ignore: avoid_print
    print(message.notification!.title);
    // ignore: avoid_print
    print(message.notification!.body);
    final notication = NotificationModel(
      title: message.notification!.title,
      message: message.notification!.body,
    );
    final noticationJson = jsonEncode(notication.toJson());
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (preferences.getStringList('notifications_list') != null) {
      preferences
          .getStringList('notifications_list')!
          .insert(0, noticationJson);
    } else {
      List<String>? notifications = [];
      notifications.add(noticationJson);
      preferences.setStringList('notifications_list', notifications);
    }
  }
}
