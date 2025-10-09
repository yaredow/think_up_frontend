import 'package:flutter/cupertino.dart';
import 'package:think_up/features/schedule/domain/entities/alarm.dart';
import 'package:think_up/features/schedule/domain/usecases/add_alarm.dart';
import 'package:think_up/features/schedule/domain/usecases/delete_alarm.dart';
import 'package:think_up/features/schedule/domain/usecases/get_alarm_by_id.dart';
import 'package:think_up/features/schedule/domain/usecases/get_alarms.dart';

class AlarmProvider extends ChangeNotifier {
  final GetAlarms getAlarmsUseCase;
  final DeleteAlarm deleteAlarmUseCase;
  final AddAlarm addAlarmUseCase;
  final GetAlarmById getAlarmByIdUseCase;

  AlarmProvider({
    required this.getAlarmsUseCase,
    required this.deleteAlarmUseCase,
    required this.addAlarmUseCase,
    required this.getAlarmByIdUseCase,
  });

  // state
  List<Alarm> _alarms = [];
  List<Alarm> get alarms => _alarms;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // Fetch all alarms
  Future<void> loadAlarms() async {
    _isLoading = true;
    notifyListeners();

    _alarms = await getAlarmsUseCase();

    _isLoading = false;
    notifyListeners();
  }

  // add a new alarm
  Future<void> addAlarm(Alarm alarm) async {
    await addAlarmUseCase(alarm);
    _alarms.add(alarm);
    notifyListeners();
  }

  // delete alarm
  Future<void> deleteAlarm(String id) async {
    await deleteAlarmUseCase(id);
    _alarms.removeWhere((alarm) => alarm.id.toString() == id);
    notifyListeners();
  }

  // get alarm by ID
  Future<Alarm?> getAlarmById(String id) async {
    return await getAlarmByIdUseCase(id);
  }
}
