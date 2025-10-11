import 'package:permission_handler/permission_handler.dart' as ph;
import 'package:shared_preferences/shared_preferences.dart';
import 'permission_service.dart';

class PermissionServiceImpl implements PermissionService {
  static const String _kAskedExactAlarmKey = 'asked_exact_alarm';

  @override
  Future<bool> isNotificationGranted() async {
    final status = await ph.Permission.notification.status;
    return status.isGranted;
  }

  @override
  Future<bool> requestNotificationPermission() async {
    final status = await ph.Permission.notification.request();
    return status.isGranted;
  }

  // Temporary simple implementation: assume scheduling exact alarms is allowed.
  // We'll add native handling later when ready.
  @override
  Future<bool> canScheduleExactAlarm() async {
    // If you want, you can return false on Android 12+ and handle later.
    return true;
  }

  @override
  Future<bool> requestScheduleExactAlarm() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kAskedExactAlarmKey, true);
    // No native call now — return true to indicate we've "asked".
    return true;
  }

  @override
  Future<void> openAppSettings() async {
    await ph.openAppSettings();
  }

  Future<bool> hasAskedExactAlarmBefore() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_kAskedExactAlarmKey) ?? false;
  }
}
