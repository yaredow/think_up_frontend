import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:think_up/app/app.dart';
import 'package:think_up/core/notification/notification_service.dart';
import 'package:think_up/core/permissions/permission_service.dart';
import 'package:think_up/core/permissions/permission_service_impl.dart';
import 'package:think_up/features/alarm/data/datasources/alarm_local_data_source.dart';
import 'package:think_up/features/alarm/data/repositories/alarm_repository_impl.dart';
import 'package:think_up/features/alarm/domain/usecases/add_alarm.dart';
import 'package:think_up/features/alarm/domain/usecases/delete_alarm.dart';
import 'package:think_up/features/alarm/domain/usecases/get_alarm_by_id.dart';
import 'package:think_up/features/alarm/domain/usecases/get_alarms.dart';
import 'package:think_up/features/alarm/domain/usecases/update_alarm.dart';
import 'package:think_up/features/alarm/presentation/provider/alarm_provider.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  tz.initializeTimeZones();

  final timezoneInfo = await FlutterTimezone.getLocalTimezone();
  final timeZoneName = timezoneInfo.identifier;

  tz.setLocalLocation(tz.getLocation(timeZoneName));

  await NotificationService.instance.initialized();

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
  final getAlarmByIdUseCase = GetAlarmById(alarmRepository);
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
            getAlarmByIdUseCase: getAlarmByIdUseCase,
            notificationService: NotificationService.instance,
            permissionService: permissionService,
          ),
        ),
      ],
      child: ThinkUp(),
    ),
  );
}
