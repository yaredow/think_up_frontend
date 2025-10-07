import 'package:flutter/material.dart';
import 'package:think_up_frontend/views/widgets/container_widget.dart';
import 'package:think_up_frontend/views/widgets/hero_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: [
            HeroWidget(title: "My App"),
            ContainerWidget(
              title: "Basic Layout",
              description: "Basic description",
            ),
          ],
        ),
      ),
    );
  }
}
