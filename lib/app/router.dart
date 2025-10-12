import 'package:flutter/material.dart';
import 'package:think_up/features/alarm/presentation/screens/alarm_creation_screen.dart';
import 'package:think_up/app/main_screen.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case "/alarm":
        return MaterialPageRoute(
          builder: (_) => const MainScreen(initialIndex: 0),
        );
      case "/stats":
        return MaterialPageRoute(
          builder: (_) => const MainScreen(initialIndex: 1),
        );
      case "/settings":
        return MaterialPageRoute(
          builder: (_) => const MainScreen(initialIndex: 2),
        );
      case "/create-alarm":
        return MaterialPageRoute(builder: (_) => const AlarmCreationScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => const MainScreen(initialIndex: 0),
        );
    }
  }
}
