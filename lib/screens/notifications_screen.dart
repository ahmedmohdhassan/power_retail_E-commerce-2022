import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../classes/notification.dart';

class NotificationsScreen extends StatefulWidget {
  static const routeName = 'not_screen';
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  void initState() {
    getNotifications();
    super.initState();
  }

  List<NotificationModel> notificationsList = [];
  bool? isLoading;
  void getNotifications() async {
    setState(() {
      isLoading = true;
    });
    SharedPreferences _prefs = await SharedPreferences.getInstance();

    var notList = _prefs.getStringList('notifications_list');
    if (notList != null) {
      List<NotificationModel> fetchedNotificationsList = [];
      for (var i in notList) {
        final NotificationModel notification =
            NotificationModel.fromJson(jsonDecode(i));
        fetchedNotificationsList.insert(0, notification);
      }
      setState(() {
        notificationsList = fetchedNotificationsList;
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الاشعارات'),
      ),
      body: isLoading!
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Directionality(
              textDirection: TextDirection.rtl,
              child: notificationsList.isEmpty
                  ? const Center(
                      child: Text('لا يوجد اشعارات للعرض'),
                    )
                  : ListView.builder(
                      itemCount: notificationsList.length,
                      itemBuilder: (context, i) => ListTile(
                        isThreeLine: true,
                        title: Text(notificationsList[i].title!),
                        subtitle: Text(notificationsList[i].message!),
                      ),
                    ),
            ),
    );
  }
}
