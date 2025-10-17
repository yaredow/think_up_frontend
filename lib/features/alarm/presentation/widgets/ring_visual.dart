import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class RingVisual extends StatelessWidget {
  final String title;
  final double maxWidth;

  const RingVisual({super.key, required this.title, this.maxWidth = 320});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ColorFiltered(
            colorFilter: const ColorFilter.mode(
              Color(0xFFF3F7F4),
              BlendMode.srcIn,
            ),
            child: Lottie.asset(
              'assets/lotties/alarm_clock.json',
              height: 240,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            title,
            textAlign: TextAlign.center,
            style: theme.textTheme.headlineMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
