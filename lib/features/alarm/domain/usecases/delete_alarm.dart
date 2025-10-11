import 'package:think_up/features/alarm/domain/repositories/alarm_repository.dart';

class DeleteAlarm {
  final AlarmRepository repository;

  DeleteAlarm(this.repository);

  Future<void> call(String alarmId) async {
    return await repository.deleteAlarm(alarmId);
  }
}
