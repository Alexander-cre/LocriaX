import 'dart:async';
import 'package:flutter/material.dart';
import 'main_tabs.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    )..forward();

    // Navigate after animation
    Timer(const Duration(milliseconds: 2700), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const MainTabs()),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF3B0764), Color(0xFF8B5CF6)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: CustomPaint(
            size: const Size(300, 100),
            painter: _TextStrokePainter(animation: _controller),
          ),
        ),
      ),
    );
  }
}

class _TextStrokePainter extends CustomPainter {
  final Animation<double> animation;
  _TextStrokePainter({required this.animation}) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    const text = "Vibe AI";

    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          fontFamily: 'GreatVibes',
          fontSize: 64,
          foreground: Paint()
            ..color = Colors.cyanAccent
            ..strokeWidth = 2
            ..style = PaintingStyle.stroke
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3),
        ),
      ),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();

    // Fade-in opacity animation
    final fadePaint = Paint()
      ..color = Colors.cyanAccent.withOpacity(animation.value)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

    canvas.saveLayer(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint(),
    );

    // Paint text with fade animation
    textPainter.paint(canvas, Offset.zero);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
