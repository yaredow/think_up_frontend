import 'package:think_up/features/schedule/domain/entities/alarm.dart';

abstract class AlarmRepository {
  // get alarms
  Future<List<Alarm>> getAlarms();

  // get alarm by id
  Future<Alarm?> getAlarmById(String alarmId);

  // add alarm
  Future<void> addAlarm(Alarm alarm);

  // update alarm
  Future<Alarm> updateAlarm(Alarm alarm);

  // delete alarm
  Future<void> deleteAlarm(String alarmId);
}
