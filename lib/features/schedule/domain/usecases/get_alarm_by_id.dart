import 'package:think_up/features/schedule/domain/entities/alarm.dart';
import 'package:think_up/features/schedule/domain/repositories/alarm_repository.dart';

class GetAlarmById {
  final AlarmRepository repository;

  GetAlarmById(this.repository);

  /// Execute the use case
  Future<Alarm?> call(String id) async {
    return await repository.getAlarmById(id);
  }
}
