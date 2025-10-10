import 'package:flutter/material.dart';
import 'package:think_up/features/schedule/presentation/screens/schedule_screen.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case "/schedule":
        return MaterialPageRoute(builder: (_) => const ScheduleScreen());
      default:
        return MaterialPageRoute(builder: (_) => const ScheduleScreen());
    }
  }
}
