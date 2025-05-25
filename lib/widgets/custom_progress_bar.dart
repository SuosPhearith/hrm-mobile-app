import 'package:flutter/material.dart';

class CustomProgressBar extends StatelessWidget {
  final double percent; // 0.0 to 1.0
  final String grade;

  const CustomProgressBar(
      {super.key, required this.percent, required this.grade});

  @override
  Widget build(BuildContext context) {
    double maxWidth = MediaQuery.of(context).size.width - 32;
    // Subtract padding if needed (16 left + 16 right)

    double circleDiameter = 25.0;
    double circleRadius = circleDiameter / 2;

// Clamp so the circle stays inside
    double circleLeft = (maxWidth * percent) - circleRadius;
    circleLeft = circleLeft.clamp(0.0, maxWidth - circleDiameter);
    // Calculate top dynamically:
    double barHeight = 10.0;
    double circleTop = -(circleDiameter / 2 - barHeight / 2);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          clipBehavior: Clip.none, // <--- important to allow 'outside' drawing
          children: [
            // progress bar
            Container(
              height: 10,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            // filled progress
            Container(
              height: 10,
              width: maxWidth * percent,
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            // Circle B floating outside
            Positioned(
              left: (maxWidth * percent) - (circleDiameter / 2),
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
            painter: TickPainter(percent: percent),
          ),
        ),
      ],
    );
  }

  String getGradeLetter(double percent) {
    double score = percent * 100;

    if (score >= 90) return 'A';
    if (score >= 80) return 'B';
    if (score >= 70) return 'C';
    if (score >= 60) return 'D';
    return 'F';
  }
}

class TickPainter extends CustomPainter {
  final double percent;

  TickPainter({required this.percent});

  @override
  void paint(Canvas canvas, Size size) {
    double tickHeight = 5;
    // double textOffset = 14;

    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 1;

    // 5 divisions (0%, 25%, 50%, 75%, 100%)
    List<double> divisions = [0.0, 0.25, 0.5, 0.75, 1.0];

    for (double division in divisions) {
      double x = division * size.width;

      // Draw the tick
      canvas.drawLine(Offset(x, 0), Offset(x, tickHeight), paint);

      // Draw the percentage text
      final textSpan = TextSpan(
        text: "${(division * 100).toInt()}",
        style: const TextStyle(
          color: Colors.black,
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
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
