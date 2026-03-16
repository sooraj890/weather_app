import 'package:flutter/material.dart';
import 'dart:math';

class SunnyAnimation extends StatefulWidget {
  @override
  _SunnyAnimationState createState() => _SunnyAnimationState();
}

class _SunnyAnimationState extends State<SunnyAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  bool isTrue=false;
  var time=DateTime.now();
  late var local=time.toString().substring(10,13);
  late var dec=local;
  check(){
    if(time.hour > 6 && time.hour < 8 || time.hour > 18 && time.hour < 20){
      isTrue=true;
    }
    setState(() {

    });
  }
  @override
  void initState() {
    super.initState();
    controller =
    AnimationController(vsync: this, duration: Duration(seconds: 50))
      ..repeat();
    check();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 50,top: 50),
      child: Align(
        alignment: Alignment.topRight,
        child: AnimatedBuilder(
          animation: controller,
          builder: (_, __) {
            return Column(
              children: [
                Row(
                  children: [
                    Expanded(child: Padding(
                      padding: const EdgeInsets.only(bottom: 70, right: 100),
                      child: Icon(Icons.cloud,color: Colors.grey.shade300,size: 70,),
                    )),
                    isTrue? ClipRect(
                      child: Align(
                        alignment: Alignment.topCenter, // show bottom half
                        heightFactor: 0.5, // 0.5 means half of the widget
                        child: Transform.rotate(
                          angle: controller.value * 2 * 2,
                          child: Icon(Icons.wb_sunny, size: 100, color: Colors.orange),
                        ),
                      ),
                    ):Transform.rotate(
                      angle: controller.value * 2 * 2,
                      child: Icon(Icons.wb_sunny, size: 80, color: Colors.orange),
                    ),

                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 70),
                  child: Icon(Icons.cloud,color: Colors.grey.shade200,size: 50,),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

