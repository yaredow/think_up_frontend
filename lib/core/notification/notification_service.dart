import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:think_up/app/router.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();

  factory NotificationService() {
    return _instance;
  }

  NotificationService._internal();

  static NotificationService get instance => _instance;

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  void triggerAlarmTapNow(String alarmId) {
    final testPayload = alarmId.toString();

    // This directly calls the same navigation logic as onDidReceiveNotificationResponse
    AppRouter.pushNamed("/alarm-ring", arguments: {'alarmId': testPayload});

    print(
      "DEBUG: Immediately triggered navigation to /alarm-ring with ID: $alarmId",
    );
  }

  // initialize the plugin
  Future<void> initialized() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings("@mipmap/ic_launcher");

    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
        );

    const InitializationSettings initializationSettings =
        InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: initializationSettingsIOS,
        );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) async {
        final payload = response.payload;

        if (payload != null && payload.isNotEmpty) {
          final alarmId = payload.toString();

          AppRouter.pushNamed("/alarm-ring", arguments: {"alarmId": alarmId});
        }
      },
    );
  }

  // request permission for moder android
  Future<void> requestPermssion() async {
    final androidImplimentation = flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    await androidImplimentation?.requestNotificationsPermission();

    await androidImplimentation?.requestExactAlarmsPermission();
  }

  Future<void> scheduleAlarm(
    int id,
    String title,
    String body,
    tz.TZDateTime scheduledTime, {
    String? payload,
  }) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          "alarm_channel_id",
          "Alarm Notification",
          channelDescription: "Channel for scheduled alarms",
          importance: Importance.max,
          priority: Priority.high,
          ticker: "alarm_ticker",
          fullScreenIntent: true,
        );

    const DarwinNotificationDetails iOSDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iOSDetails,
    );

    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      scheduledTime,
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,

      payload: payload ?? id.toString(),
    );

    debugPrint('Scheduled alarm $id for $scheduledTime');
  }

  Future<void> cancelAlarm(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
    debugPrint('Canceled scheduled alarm with ID: $id');
  }

  tz.TZDateTime _nextAlarmTime(TimeOfDay time) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );

    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }
    return scheduled;
  }
}
