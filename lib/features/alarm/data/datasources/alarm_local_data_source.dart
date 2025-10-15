import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:think_up/features/alarm/domain/entities/alarm.dart';

const String kAlarmsKey = 'ALARMS_LIST_KEY';

abstract class AlarmLocalDataSource {
  Future<void> addAlarm(Alarm alarm);
  Future<List<Alarm>> getAlarms();
  Future<void> deleteAlarm(int id);
  Future<void> updateAlarm(Alarm updatedAlarm);
}

class AlarmLocalDataSourceImpl implements AlarmLocalDataSource {
  final SharedPreferences sharedPreferences;

  AlarmLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<void> addAlarm(Alarm alarm) async {
    final List<String> existingAlarmsJson =
        sharedPreferences.getStringList(kAlarmsKey) ?? [];

    final String newAlarmJsonString = json.encode(alarm.toJson());

    // Add the new JSON string to the list
    existingAlarmsJson.add(newAlarmJsonString);

    // Persist the updated list
    await sharedPreferences.setStringList(kAlarmsKey, existingAlarmsJson);
  }

  @override
  Future<List<Alarm>> getAlarms() async {
    final List<String>? alarmsJsonStrings = sharedPreferences.getStringList(
      kAlarmsKey,
    );

    if (alarmsJsonStrings == null) {
      return [];
    }

    // Convert each JSON string back into an Alarm object
    return alarmsJsonStrings.map((jsonString) {
      final Map<String, dynamic> jsonMap = json.decode(jsonString);
      // NOTE: This requires a factory constructor `Alarm.fromJson(Map<String, dynamic> json)`
      return Alarm.fromJson(jsonMap);
    }).toList();
  }

  @override
  Future<void> updateAlarm(Alarm updatedAlarm) async {
    final List<String> existingAlarmsJson =
        sharedPreferences.getStringList(kAlarmsKey) ?? [];

    int indexToUpdate = -1;

    for (int i = 0; i < existingAlarmsJson.length; i++) {
      final Map<String, dynamic> existingAlarmMap = json.decode(
        existingAlarmsJson[i],
      );

      if (existingAlarmMap["id"] == updatedAlarm.id) {
        indexToUpdate = i;
        break;
      }
    }

    if (indexToUpdate != -1) {
      final String updateAlarmJsonString = json.encode(updatedAlarm.toJson());

      existingAlarmsJson[indexToUpdate] = updateAlarmJsonString;

      await sharedPreferences.setStringList(kAlarmsKey, existingAlarmsJson);
    }
  }

  @override
  Future<void> deleteAlarm(int id) async {
    final List<String> existingAlarmsJson =
        sharedPreferences.getStringList(kAlarmsKey) ?? [];

    final List<String> updatedAlarmsJson = existingAlarmsJson.where((
      jsonString,
    ) {
      final Map<String, dynamic> jsonMap = json.decode(jsonString);
      return jsonMap['id'] != id;
    }).toList();

    await sharedPreferences.setStringList(kAlarmsKey, updatedAlarmsJson);
  }
}
