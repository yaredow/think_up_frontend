import 'package:think_up/features/alarm/data/datasources/alarm_local_data_source.dart';
import 'package:think_up/features/alarm/domain/entities/alarm.dart';
import 'package:think_up/features/alarm/domain/repositories/alarm_repository.dart';

class AlarmRepositoryImpl implements AlarmRepository {
  final AlarmLocalDataSource localDataSource;

  AlarmRepositoryImpl({required this.localDataSource});

  @override
  Future<void> addAlarm(Alarm alarm) async {
    await localDataSource.addAlarm(alarm);
  }

  @override
  Future<List<Alarm>> getAlarms() async {
    return await localDataSource.getAlarms();
  }

  @override
  Future<void> deleteAlarm(int id) async {
    await localDataSource.deleteAlarm(id);
  }

  @override
  Future<void> updateAlarm(Alarm alarm) async {
    await localDataSource.updateAlarm(alarm);
  }
}
