import 'package:flutter/material.dart';
import 'package:weather_app/animations/nighty.dart';
import 'home.dart';

var hour = DateTime.now().hour;
bool isNight = hour > 19 || hour < 6;
void main(){
  runApp(myApp());
}
class myApp extends StatelessWidget {
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: isNight? ThemeData.dark():ThemeData.light(),
      debugShowCheckedModeBanner: false,
      home: Home()
    );
  }
}

