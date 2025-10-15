import 'package:think_up/features/alarm/domain/repositories/alarm_repository.dart';

class DeleteAlarm {
  final AlarmRepository repository;

  DeleteAlarm(this.repository);

  Future<void> call(int id) async {
    await repository.deleteAlarm(id);
  }
}
