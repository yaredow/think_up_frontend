import 'package:think_up/features/alarm/domain/entities/alarm.dart';
import 'package:think_up/features/alarm/domain/repositories/alarm_repository.dart';

class UpdateAlarm {
  final AlarmRepository _repository;

  UpdateAlarm(this._repository);

  Future<void> call(Alarm alarm) {
    return _repository.updateAlarm(alarm);
  }
}
