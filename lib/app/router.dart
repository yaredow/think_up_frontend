import 'package:flutter/material.dart';
import 'package:think_up/features/alarm/presentation/screens/alarm_creation_screen.dart';
import 'package:think_up/features/alarm/presentation/screens/alarm_list_screen.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case "/":
        return MaterialPageRoute(builder: (_) => const AlarmListScreen());
      case "/create-alarm":
        return MaterialPageRoute(builder: (_) => const AlarmCreationScreen());
      default:
        return MaterialPageRoute(builder: (_) => const AlarmCreationScreen());
    }
  }
}
