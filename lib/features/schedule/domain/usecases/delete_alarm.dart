import 'package:think_up/features/schedule/domain/repositories/alarm_repository.dart';

class DeleteAlarm {
  final AlarmRepository repository;

  DeleteAlarm(this.repository);

  Future<void> call(String id) async {
    await repository.deleteAlarm(id);
  }
}
