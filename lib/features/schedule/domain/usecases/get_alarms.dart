import 'package:think_up/features/schedule/domain/entities/alarm.dart';
import 'package:think_up/features/schedule/domain/repositories/alarm_repository.dart';

class GetAlarms {
  final AlarmRepository repository;

  GetAlarms(this.repository);

  Future<List<Alarm>> call() async {
    return await repository.getAlarms();
  }
}
