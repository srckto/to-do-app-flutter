import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '/models/task.dart';
import '/ui/pages/notification_screen.dart';

class NotifyHelper {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  String selectedNotificationPayload = '';

  final BehaviorSubject<String> selectNotificationSubject = BehaviorSubject<String>();
  initializeNotification() async {
    tz.initializeTimeZones();
    _configureSelectNotificationSubject();
    await _configureLocalTimeZone();
    // await requestIOSPermissions(flutterLocalNotificationsPlugin);
    final IOSInitializationSettings initializationSettingsIOS = IOSInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
      onDidReceiveLocalNotification: onDidReceiveLocalNotification,
    );

    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('appicon');

    final InitializationSettings initializationSettings = InitializationSettings(
      iOS: initializationSettingsIOS,
      android: initializationSettingsAndroid,
    );
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: (String? payload) async {
        if (payload != null) {
          debugPrint('notification payload: ' + payload);
        }
        selectNotificationSubject.add(payload!);
      },
    );
  }

  // requesPermisson() async {
  //   List<PendingNotificationRequest> pendingNotificationRequests = await flutterLocalNotificationsPlugin.pendingNotificationRequests();

  // }

  displayNotification({required String title, required String body}) async {
    print('doing test');
    var androidPlatformChannelSpecifics = const AndroidNotificationDetails('your channel id', 'your channel name', 'your channel description', importance: Importance.max, priority: Priority.high);
    var iOSPlatformChannelSpecifics = const IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics, iOS: iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platformChannelSpecifics,
      payload: 'Default_Sound',
    );
  }

  scheduledNotification(int hour, int minutes, Task task) async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
      task.id!,
      task.title,
      task.note,
      //tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
      _nextInstanceOfTenAM(hour, minutes, task),
      const NotificationDetails(
        android: AndroidNotificationDetails('your channel id', 'your channel name', 'your channel description'),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: '${task.title}|${task.note}|${task.startTime}|',
    );
    List<PendingNotificationRequest> pendingNotificationRequests = await flutterLocalNotificationsPlugin.pendingNotificationRequests();
  }

  deleteNotification(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }
  deleteAllNotification() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  //   List<String> _repeatList = ["None", "Daily", "Weekly", "Monthly"];
  tz.TZDateTime _nextInstanceOfTenAM(int hour, int minutes, Task task) {
    DateTime _getDateFromTask = DateFormat.yMd().parse(task.date!);
    print(_getDateFromTask);

    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    final tz.TZDateTime localFormat = tz.TZDateTime.from(_getDateFromTask, tz.local);

    tz.TZDateTime scheduledDate = tz.TZDateTime(tz.local, localFormat.year, localFormat.month, localFormat.day, hour, minutes).subtract(Duration(minutes: task.remind!));

    if (scheduledDate.isBefore(now)) {
      if (task.repeat == "Daily") {
        scheduledDate = scheduledDate.add(const Duration(days: 1));
      }
      if (task.repeat == "Weekly") {
        scheduledDate = tz.TZDateTime(tz.local, now.year, now.month, (localFormat.day) + 7, hour, minutes).subtract(Duration(minutes: task.remind!));
      }
      if (task.repeat == "Monthly") {
        scheduledDate = tz.TZDateTime(tz.local, now.year, (localFormat.month) + 1, (localFormat.day), hour, minutes).subtract(Duration(minutes: task.remind!));
      }
    }

    return scheduledDate;
  }

  void requestIOSPermissions() {
    flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  Future<void> _configureLocalTimeZone() async {
    tz.initializeTimeZones();
    final String timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZoneName));
  }

/*   Future selectNotification(String? payload) async {
    if (payload != null) {
      //selectedNotificationPayload = "The best";
      selectNotificationSubject.add(payload);
      print('notification payload: $payload');
    } else {
      print("Notification Done");
    }
    Get.to(() => SecondScreen(selectedNotificationPayload));
  } */

//Older IOS
  Future onDidReceiveLocalNotification(int id, String? title, String? body, String? payload) async {
    // display a dialog with the notification details, tap ok to go to another page
    /* showDialog(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: const Text('Title'),
        content: const Text('Body'),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: const Text('Ok'),
            onPressed: () async {
              Navigator.of(context, rootNavigator: true).pop();
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Container(color: Colors.white),
                ),
              );
            },
          )
        ],
      ),
    ); 
 */
    Get.dialog(Text(body!));
  }

  void _configureSelectNotificationSubject() {
    selectNotificationSubject.stream.listen((String payload) async {
      debugPrint('My payload is ' + payload);
      await Get.to(() => NotificationScreen(payload: payload));
    });
  }
}
