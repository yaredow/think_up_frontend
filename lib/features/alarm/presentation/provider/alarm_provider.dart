import 'package:flutter/material.dart';
import 'package:think_up/features/alarm/domain/entities/alarm.dart';
import 'package:think_up/features/alarm/domain/usecases/add_alarm.dart';
import 'package:think_up/features/alarm/domain/usecases/delete_alarm.dart';
import 'package:think_up/features/alarm/domain/usecases/get_alarms.dart';
import 'package:think_up/features/alarm/domain/usecases/update_alarm.dart';
import 'package:uuid/uuid.dart';

class AlarmProvider extends ChangeNotifier {
  final AddAlarm addAlarmUseCase;
  final GetAlarms getAlarmsUseCase;
  final DeleteAlarm deleteAlarmUseCase;
  final UpdateAlarm updateAlarmUseCase;

  final _uuid = const Uuid();

  List<Alarm> _savedAlarms = [];
  List<Alarm> get savedAlarms => _savedAlarms;

  Alarm _draftAlarm = Alarm(
    id: 'draft-id-${const Uuid().v4()}',
    title: 'Wake up',
    time: DateTime.now().copyWith(second: 0, millisecond: 0),
    days: [],
    sound: 'Default',
    isRepeating: true,
  );

  Alarm get draftAlarm => _draftAlarm;
  bool get isEditing => !draftAlarm.id.startsWith("draft-id");

  bool get isAlarmReadyToSave {
    return _draftAlarm.days.isNotEmpty;
  }

  AlarmProvider({
    required this.addAlarmUseCase,
    required this.getAlarmsUseCase,
    required this.deleteAlarmUseCase,
    required this.updateAlarmUseCase,
  });

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
      id: 'draft-id-${_uuid.v4()}',
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

  Future<void> saveAlarm() async {
    if (!isAlarmReadyToSave) {
      throw Exception("Alarm requires at least one day selected.");
    }

    final alarmToSave = _draftAlarm;

    if (isEditing) {
      await updateAlarmUseCase(alarmToSave);
    } else {
      final newAlarmWithId = alarmToSave.copyWith(id: _uuid.v4());
      await addAlarmUseCase(newAlarmWithId);
    }

    await loadAlarms();

    _resetDraftAlarm();
  }

  Future<void> deleteAlarm(String id) async {
    try {
      await deleteAlarmUseCase(id);

      await loadAlarms();

      _resetDraftAlarm();
    } catch (e) {
      debugPrint('Error deleting alarm: $e');
      throw Exception('Failed to delete alarm');
    }
  }

  void loadAlarmForEdit(String id) {
    try {
      final alarmToEdit = _savedAlarms.firstWhere((alarm) => alarm.id == id);

      _draftAlarm = alarmToEdit;
    } catch (e) {
      debugPrint('Error loading alarm for edit: $e');
      _resetDraftAlarm();
    }
  }
}
