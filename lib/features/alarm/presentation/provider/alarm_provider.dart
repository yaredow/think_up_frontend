import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:think_up/features/alarm/domain/entities/alarm.dart';
import 'package:think_up/features/alarm/domain/usecases/add_alarm.dart';
import 'package:think_up/features/alarm/domain/usecases/delete_alarm.dart';
import 'package:think_up/features/alarm/domain/usecases/get_alarm_by_id.dart';
import 'package:think_up/features/alarm/domain/usecases/get_alarms.dart';
import 'package:think_up/features/alarm/domain/usecases/update_alarm.dart';

class AlarmProvider extends ChangeNotifier {
  final GetAlarms getAlarmsUseCase;
  final GetAlarmById getAlarmByIdUseCase;
  final AddAlarm addAlarmUseCase;
  final DeleteAlarm deleteAlarmUseCase;
  final UpdateAlarm updateAlarmUseCase;

  AlarmProvider({
    required this.getAlarmByIdUseCase,
    required this.getAlarmsUseCase,
    required this.addAlarmUseCase,
    required this.deleteAlarmUseCase,
    required this.updateAlarmUseCase,
  });

  // state
  List<Alarm> _alarms = [];
  UnmodifiableListView<Alarm> get alarms => UnmodifiableListView(_alarms);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // Fetch all alarms
  Future<void> loadAlarms() async {
    _isLoading = true;
    notifyListeners();

    _alarms = await getAlarmsUseCase();

    _isLoading = false;
    notifyListeners();
  }

  // Add a new alarm
  Future<void> addAlarm(Alarm alarm) async {
    await addAlarmUseCase(alarm);
    _alarms.add(alarm);
    notifyListeners();
  }

  // Delete an alarm
  Future<void> deleteAlarm(String id) async {
    await deleteAlarmUseCase(id);
    _alarms.removeWhere((alarm) => alarm.id.toString() == id);
    notifyListeners();
  }

  // Get alarm by ID
  Future<Alarm?> getAlarmById(String id) async {
    return await getAlarmByIdUseCase(id);
  }

  Future<Alarm> updateAlarm(Alarm alarm) async {
    final result = await updateAlarmUseCase(alarm);
    final updated = result is Alarm ? result : alarm;
    final idx = _alarms.indexWhere(
      (a) => a.id.toString() == updated.id.toString(),
    );

    if (idx >= 0) {
      _alarms[idx] = updated;
    } else {
      _alarms.add(updated);
    }
    notifyListeners();
    return updated;
  }
}
