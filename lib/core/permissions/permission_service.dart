abstract class PermissionService {
  // return true if notification permission is granted
  Future<bool> isNotificationGranted();

  // request notification
  Future<bool> requestNotificationPermission();

  // return true if the app can schedule exact alarm
  Future<bool> canScheduleExactAlarm();

  // request permission to schedule exact alarm
  Future<bool> requestScheduleExactAlarm();

  // open the app stting screen
  Future<void> openAppSettings();
}
