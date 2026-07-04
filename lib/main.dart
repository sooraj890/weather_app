import 'dart:async';
import 'package:flutter/material.dart';
import 'package:weather_app/getTime.dart';
import 'package:weather_app/containers/grid.dart';
import 'home.dart';

Color? color;
var hour = DateTime.now().hour;
bool isNight = apiTime != null
    ? apiTime!.hour > sunsetDouble.toInt() ||
          apiTime!.hour < sunriseDouble.toInt()
    : hour > 19.5 || hour < 5.5;
void main() {
  runApp(myApp());
}

class myApp extends StatefulWidget {
  @override
  State<myApp> createState() => _myAppState();
}

class _myAppState extends State<myApp> {
  bool loading = true;
  Timer? timer;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadTime();
    startClock();
  }

  void startClock() {
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (apiTime == null) return;
      setState(() {
        apiTime = apiTime!.add(const Duration(seconds: 1));
        int hour = apiTime!.hour;
        isNight = hour < 6 || hour > 19;
      });
    });
  }

  void loadTime() async {
    try {
      DateTime time = await service.getTime();
      if (!mounted) return;
      setState(() {
        apiTime = time;
        loading = false;
      });
    } catch (e) {
      print("Error: $e");

      setState(() {
        loading = false;
      });
    }
  }

  ThemeData getAppTheme() {
    if (apiTime == null) {
      return ThemeData(
        scaffoldBackgroundColor: color,
        colorScheme: ColorScheme.dark(),
      );
    }

    final int hour = apiTime!.hour;
    if (hour >= 6 && hour < 12) {
      color = Colors.orange.shade300.withOpacity(0.4);
      return ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
        scaffoldBackgroundColor: Colors.orange.shade100,
      );
    }
    if (hour >= 12 && hour < 17) {
      color = Colors.blue.shade300.withOpacity(0.4);
      return ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        scaffoldBackgroundColor: Colors.blue.shade200,
      );
    }
    if (hour >= 17 && hour < 20) {
      color = Colors.deepOrange.shade300.withOpacity(0.4);
      return ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        scaffoldBackgroundColor: Colors.orange.shade200,
      );
    }
    color = Colors.blueGrey.shade200.withOpacity(0.4);

    return ThemeData.dark().copyWith(
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.blueGrey,
        brightness: Brightness.dark,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: getAppTheme(),
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}
