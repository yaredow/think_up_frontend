import 'package:think_up/features/alarm/domain/entities/alarm.dart';
import 'package:think_up/features/alarm/domain/repositories/alarm_repository.dart';

class AddAlarm {
  final AlarmRepository repository;

  AddAlarm(this.repository);

  Future<void> call(Alarm alarm) async {
    return await repository.addAlarm(alarm);
  }
}
