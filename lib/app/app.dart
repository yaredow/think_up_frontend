import 'package:flutter/material.dart';
import 'package:think_up/app/router.dart';
import 'package:think_up/core/app_theme.dart';

class ThinkUp extends StatelessWidget {
  const ThinkUp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "ThinkUp",
      theme: AppTheme.lightTheme(),
      onGenerateRoute: AppRouter.generateRoute,
      initialRoute: "/alarm",
      debugShowCheckedModeBanner: false,
    );
  }
}
