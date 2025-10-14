import 'package:think_up/features/alarm/domain/entities/alarm.dart';

abstract class AlarmRepository {
  Future<void> addAlarm(Alarm alarm);

  Future<List<Alarm>> getAlarms();

  Future<void> deleteAlarm(String id);

  Future<void> updateAlarm(Alarm alarm);
}
