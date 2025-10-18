import 'package:think_up/features/alarm/domain/entities/alarm.dart';
import 'package:think_up/features/alarm/domain/repositories/alarm_repository.dart';

class GetAlarmById {
  final AlarmRepository repository;

  GetAlarmById(this.repository);

  Future<Alarm?> call(int id) async {
    return await repository.getAlarmById(id);
  }
}
