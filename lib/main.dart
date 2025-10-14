import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:think_up/app/app.dart';
import 'package:think_up/core/permissions/permission_service.dart';
import 'package:think_up/core/permissions/permission_service_impl.dart';
import 'package:think_up/features/alarm/data/datasources/alarm_local_data_source.dart';
import 'package:think_up/features/alarm/data/repositories/alarm_repository_impl.dart';
import 'package:think_up/features/alarm/domain/usecases/add_alarm.dart';
import 'package:think_up/features/alarm/domain/usecases/delete_alarm.dart';
import 'package:think_up/features/alarm/domain/usecases/get_alarms.dart';
import 'package:think_up/features/alarm/domain/usecases/update_alarm.dart';
import 'package:think_up/features/alarm/presentation/provider/alarm_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final SharedPreferences sharedPreferences =
      await SharedPreferences.getInstance();

  final AlarmLocalDataSource localDataSource = AlarmLocalDataSourceImpl(
    sharedPreferences: sharedPreferences,
  );

  final alarmRepository = AlarmRepositoryImpl(localDataSource: localDataSource);

  final addAlarmUseCase = AddAlarm(alarmRepository);
  final getAlarmsUseCase = GetAlarms(alarmRepository);
  final deleteAlarmUseCase = DeleteAlarm(alarmRepository);
  final updateAlarmUseCase = UpdateAlarm(alarmRepository);
  final PermissionService permissionService = PermissionServiceImpl();

  runApp(
    MultiProvider(
      providers: [
        Provider<PermissionService>.value(value: permissionService),
        ChangeNotifierProvider(
          create: (_) => AlarmProvider(
            addAlarmUseCase: addAlarmUseCase,
            getAlarmsUseCase: getAlarmsUseCase,
            deleteAlarmUseCase: deleteAlarmUseCase,
            updateAlarmUseCase: updateAlarmUseCase,
          ),
        ),
      ],
      child: ThinkUp(),
    ),
  );
}
