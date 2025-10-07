import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:think_up_frontend/views/data/constants.dart';
import 'package:think_up_frontend/views/pages/home_page.dart';
import 'package:think_up_frontend/views/pages/login_page.dart';

class OnbordingPage extends StatefulWidget {
  const OnbordingPage({super.key});

  @override
  State<OnbordingPage> createState() => _OnbordingPageState();
}

class _OnbordingPageState extends State<OnbordingPage> {
  Future<void> _completeOnboarding() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_complete', true);

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) {
          return LoginPage(title: "Login");
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.asset("assets/lotties/Welcome.json", height: 400.0),
                SizedBox(height: 20.0),
                Text(
                  "Talk with your AI friend anytime, anywhere!",
                  style: KTextStyle.titleTealText,
                  textAlign: TextAlign.justify,
                ),
                SizedBox(height: 15.0),
                FilledButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return HomePage();
                        },
                      ),
                    );
                  },
                  style: FilledButton.styleFrom(
                    minimumSize: Size(double.infinity, 40.0),
                  ),
                  child: Text("Next"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
