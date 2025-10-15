import 'package:flutter/material.dart';
import 'package:think_up/features/alarm/presentation/screens/alarm_creation_screen.dart';
import 'package:think_up/app/main_screen.dart';
import 'package:think_up/features/alarm/presentation/screens/alarm_ring_screen.dart';

class AppRouter {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

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
      case "/alarm-ring":
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => AlarmRingScreen(alarmId: args?['alarmId'] as String),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => const MainScreen(initialIndex: 0),
        );
    }
  }

  static Future<T?> pushNamed<T extends Object?>(
    String routeName, {
    Object? arguments,
  }) {
    return navigatorKey.currentState!.pushNamed<T>(
      routeName,
      arguments: arguments,
    );
  }
}
