import 'package:think_up/features/alarm/domain/entities/alarm.dart';
import 'package:think_up/features/alarm/domain/repositories/alarm_repository.dart';

class UpdateAlarm {
  final AlarmRepository repository;

  UpdateAlarm(this.repository);

  Future<Alarm> call(Alarm alarm) async {
    return await repository.updateAlarm(alarm);
  }
}
