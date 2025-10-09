import 'package:think_up/features/schedule/domain/entities/alarm.dart';

abstract class AlarmRepository {
  Future<List<Alarm>> getAlarms();
  Future<Alarm?> getAlarmById(String id);
  Future<void> addAlarm(Alarm alarm);
  Future<void> updateAlarm(Alarm alarm);
  Future<void> deleteAlarm(String id);
}
