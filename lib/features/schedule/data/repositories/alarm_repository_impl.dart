import 'package:think_up/features/schedule/domain/entities/alarm.dart';
import 'package:think_up/features/schedule/domain/repositories/alarm_repository.dart';

class AlarmRepositoryImpl implements AlarmRepository {
  final List<Alarm> _alarms = [];

  @override
  Future<void> addAlarm(Alarm alarm) async {
    _alarms.add(alarm);
  }

  @override
  Future<void> deleteAlarm(String id) async {
    _alarms.removeWhere((alarm) => alarm.id.toString() == id);
  }

  @override
  Future<Alarm?> getAlarmById(String alarmId) async {
    return _alarms.firstWhere((alarm) => alarm.id.toString() == alarmId);
  }

  @override
  Future<List<Alarm>> getAlarms() async {
    return List<Alarm>.from(_alarms);
  }

  @override
  Future<void> updateAlarm(Alarm alarm) async {
    final index = _alarms.indexWhere((a) => a.id == alarm.id);
    if (index != -1) {
      _alarms[index] = alarm;
    }
  }
}
