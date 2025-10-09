import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:think_up/app/app.dart';
import 'package:think_up/features/schedule/data/repositories/alarm_repository_impl.dart';
import 'package:think_up/features/schedule/domain/usecases/add_alarm.dart';
import 'package:think_up/features/schedule/domain/usecases/delete_alarm.dart';
import 'package:think_up/features/schedule/domain/usecases/get_alarm_by_id.dart';
import 'package:think_up/features/schedule/domain/usecases/get_alarms.dart';
import 'package:think_up/features/schedule/presentation/provider/alarm_provider.dart';

void main() {
  final alarmRepository = AlarmRepositoryImpl();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AlarmProvider(
            getAlarmByIdUseCase: GetAlarmById(alarmRepository),
            getAlarmsUseCase: GetAlarms(alarmRepository),
            addAlarmUseCase: AddAlarm(alarmRepository),
            deleteAlarmUseCase: DeleteAlarm(alarmRepository),
          ),
        ),
      ],
      child: ThinkUp(),
    ),
  );
}
