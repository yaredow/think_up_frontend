import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RingActions extends StatefulWidget {
  final VoidCallback onDismiss;
  final VoidCallback onSnooze;
  final Duration snoozeDuration;

  const RingActions({
    super.key,
    required this.onDismiss,
    required this.onSnooze,
    this.snoozeDuration = const Duration(minutes: 5),
  });

  @override
  State<RingActions> createState() => _RingActionsState();
}

class _RingActionsState extends State<RingActions> {
  static const double _handleSize = 64;
  static const double _triggerThreshold = 0.85;

  double _dragPercent = 0.0;

  void _resetDrag() => setState(() => _dragPercent = 0.0);

  void _handlePanUpdate(DragUpdateDetails details, double trackWidth) {
    final usableWidth = trackWidth - _handleSize;
    final raw = (details.localPosition.dx - (_handleSize / 2)) / usableWidth;
    setState(() => _dragPercent = raw.clamp(0.0, 1.0));
  }

  void _handlePanEnd() {
    if (_dragPercent >= _triggerThreshold) {
      HapticFeedback.heavyImpact();
      widget.onDismiss();
    } else {
      HapticFeedback.lightImpact();
      _resetDrag();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final snoozeText = 'Snooze ${widget.snoozeDuration.inMinutes} min';

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        FilledButton.tonal(
          style: FilledButton.styleFrom(
            backgroundColor: Colors.white.withValues(alpha: 0.15),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(32),
            ),
          ),
          onPressed: widget.onSnooze,
          child: Text(snoozeText),
        ),
        const SizedBox(height: 24),
        LayoutBuilder(
          builder: (context, constraints) {
            final trackWidth = constraints.maxWidth;
            final handleOffset = _dragPercent * (trackWidth - _handleSize);

            return GestureDetector(
              onPanUpdate: (details) => _handlePanUpdate(details, trackWidth),
              onPanEnd: (_) => _handlePanEnd(),
              child: SizedBox(
                height: _handleSize,
                child: Stack(
                  alignment: Alignment.centerLeft,
                  children: [
                    Container(
                      height: 72,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40),
                        gradient: LinearGradient(
                          colors: [
                            Colors.white.withValues(alpha: 0.08),
                            Colors.white.withValues(alpha: 0.12),
                          ],
                        ),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.18),
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'Slide to dismiss',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: Colors.white.withValues(alpha: 0.8),
                          fontWeight: FontWeight.w500,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                    Positioned(
                      left: handleOffset,
                      child: Transform.scale(
                        scale: 1.0 + (_dragPercent * 0.05),
                        child: Container(
                          width: _handleSize,
                          height: _handleSize,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [
                                Colors.white,
                                Colors.white.withValues(alpha: 0.85),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.25),
                                blurRadius: 16,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.arrow_forward_rounded,
                            color: Colors.black87,
                            size: 32,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
