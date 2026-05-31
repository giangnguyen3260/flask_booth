import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_l/resources/app_text_style.dart';

class CommonCounterController extends ChangeNotifier {
  Timer? _timer;
  final int defaultTime;
  int _currentCounter = 0;

  int get currentCounter => _currentCounter;

  CommonCounterController({
    required this.defaultTime,
  }) {
    _currentCounter = defaultTime;
    notifyListeners();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(milliseconds: 1100), (t) {
      if (_currentCounter < 1) {
        t.cancel();
        return;
      }
      _currentCounter -= 1;
      notifyListeners();
    });
  }

  void start() {
    if (_timer == null) {
      _currentCounter = defaultTime;
      notifyListeners();
      _startTimer();
    }
  }

  void stop() {
    _timer?.cancel();
    _timer = null;
  }

  void resume() {
    _timer?.cancel();
    _startTimer();
  }

  void reset() {
    stop();
    start();
  }
}

class LoadingCounter extends StatelessWidget {
  final CommonCounterController controller;
  final TextStyle? textStyle;

  const LoadingCounter({super.key, required this.controller, this.textStyle});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (BuildContext context, Widget? child) {
        return SizedBox.square(
          dimension: 156.r,
          child: CustomPaint(
            painter: CircleLoadingPainter(
                controller.currentCounter / controller.defaultTime, Colors.black, 4.w),
            child: Center(
              child: Text(
                controller.currentCounter.toString(),
                style: style6072600.merge(textStyle),
              ),
            ),
          ),
        );
      },
    );
  }
}

class CommonCounter extends StatelessWidget {
  final CommonCounterController controller;
  final Color? backgroundColor;
  final TextStyle? textStyle;

  const CommonCounter({super.key, required this.controller, this.textStyle, this.backgroundColor});

  String formatTime(int totalSeconds) {
    int minutes = totalSeconds ~/ 60;
    int seconds = totalSeconds % 60;
    return "${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (BuildContext context, Widget? child) {
        return SizedBox.square(
          dimension: 126.r,
          child: CustomPaint(
            painter: CircleLoadingPainter(
                controller.currentCounter / controller.defaultTime,  backgroundColor ?? Color(0xff37FF00)),
            child: Center(
              child: Text(
                formatTime(controller.currentCounter),
                style: style3860500.merge(textStyle),
              ),
            ),
          ),
        );
      },
    );
  }
}

class CircleLoadingPainter extends CustomPainter {
  final double progress;
  final Color backgroundColor;
  final double? strokeWidth;

  CircleLoadingPainter(this.progress, this.backgroundColor,[this.strokeWidth]);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = backgroundColor
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth ?? 4.w;

    final Paint backgroundPainter = Paint()
      ..color = Colors.white.withValues(alpha: 0.3)
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth ?? 4.w;
    // Draw the arc (circle loading indicator)
    canvas.drawArc(
      Offset.zero & size, // The rectangle in which the arc is drawn
      0, // Start angle (top of the circle)
      2 * math.pi, // Sweep angle (how much of the circle is drawn)
      false, // Do not close the path
      backgroundPainter,
    );

    canvas.drawArc(
      Offset.zero & size, // The rectangle in which the arc is drawn
      0, // Start angle (top of the circle)
      2 * math.pi, // Sweep angle (how much of the circle is drawn)
      false, // Do not close the path
      Paint()..color = Colors.white,
    );

    // Calculate the sweep angle based on the progress
    double angle = -progress * 2 * math.pi; // Full circle: 2π

    // Draw the arc (circle loading indicator)
    canvas.drawArc(
      Offset.zero & size, // The rectangle in which the arc is drawn
      -math.pi / 2, // Start angle (top of the circle)
      angle, // Sweep angle (how much of the circle is drawn)
      false, // Do not close the path
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
