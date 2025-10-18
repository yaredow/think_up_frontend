import 'package:think_up/features/alarm/domain/entities/alarm.dart';
import 'package:think_up/features/alarm/domain/repositories/alarm_repository.dart';

const int DRAFT_ID_TEMP = 0;

class AddAlarm {
  final AlarmRepository repository;

  AddAlarm(this.repository);

  Future<void> call(Alarm alarm) async {
    if (alarm.id == DRAFT_ID_TEMP) {
      throw Exception(
        'Alarm ID must be set before saving. Received DRAFT_ID_TEMP.',
      );
    }

    if (alarm.id < 1) {
      throw Exception('Alarm ID must be a positive integer.');
    }

    await repository.addAlarm(alarm);
  }
}
