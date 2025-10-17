import 'package:flutter/material.dart';

class RingBackground extends StatefulWidget {
  final Widget child;
  const RingBackground({super.key, required this.child});

  @override
  State<RingBackground> createState() => _RingBackgroundState();
}

class _RingBackgroundState extends State<RingBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _breath;
  late final Animation<Color?> _primaryColor;
  late final Animation<Color?> _secondaryColor;
  late final Animation<Alignment> _focusAlignment;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat(reverse: true);
    _breath = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);

    _primaryColor = ColorTween(
      begin: const Color(0xFF0B2F1F),
      end: const Color(0xFF145C36),
    ).animate(_breath);

    _secondaryColor = ColorTween(
      begin: const Color(0xFF4FBF74),
      end: const Color(0xFF8BE4A4),
    ).animate(_breath);

    _focusAlignment = AlignmentTween(
      begin: Alignment.topCenter,
      end: Alignment.bottomRight,
    ).animate(_breath);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _breath,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: _focusAlignment.value,
              radius: 1.4 + (_breath.value * 0.2),
              colors: [
                _primaryColor.value ?? Colors.green.shade900,
                _secondaryColor.value ?? Colors.green.shade600,
              ],
            ),
          ),
          child: Stack(
            children: [
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.white.withValues(alpha: 0.05),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
              child!,
            ],
          ),
        );
      },
      child: widget.child,
    );
  }
}
