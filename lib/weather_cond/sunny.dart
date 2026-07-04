import 'package:flutter/material.dart';
import 'package:weather_app/containers/grid.dart';

void main() {
  runApp(sunny());
}

class sunny extends StatelessWidget {
  const sunny({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: SunnyAnimation());
  }
}

class SunnyAnimation extends StatefulWidget {
  @override
  _SunnyAnimationState createState() => _SunnyAnimationState();
}

class _SunnyAnimationState extends State<SunnyAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  var time = DateTime.now();
  late var local = time.toString().substring(10, 13);
  late var dec = local;

  bool isMorEve() {
    if (sunriseDouble == 0 || sunsetDouble == 0) {
      return false;
    }

    final currentHour = DateTime.now().hour.toDouble();

    bool morning =
        currentHour >= sunriseDouble && currentHour <= sunriseDouble + 1;

    bool evening =
        currentHour >= sunsetDouble && currentHour <= sunsetDouble + 1;

    return morning || evening;
  }

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 50),
    )..repeat();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 50),
      child: Align(
        alignment: Alignment.topRight,
        child: AnimatedBuilder(
          animation: controller,
          builder: (_, __) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 150),
                  child: Icon(
                    Icons.cloud,
                    color: Colors.grey.shade300,
                    size: 40,
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 70, right: 100),
                        child: Icon(
                          Icons.cloud,
                          color: Colors.grey.shade300,
                          size: 70,
                        ),
                      ),
                    ),
                    isMorEve()
                        ? ClipRect(
                            child: Align(
                              alignment:
                                  Alignment.topCenter, // show bottom half
                              heightFactor: 0.5, // 0.5 means half of the widget
                              child: Transform.rotate(
                                angle: controller.value * 2 * 2,
                                child: Icon(
                                  Icons.wb_sunny,
                                  size: 100,
                                  color: Colors.orange,
                                ),
                              ),
                            ),
                          )
                        : Transform.rotate(
                            angle: controller.value * 2 * 2,
                            child: Icon(
                              Icons.wb_sunny,
                              size: 80,
                              color: Colors.orange,
                            ),
                          ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 70),
                  child: Icon(
                    Icons.cloud,
                    color: Colors.grey.shade200,
                    size: 50,
                  ),
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
