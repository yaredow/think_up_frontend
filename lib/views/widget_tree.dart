import 'package:flutter/material.dart';
import 'package:think_up_frontend/views/pages/home_page.dart';
import 'package:think_up_frontend/views/pages/profile_page.dart';
import 'package:think_up_frontend/views/pages/search_page.dart';
import 'package:think_up_frontend/views/widgets/navbar_widget.dart';

List<Widget> pages = [
  ProfilePage(), HomePage(), SearchPage()
];

class WidgetTree extends StatelessWidget {
  const WidgetTree({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("ThinkUp"),
          backgroundColor: Colors.indigo,
          centerTitle: true,
        ),
        body: pages.elementAt(0),
        bottomNavigationBar: NavbarWidget(),
      );
  }
}
