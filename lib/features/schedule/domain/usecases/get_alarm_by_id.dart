import 'package:think_up/features/schedule/domain/entities/alarm.dart';
import 'package:think_up/features/schedule/domain/repositories/alarm_repository.dart';

class GetAlarmById {
  final AlarmRepository repository;

  GetAlarmById(this.repository);

  Future<Alarm> call(String alarmId) async {
    return await repository.getAlarmById(alarmId);
  }
}
