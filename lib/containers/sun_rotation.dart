import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:weather_app/getTime.dart';
import 'package:weather_app/containers/grid.dart';
import '../home.dart';
import '../main.dart';

class SunArcPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blueGrey
      ..style = PaintingStyle.stroke
      ..strokeWidth = 9;

    final rect = Rect.fromLTWH(0, 0, size.width, size.height * 2);

    canvas.drawArc(
      rect,
      pi,
      pi,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class SunPath extends StatefulWidget {
  @override
  State<SunPath> createState() => _SunPathState();
}

class _SunPathState extends State<SunPath> {
  String? con;
  DateTime? apiTime;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    loadTime();

    timer = Timer.periodic(const Duration(seconds: 30), (_) {
      loadTime();
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future<void> loadTime() async {
    try {
      final time = await service.getTime();

      if (!mounted) return;

      setState(() {
        apiTime = time;
        updateCondition();
      });
    } catch (e) {
      debugPrint("Error: $e");
    }
  }

  void updateCondition() {
    if (apiTime == null) return;

    if (apiTime!.hour >= sunriseDouble && apiTime!.hour < 12) {
      con = "Morning";
    } else if (apiTime!.hour >= 12 && apiTime!.hour < 16) {
      con = "Noon";
    } else if (apiTime!.hour >= 16 && apiTime!.hour <= sunsetDouble) {
      con = "Evening";
    } else {
      con = "Night";
    }
  }

  @override
  Widget build(BuildContext context) {
    if (apiTime == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final width = 300.0;
    final radius = width / 2;

    final sunrise = sunriseDouble;
    final sunset = sunsetDouble + 1;

    final currentHour = apiTime!.hour + apiTime!.minute / 60;

    final progress = ((currentHour - sunrise) / (sunset - sunrise))
        .clamp(0.0, 1.0);

    final angle = pi * (1 - progress);

    final x = radius + radius * cos(angle);
    final y = radius - radius * sin(angle);

    final day = sunsetDouble - sunriseDouble;
    final night = 24 - day;

    return Container(
      height: 250,
      width: Screen.isDesktop ? 400 : 360,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(50),
      ),
      child: Stack(
        children: [
          Column(
            children: [
              Padding(
                padding: EdgeInsets.only(left:Screen.isMobile?30:Screen.isTablet?25:50,top: 30, ),
                child: SizedBox(
                  width: width,
                  height: radius,
                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 5,),
                        child: CustomPaint(
                          size: const Size(300, 150),
                          painter: SunArcPainter(),
                        ),
                      ),

                      Positioned(
                        left: x - 12,
                        top: y - 10,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: const Icon(
                            Icons.sunny,
                            size: 25,
                            color: Colors.yellow,
                          ),
                        ),
                      ),

                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              con ?? "",
                              style: const TextStyle(fontSize: 15),
                            ),
                            Text(
                              "${(apiTime!.hour % 12 == 0 ? 12 : apiTime!.hour % 12)}:"
                                  "${apiTime!.minute.toString().padLeft(2, '0')} "
                                  "${apiTime!.hour >= 12 ? 'PM' : 'AM'}",
                              style: const TextStyle(fontSize: 25),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          Positioned(
            top: 200,
            left: 30,
            right: 30,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Day : $day hrs", style: const TextStyle(fontSize: 17)),
                Text("Night : $night hrs", style: const TextStyle(fontSize: 17)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}