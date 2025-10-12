import 'dart:math';

import 'package:flutter/material.dart';

class CircularTimePicker extends StatefulWidget {
  const CircularTimePicker({super.key});

  @override
  State<CircularTimePicker> createState() => _CircularTimePickerState();
}

class _CircularTimePickerState extends State<CircularTimePicker> {
  DateTime _selectedTime = DateTime(2025, 10, 12, 10, 30);

  double _calculateFullTimeAngle(DateTime time) {
    final hour12 = time.hour % 12;
    final totalMinutes = (hour12 * 60) + time.minute;
    return (totalMinutes / 720) * 2 * pi;
  }

  void _updateTimeFromDrag(Offset localPosition, double size) {
    final center = Offset(size / 2, size / 2);
    final dx = localPosition.dx - center.dx;
    final dy = localPosition.dy - center.dy;

    // row angle from the center to the touch point
    double angle = atan2(dy, dx);
    angle = angle + pi / 2;

    // ensure angle is true
    if (angle < 0) {
      angle += 2 * pi;
    }

    // convert the angle back to total minutes
    int totalMinutes = (angle / (2 * pi) * 720).round();

    // Snap to the nearest 5 minutes for smoother UI movement
    int minuteToSnap = totalMinutes % 60;

    // Round to the nearest 5 minute interval
    if (minuteToSnap % 5 != 0) {
      minuteToSnap = (minuteToSnap / 5).round() * 5;

      // Update totalMinutes with the snapped minute
      totalMinutes = (totalMinutes ~/ 60) * 60 + minuteToSnap;

      // Correct for wrap-around if snapping pushed minutes past 59
      if (totalMinutes >= 720) {
        totalMinutes = 0;
      }
    }

    // 4. Convert total minutes into hour and minute components
    int newHour = (totalMinutes ~/ 60); // Hours (0-11)
    int newMinute = totalMinutes % 60; // Minutes (0-59)

    // 5. Apply the current AM/PM context to the hour
    // We need to keep the AM/PM of the original time.
    // If the original time was PM (hour >= 12), we add 12 to the new hour
    if (_selectedTime.hour >= 12 && newHour < 12) {
      newHour += 12;
    }

    setState(() {
      _selectedTime = _selectedTime.copyWith(hour: newHour, minute: newMinute);
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size.width * 0.6;

    final minuteAngle = _calculateFullTimeAngle(_selectedTime);

    return Center(
      child: Column(
        children: [
          GestureDetector(
            onPanDown: (details) {
              _updateTimeFromDrag(details.localPosition, size);
            },
            onPanUpdate: (details) {
              _updateTimeFromDrag(details.localPosition, size);
            },
            child: SizedBox(
              height: size,
              width: size,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CustomPaint(
                    size: Size(size, size),
                    painter: _CircularTimePainter(
                      activeColor: Colors.green.shade400,
                      trackColor: Colors.grey.shade300,
                      selectedTime: _selectedTime,
                      currentMinuteAnge: minuteAngle,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Column(
            children: [
              Text(
                "07:30 AM",
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 10.0),
              Text(
                "Alarm in 20 hours 54 minutes",
                style: TextStyle(fontSize: 14, color: Colors.black54),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CircularTimePainter extends CustomPainter {
  final Color trackColor;
  final Color activeColor;
  final DateTime selectedTime;
  final double currentMinuteAnge;

  _CircularTimePainter({
    required this.trackColor,
    required this.activeColor,
    required this.selectedTime,
    required this.currentMinuteAnge,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width / 2, size.height / 2);
    const trackWidth = 20.0;

    final trackPaint = Paint()
      ..color = trackColor
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = 20.0;

    final trackRadius = radius - trackWidth / 2;
    // 2. Draw the background circular track
    canvas.drawCircle(center, trackRadius, trackPaint);
    // Draw the active arc
    _drawActiveArc(canvas, center, trackRadius);

    // Draw the clock numbers
    _drawClockNumber(canvas, center, trackRadius);

    // Draw the clock hands
    _drawClockHands(canvas, center, trackRadius);

    // Draw the center dot
    final centerDotPaint = Paint()..color = Colors.green.shade600;
    canvas.drawCircle(center, 5.0, centerDotPaint);
  }

  void _drawActiveArc(Canvas canvas, Offset center, double trackRadius) {
    const trackWidth = 20.0;

    final rect = Rect.fromCircle(center: center, radius: trackRadius);

    final activePaint = Paint()
      ..color = activeColor
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = trackWidth;

    const startAngle = -pi / 2;
    final sweepAngle = currentMinuteAnge;

    canvas.drawArc(rect, startAngle, sweepAngle, false, activePaint);

    // calculate the coordinate of the handle center point

    final handleX = center.dx + trackRadius * cos(startAngle + sweepAngle);
    final handleY = center.dy + trackRadius * sin(startAngle + sweepAngle);

    // --- DRAWING THE CUSTOM HANDLE ---

    // 1. Draw the Outer White Circle (Handle Background)
    final handleOuterPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    const handleRadius = trackWidth / 2;
    canvas.drawCircle(Offset(handleX, handleY), handleRadius, handleOuterPaint);

    // 2. Setup Icon Painting (TextPainter)

    // Define the icon style
    final iconTextSpan = TextSpan(
      // 🛑 Using the corrected icon: arrow_forward_ios 🛑
      text: String.fromCharCode(Icons.arrow_forward_ios_rounded.codePoint),
      style: TextStyle(
        color: activeColor, // Green color
        fontSize: 14.0,
        fontFamily: Icons.arrow_forward_ios_rounded.fontFamily,
        package: Icons.arrow_forward_ios_rounded.fontPackage,
      ),
    );

    final iconPainter = TextPainter(
      text: iconTextSpan,
      textDirection: TextDirection.ltr,
    );

    iconPainter.layout();

    // --- ROTATION LOGIC ---
    // The rotation angle is the sweepAngle itself
    final rotationAngle = sweepAngle;

    canvas.save(); // Save the current canvas state

    // Move the canvas origin to the center of the handle
    canvas.translate(handleX, handleY);

    // Apply the rotation (clockwise by the angle of the arc)
    canvas.rotate(rotationAngle);

    // Calculate the offset to center the icon AFTER the rotation and translation.
    // The center point is now (0, 0) relative to the translated canvas.
    final iconOffset = Offset(-iconPainter.width / 2, -iconPainter.height / 2);

    // Paint the icon onto the translated and rotated canvas
    iconPainter.paint(canvas, iconOffset);

    canvas.restore();
  }

  void _drawClockNumber(Canvas canvas, Offset center, double trackRadius) {
    const defaultTextStyle = TextStyle(
      color: Colors.grey,
      fontSize: 17,
      fontWeight: FontWeight.w400,
    );

    final activeTextStyle = TextStyle(
      color: activeColor,
      fontSize: 19,
      fontWeight: FontWeight.w600,
    );

    final textRadius = trackRadius * 0.75;

    for (int i = 1; i <= 12; i++) {
      final angle = (i / 12 * 2 * pi) - (pi / 2);

      final x = center.dx + textRadius * cos(angle);
      final y = center.dy + textRadius * sin(angle);

      final isKeyHour = (i % 3 == 0) || (i == 12);
      final textStyle = isKeyHour ? activeTextStyle : defaultTextStyle;

      final textSpan = TextSpan(text: i.toString(), style: textStyle);
      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center,
      );

      textPainter.layout();

      final textOffset = Offset(
        x - textPainter.width / 2,
        y - textPainter.height / 2,
      );

      textPainter.paint(canvas, textOffset);
    }
  }

  void _drawClockHands(Canvas canvas, Offset center, double trackRadius) {
    final hour = selectedTime.hour;
    final minute = selectedTime.minute;

    final handPaint = Paint()
      ..color = Colors.green.shade600
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    //hour hand calculation
    final hourAngle = ((hour % 12) + (minute / 60)) / 12 * 2 * pi;

    final adjustedHourAngle = hourAngle - (pi / 2);

    final hourHandLengthFactor = 0.5;
    final hourHandRadius = trackRadius * 0.75 * hourHandLengthFactor;

    final hourX = center.dx + hourHandRadius * cos(adjustedHourAngle);
    final hourY = center.dy + hourHandRadius * sin(adjustedHourAngle);

    handPaint.strokeWidth = 6.0;
    canvas.drawLine(center, Offset(hourX, hourY), handPaint);

    //minute hand calculation
    final minuteAngle = (minute / 60) * 2 * pi;
    final adjustedMinuteAngle = minuteAngle - (pi / 2);

    const minuteHandLengthFactor = 0.8;
    final minuteHandRadius = trackRadius * 0.75 * minuteHandLengthFactor;

    final minuteX = center.dx + minuteHandRadius * cos(adjustedMinuteAngle);
    final minuteY = center.dy + minuteHandRadius * sin(adjustedMinuteAngle);

    handPaint.strokeWidth = 3.0; // Thinner stroke for the minute hand
    canvas.drawLine(center, Offset(minuteX, minuteY), handPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    final oldPainter = oldDelegate as _CircularTimePainter;

    // Repaint if the time, angle, or colors have changed
    return oldPainter.selectedTime != selectedTime ||
        oldPainter.currentMinuteAnge != currentMinuteAnge ||
        oldPainter.trackColor != trackColor ||
        oldPainter.activeColor != activeColor;
  }
}
