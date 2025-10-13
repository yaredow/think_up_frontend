import 'package:flutter/material.dart';
import 'package:think_up/features/alarm/domain/entities/alarm.dart';
import 'package:think_up/features/alarm/domain/usecases/add_alarm.dart';

class AlarmProvider extends ChangeNotifier {
  final AddAlarm addAlarmUseCase;

  Alarm _draftAlarm = Alarm(
    id: 0,
    title: 'Wake up',
    time: DateTime.now().copyWith(second: 0, millisecond: 0),
    days: {'Mon', 'Tue'},
    sound: 'Default',
    isRepeating: true,
  );

  Alarm get draftAlarm => _draftAlarm;

  AlarmProvider({required this.addAlarmUseCase});

  void updateTime(DateTime newTime) {
    _draftAlarm = _draftAlarm.copyWith(time: newTime);
    notifyListeners();
  }

  void updateDays(Set<String> newDays) {
    _draftAlarm = _draftAlarm.copyWith(days: newDays);
    notifyListeners();
  }

  void updateName(String newName) {
    _draftAlarm = _draftAlarm.copyWith(title: newName);
    notifyListeners();
  }

  void updateRepeat(bool isRepeating) {
    _draftAlarm = _draftAlarm.copyWith(isRepeating: isRepeating);
    notifyListeners();
  }

  Future<void> saveAlarm() async {
    final newId = DateTime.now().microsecondsSinceEpoch;
    final finalAlarm = _draftAlarm.copyWith(id: newId);

    await addAlarmUseCase(finalAlarm);
  }
}
