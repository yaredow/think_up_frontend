import 'package:flutter/material.dart';
import 'package:think_up/core/notification/notification_service.dart';
import 'package:think_up/features/alarm/domain/entities/alarm.dart';
import 'package:think_up/features/alarm/domain/usecases/add_alarm.dart';
import 'package:think_up/features/alarm/domain/usecases/delete_alarm.dart';
import 'package:think_up/features/alarm/domain/usecases/get_alarms.dart';
import 'package:think_up/features/alarm/domain/usecases/update_alarm.dart';
import 'package:timezone/timezone.dart' as tz;

class AlarmProvider extends ChangeNotifier {
  final AddAlarm addAlarmUseCase;
  final GetAlarms getAlarmsUseCase;
  final DeleteAlarm deleteAlarmUseCase;
  final UpdateAlarm updateAlarmUseCase;
  final NotificationService notificationService;

  List<Alarm> _savedAlarms = [];
  List<Alarm> get savedAlarms => _savedAlarms;

  static const int DRAFT_ID_TEMP = 0;
  // The draft alarm still uses String ID and DateTime time
  Alarm _draftAlarm = Alarm(
    id: DRAFT_ID_TEMP,
    title: 'Wake up',
    time: DateTime.now().copyWith(second: 0, millisecond: 0),
    days: [],
    sound: 'Default',
    isRepeating: true,
  );

  Alarm get draftAlarm => _draftAlarm;
  bool get isEditing => draftAlarm.id != DRAFT_ID_TEMP;

  bool get isAlarmReadyToSave {
    return _draftAlarm.days.isNotEmpty;
  }

  AlarmProvider({
    required this.addAlarmUseCase,
    required this.getAlarmsUseCase,
    required this.deleteAlarmUseCase,
    required this.updateAlarmUseCase,
    required this.notificationService,
  });

  TimeOfDay _getTimeOfDay(DateTime time) {
    return TimeOfDay(hour: time.hour, minute: time.minute);
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
  // ----------------------------------------------------------------------

  int _generateUniqueIntId() {
    return DateTime.now().millisecondsSinceEpoch % 1000000 + 1;
  }

  void updateTime(DateTime newTime) {
    _draftAlarm = _draftAlarm.copyWith(time: newTime);
    notifyListeners();
  }

  void updateDays(List<String> newDays) {
    _draftAlarm = _draftAlarm.copyWith(days: newDays);
    notifyListeners();
  }

  void updateName(String newName) {
    _draftAlarm = _draftAlarm.copyWith(title: newName);
    notifyListeners();
  }

  void updateRepeat(bool isRepeating) {
    _draftAlarm = _draftAlarm.copyWith(isRepeating: isRepeating);
    notifyListeners();
  }

  void updateSound(String soundId) {
    _draftAlarm = _draftAlarm.copyWith(sound: soundId);
    notifyListeners();
  }

  void _resetDraftAlarm() {
    _draftAlarm = Alarm(
      id: DRAFT_ID_TEMP,
      title: 'Wake up',
      time: DateTime.now().copyWith(second: 0, millisecond: 0),
      days: [],
      sound: 'Default',
      isRepeating: true,
    );
    notifyListeners();
  }

  Future<void> loadAlarms() async {
    try {
      final List<Alarm> alarms = await getAlarmsUseCase();

      _savedAlarms = alarms;
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading alarms: $e');
      _savedAlarms = [];
      notifyListeners();
    }
  }

  void loadAlarmForEdit(int id) {
    try {
      final alarmToEdit = _savedAlarms.firstWhere((alarm) => alarm.id == id);

      _draftAlarm = alarmToEdit;

      notifyListeners();
    } catch (e) {
      debugPrint('Error loading alarm for edit: $e');
      _resetDraftAlarm();
    }
  }

  Future<void> saveAlarm() async {
    if (!isAlarmReadyToSave) {
      throw Exception("Alarm requires at least one day selected.");
    }

    Alarm alarmToSchedule;

    if (isEditing) {
      alarmToSchedule = _draftAlarm;

      // 1. Cancel the old notification using the consistent INT ID
      await notificationService.cancelAlarm(alarmToSchedule.id);

      // 2. Persist the updated alarm
      await updateAlarmUseCase(alarmToSchedule);
    } else {
      // 1. Create new alarm: assign a unique INT ID.
      final newIntId = _generateUniqueIntId();
      final newAlarmWithId = _draftAlarm.copyWith(id: newIntId);

      // 2. Persist the new alarm
      await addAlarmUseCase(newAlarmWithId);
      alarmToSchedule = newAlarmWithId;
    }

    if (alarmToSchedule.isActive && alarmToSchedule.days.isNotEmpty) {
      final TimeOfDay alarmTime = _getTimeOfDay(alarmToSchedule.time);
      final tz.TZDateTime scheduledTime = _nextAlarmTime(alarmTime);

      await notificationService.scheduleAlarm(
        alarmToSchedule.id,
        alarmToSchedule.title,
        "Time to ${alarmToSchedule.title}!",
        scheduledTime,
        payload: alarmToSchedule.id.toString(),
      );
    }
    // ------------------

    await loadAlarms();
    _resetDraftAlarm();
  }

  Future<void> deleteAlarm(int id) async {
    try {
      await notificationService.cancelAlarm(id);

      await deleteAlarmUseCase(id);

      await loadAlarms();
      _resetDraftAlarm();
    } catch (e) {
      debugPrint('Error deleting alarm: $e');
      throw Exception('Failed to delete alarm');
    }
  }
}
