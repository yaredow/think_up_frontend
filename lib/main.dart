import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:think_up/app/app.dart';
import 'package:think_up/core/permissions/permission_service.dart';
import 'package:think_up/core/permissions/permission_service_impl.dart';
import 'package:think_up/features/schedule/data/repositories/alarm_repository_impl.dart';
import 'package:think_up/features/schedule/domain/usecases/add_alarm.dart';
import 'package:think_up/features/schedule/domain/usecases/delete_alarm.dart';
import 'package:think_up/features/schedule/domain/usecases/get_alarm_by_id.dart';
import 'package:think_up/features/schedule/domain/usecases/get_alarms.dart';
import 'package:think_up/features/schedule/domain/usecases/update_alarm.dart';
import 'package:think_up/features/schedule/presentation/provider/alarm_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  final alarmRepository = AlarmRepositoryImpl();
  final PermissionService permissionService = PermissionServiceImpl();

  runApp(
    MultiProvider(
      providers: [
        Provider<PermissionService>.value(value: permissionService),
        ChangeNotifierProvider(
          create: (_) => AlarmProvider(
            getAlarmsUseCase: GetAlarms(alarmRepository),
            getAlarmByIdUseCase: GetAlarmById(alarmRepository),
            addAlarmUseCase: AddAlarm(alarmRepository),
            deleteAlarmUseCase: DeleteAlarm(alarmRepository),
            updateAlarmUseCase: UpdateAlarm(alarmRepository),
          ),
        ),
      ],
      child: ThinkUp(),
    ),
  );
}
