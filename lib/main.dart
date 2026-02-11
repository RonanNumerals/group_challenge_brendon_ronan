import 'package:flutter/material.dart';
import 'dart:math';

void main() => runApp(const ValentineApp());

class ValentineApp extends StatelessWidget {
  const ValentineApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const ValentineHome(),
      theme: ThemeData(useMaterial3: true),
    );
  }
}

class ValentineHome extends StatefulWidget {
  const ValentineHome({super.key});

  @override
  State<ValentineHome> createState() => _ValentineHomeState();
}

class _ValentineHomeState extends State<ValentineHome>
    with SingleTickerProviderStateMixin {

  final List<String> emojiOptions = ['Sweet Heart', 'Party Heart'];
  String selectedEmoji = 'Sweet Heart';

  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
      lowerBound: 0.95,
      upperBound: 1.05,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Cupid's Canvas")),
      body: Column(
        children: [
          const SizedBox(height: 16),
          DropdownButton<String>(
            value: selectedEmoji,
            items: emojiOptions
                .map((e) =>
                    DropdownMenuItem(value: e, child: Text(e)))
                .toList(),
            onChanged: (value) =>
                setState(() => selectedEmoji = value ?? selectedEmoji),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Center(
              child: AnimatedBuilder(
                animation: _pulseController,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _pulseController.value,
                    child: CustomPaint(
                      size: const Size(300, 300),
                      painter:
                          HeartEmojiPainter(type: selectedEmoji),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      )
    );
  }
}

class HeartEmojiPainter extends CustomPainter {
  final String type;
  HeartEmojiPainter({required this.type});

  @override
  void paint(Canvas canvas, Size size) {
    final center =
        Offset(size.width / 2, size.height / 2);

    final paint = Paint()..style = PaintingStyle.fill;

    // Heart Shape
    final heartPath = Path()
      ..moveTo(center.dx, center.dy + 60)
      ..cubicTo(center.dx + 110, center.dy - 10,
          center.dx + 60, center.dy - 120,
          center.dx, center.dy - 40)
      ..cubicTo(center.dx - 60, center.dy - 120,
          center.dx - 110, center.dy - 10,
          center.dx, center.dy + 60)
      ..close();

    // Different color = different emoji
    paint.color =
        type == 'Party Heart'
            ? const Color(0xFFF48FB1)
            : const Color(0xFFE91E63);

    canvas.drawPath(heartPath, paint);

    // Face
    final eyePaint = Paint()..color = Colors.white;
    canvas.drawCircle(
        Offset(center.dx - 30, center.dy - 10), 10, eyePaint);
    canvas.drawCircle(
        Offset(center.dx + 30, center.dy - 10), 10, eyePaint);

    final pupilPaint = Paint()..color = Colors.black;
    canvas.drawCircle(
        Offset(center.dx - 28, center.dy - 8), 4, pupilPaint);
    canvas.drawCircle(
        Offset(center.dx + 32, center.dy - 8), 4, pupilPaint);

    final mouthPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;

    canvas.drawArc(
      Rect.fromCircle(
          center: Offset(center.dx, center.dy + 20), radius: 30),
      0,
      pi,
      false,
      mouthPaint,
    );

    // Party Hat (For Party Heart Only)
    if (type == 'Party Heart') {
      final hatPaint = Paint()
        ..color = const Color(0xFFFFD54F);

      final hatPath = Path()
        ..moveTo(center.dx, center.dy - 110)
        ..lineTo(center.dx - 40, center.dy - 40)
        ..lineTo(center.dx + 40, center.dy - 40)
        ..close();

      canvas.drawPath(hatPath, hatPaint);
    }
  }

  @override
  bool shouldRepaint(covariant HeartEmojiPainter oldDelegate) =>
      oldDelegate.type != type;
}
