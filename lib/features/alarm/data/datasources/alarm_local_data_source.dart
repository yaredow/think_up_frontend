import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:think_up/features/alarm/domain/entities/alarm.dart';

const String kAlarmsKey = 'ALARMS_LIST_KEY';

abstract class AlarmLocalDataSource {
  Future<void> saveAlarm(Alarm alarm);
  Future<List<Alarm>> getAlarms();
  Future<void> deleteAlarm(String id);
}

class AlarmLocalDataSourceImpl implements AlarmLocalDataSource {
  final SharedPreferences sharedPreferences;

  AlarmLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<void> saveAlarm(Alarm alarm) async {
    final List<String> existingAlarmsJson =
        sharedPreferences.getStringList(kAlarmsKey) ?? [];

    final String newAlarmJsonString = json.encode(alarm.toJson());

    // 3. Add the new JSON string to the list
    existingAlarmsJson.add(newAlarmJsonString);

    // 4. Persist the updated list
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
  Future<void> deleteAlarm(String id) async {
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
