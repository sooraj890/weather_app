import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';


class SunArcPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {

    Paint paint = Paint()
      ..color = Colors.grey.shade100
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    Rect rect = Rect.fromLTWH(0, 0, size.width, size.height * 2);

    canvas.drawArc(
      rect,
      pi,        // start angle
      pi,        // sweep angle (half circle)
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
class SunPath extends StatefulWidget {
  @override
  _SunPathState createState() => _SunPathState();
}



class _SunPathState extends State<SunPath> {

  DateTime now = DateTime.now();
  String? con;
  cond(){
    if(now.hour >= 5 && now.hour <12){
      con="Morning";
    }else if(now.hour >=12 && now.hour <16){
      con="Noon";
    }else if(now.hour >= 16 && now.hour <= 19){
      con="Evening";
    }else{
      con="Night";
    }
  }
  @override
  void initState() {
    super.initState();
    cond();
    Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        now = DateTime.now();
      });
    });
  }

  @override
  Widget build(BuildContext context) {

    double width = 300;
    double radius = width / 2;

    double sunrise = 6;
    double sunset = 18;

    double currentHour = now.hour + now.minute / 60;

    double progress = ((currentHour - sunrise) / (sunset - sunrise))
        .clamp(0.0, 1.0);

    double angle = pi * (1 - progress);

    double x = radius + radius * cos(angle);
    double y = radius - radius * sin(angle);

    return Container(
      height: 180,
      width: 350,
      color: Colors.blue.withOpacity(0.5),
      child: Center(
          child: SizedBox(
            width: width,
            height: radius,
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: CustomPaint(
                    size: Size(300,150),
                    painter: SunArcPainter(),
                  ),
                ),
                // Sun
                Positioned(
                  left: x - 22,
                  top: y - 15,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child:
                      now.hour >= 6 && now.hour <= 19 ?
                      Icon(Icons.wb_sunny,color: Colors.yellow,):Icon(Icons.nights_stay_sharp,color: Colors.grey,)
                    ),
                  ),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("$con"),
                      StreamBuilder(
                        stream: Stream.periodic(Duration(seconds: 1), (_) => DateTime.now()),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) return Text("--:--");
                  
                          final now = snapshot.data as DateTime;
                  
                          int hour = now.hour;
                          String period = hour >= 12 ? "PM" : "AM";
                  
                          hour = hour % 12;
                          if (hour == 0) hour = 12;
                  
                          final minute = now.minute.toString().padLeft(2, '0');
                  
                          return Text(
                            "$hour:$minute $period",
                            style: TextStyle(fontSize: 25),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
      ),
    );
  }
}