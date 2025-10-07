import 'package:flutter/material.dart';
import 'package:think_up_frontend/views/data/notifiers.dart';
import 'package:think_up_frontend/views/pages/home_page.dart';
import 'package:think_up_frontend/views/pages/profile_page.dart';
import 'package:think_up_frontend/views/pages/search_page.dart';
import 'package:think_up_frontend/views/pages/settings_page.dart';
import 'package:think_up_frontend/views/widgets/navbar_widget.dart';

List<Widget> pages = [HomePage(), SearchPage(), ProfilePage()];

class WidgetTree extends StatelessWidget {
  const WidgetTree({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ThinkUp"),
        backgroundColor: Colors.indigo,
        actions: [
          IconButton(
            onPressed: () {
              isDarkModeNotifier.value = !isDarkModeNotifier.value;
            },
            icon: ValueListenableBuilder(
              valueListenable: isDarkModeNotifier,
              builder: (context, isDarkMode, child) {
                return Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode);
              },
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return SettingsPage();
                  },
                ),
              );
            },
            icon: Icon(Icons.settings),
          ),
        ],
        centerTitle: true,
      ),
      body: ValueListenableBuilder(
        valueListenable: selectedPageNotifier,
        builder: (context, value, child) {
          return pages.elementAt(value);
        },
      ),
      bottomNavigationBar: NavbarWidget(),
    );
  }
}
