import 'package:flutter/material.dart';
import 'package:mobile_app/utils/help_util.dart';

class CustomProgressBar extends StatelessWidget {
  final double percent; // 0.0 to 1.0
  final double circleDiameter;
  final double barHeight;
  final double tickHeight;
  final String grade;
  const CustomProgressBar({
    super.key,
    required this.percent,
    this.circleDiameter = 25.0,
    this.barHeight = 10.0,
    this.tickHeight = 5.0, required this.grade,
  });

  String getGradeLetter(double percent) {
    double score = percent * 100;
    if (score >= 90) return 'A';
    if (score >= 80) return 'B';
    if (score >= 70) return 'C';
    if (score >= 60) return 'D';
    return 'F';
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double maxWidth = constraints.maxWidth;
        double circleRadius = circleDiameter / 2;
        double circleLeft = (maxWidth * clampToZeroOne(percent)) - circleRadius;
        circleLeft = circleLeft.clamp(2.0, maxWidth - circleDiameter +12);
        double circleTop = -(circleDiameter / 2 - barHeight / 2);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                // Background bar
                Container(
                  height: barHeight,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                // Filled progress
                Container(
                  height: barHeight,
                  width: maxWidth * clampToZeroOne(percent) ,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                // Circle with grade
                Positioned(
                  left: circleLeft,
                  top: circleTop,
                  child: Container(
                    width: circleDiameter,
                    height: circleDiameter,
                    decoration: BoxDecoration(
                      color: Colors.blue[900],
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: Center(
                      child: Text(
                       grade,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            SizedBox(
              width: maxWidth,
              child: CustomPaint(
                size: Size(maxWidth, 30),
                painter: TickPainter(percent: percent, tickHeight: tickHeight),
              ),
            ),
          ],
        );
      },
    );
  }
}

class TickPainter extends CustomPainter {
  final double percent;
  final double tickHeight;

  TickPainter({required this.percent, required this.tickHeight});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 1;

    List<double> divisions = [0.0, 0.25, 0.5, 0.75, 1.0];
    double closestDivision = divisions.reduce((a, b) =>
        (a - percent).abs() < (b - percent).abs() ? a : b);

    for (double division in divisions) {
      double x = division * size.width;
      paint.color = division == closestDivision ? Colors.blue : Colors.black;
      paint.strokeWidth = division == closestDivision ? 2 : 1;

      canvas.drawLine(Offset(x, 0), Offset(x, tickHeight), paint);

      final textSpan = TextSpan(
        text: "${(division * 100).toInt()}",
        style: TextStyle(
          color: division == closestDivision ? Colors.blue : Colors.black,
          fontSize: 10,
        ),
      );
      final textPainter = TextPainter(
        text: textSpan,
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(x - textPainter.width / 2, tickHeight + 2),
      );
    }
  }

  @override
  bool shouldRepaint(TickPainter oldDelegate) =>
      oldDelegate.percent != percent || oldDelegate.tickHeight != tickHeight;
}