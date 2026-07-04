import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(mainApps());
}

class mainApps extends StatelessWidget {
  const mainApps({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: RainScreen());
  }
}

class RainScreen extends StatefulWidget {
  @override
  State<RainScreen> createState() => _RainScreenState();
}

class _RainScreenState extends State<RainScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final Random random = Random();

  List<RainDrop> drops = [];

  @override
  void initState() {
    super.initState();

    for (int i = 0; i < 100; i++) {
      drops.add(
        RainDrop(
          x: random.nextDouble(),
          y: random.nextDouble(),
          speed: random.nextDouble() * 0.01 + 0.005,
        ),
      );
    }

    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 1))
          ..addListener(() {
            updateRain();
          })
          ..repeat();
  }

  void updateRain() {
    setState(() {
      for (var drop in drops) {
        drop.y += drop.speed;

        if (drop.y > 1) {
          drop.y = 0;
          drop.x = random.nextDouble();
        }
      }
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
      backgroundColor: Colors.black,
      body: CustomPaint(painter: RainPainter(drops), child: Container()),
    );
  }
}

class RainDrop {
  double x;
  double y;
  double speed;

  RainDrop({required this.x, required this.y, required this.speed});
}

class RainPainter extends CustomPainter {
  final List<RainDrop> drops;

  RainPainter(this.drops);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blueAccent
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    for (var drop in drops) {
      final start = Offset(drop.x * size.width, drop.y * size.height);
      final end = Offset(start.dx, start.dy + 10);

      canvas.drawLine(start, end, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
