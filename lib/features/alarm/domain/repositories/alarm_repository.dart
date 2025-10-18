import 'package:think_up/features/alarm/domain/entities/alarm.dart';

abstract class AlarmRepository {
  Future<void> addAlarm(Alarm alarm);

  Future<List<Alarm>> getAlarms();

  Future<void> deleteAlarm(int id);

  Future<void> updateAlarm(Alarm alarm);

  Future<Alarm?> getAlarmById(int id);
}
