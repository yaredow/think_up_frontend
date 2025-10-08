import 'package:flutter/material.dart';
import 'package:think_up_frontend/views/pages/course_page.dart';
import 'package:think_up_frontend/views/pages/expanded_page.dart';
import 'package:think_up_frontend/views/widgets/container_widget.dart';
import 'package:think_up_frontend/views/widgets/hero_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: [
            HeroWidget(title: "My App", nextPage: CoursePage()),
            ContainerWidget(
              title: "Basic Layout",
              description: "Basic description",
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ExpandedPage()),
                );
              },
              child: Text("Click Me"),
            ),
          ],
        ),
      ),
    );
  }
}
