import 'package:flutter/material.dart';

class HeroWidget extends StatelessWidget {
  const HeroWidget({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Hero(
          tag: "Hero1",
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: Image.asset(
              "assets/images/bg.jpg",
              color: Colors.teal,
              colorBlendMode: BlendMode.darken,
            ),
          ),
        ),
        Text(
          title,
          style: TextStyle(
            color: Colors.white54,
            fontWeight: FontWeight.bold,
            fontSize: 40.0,
            letterSpacing: 40.0,
          ),
        ),
      ],
    );
  }
}
