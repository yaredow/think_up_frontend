import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:think_up/app/router.dart';
import 'package:think_up/core/alarm_audio_controller.dart';
import 'package:think_up/features/alarm/presentation/provider/alarm_provider.dart';
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
      onDidReceiveNotificationResponse: _handleNotificationResponse,
      onDidReceiveBackgroundNotificationResponse: _handleNotificationResponse,
    );

    final launchDetails = await flutterLocalNotificationsPlugin
        .getNotificationAppLaunchDetails();
    final response = launchDetails?.notificationResponse;
    if ((launchDetails?.didNotificationLaunchApp ?? false) &&
        response != null) {
      unawaited(_handleNotificationResponse(response));
    }
  }

  Future<void> _handleNotificationResponse(
    NotificationResponse response,
  ) async {
    final payload = response.payload;
    if (payload == null || payload.isEmpty) return;

    final alarmId = int.tryParse(payload);
    if (alarmId == null) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      unawaited(_openPuzzleForAlarm(alarmId));
    });
  }

  Future<void> _openPuzzleForAlarm(int alarmId) async {
    final ctx = AppRouter.navigatorKey.currentContext;
    if (ctx == null) return;

    final alarmProvider = ctx.read<AlarmProvider>();
    final alarm = await alarmProvider.getAlarmById(alarmId);

    final assetPath = alarmProvider.resolveRingtoneAsset(
      alarm?.sound ?? alarmProvider.draftAlarm.sound,
    );

    await AlarmAudioController.instance.start(assetPath);

    final navigator = AppRouter.navigatorKey.currentState;
    if (navigator == null) return;

    navigator.pushNamed("/puzzle-launcher", arguments: {'alarmId': alarmId});
  }

  // request permission for modern android
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
          category: AndroidNotificationCategory.alarm,
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
      payload: payload ?? id.toString(),
    );

    debugPrint('Scheduled alarm $id for $scheduledTime');
  }

  Future<void> cancelAlarm(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
    debugPrint('Canceled scheduled alarm with ID: $id');
  }
}
