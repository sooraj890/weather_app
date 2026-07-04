import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/location.dart';
import 'package:geolocator/geolocator.dart';

const String apiKey = "f45a2a4f43004e214d102071eca8f9bd";
String city = "hyderabad";
Future<double> fetchTempByCity(String cityName) async {
  final url = Uri.parse(
    "https://api.openweathermap.org/data/2.5/weather?q=$cityName&units=metric&appid=$apiKey",
  );

  final response = await http.get(url);
  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    return data['main']['temp'].toDouble();
  } else {
    throw Exception("Failed to fetch temperature");
  }
}

Future<double> fetchTempByCoordinates(double lat, double lon) async {
  final url = Uri.parse(
    "https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&units=metric&appid=$apiKey",
  );

  final response = await http.get(url);

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    return data['main']['temp'].toDouble();
  } else {
    throw Exception("Failed to fetch temperature");
  }
}

class TempPage extends StatefulWidget {
  @override
  State<TempPage> createState() => _TempPageState();
}

class _TempPageState extends State<TempPage> {
  double? temp;
  Future<void> loadTemp() async {
    try {
      Position position = await getCurrentLocation();

      String cityName = await getCityName(
        position.latitude,
        position.longitude,
      );
      double t = await fetchTempByCoordinates(
        position.latitude,
        position.longitude,
      );
      setState(() {
        city = cityName;
        temp = t;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    loadTemp();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return temp == null
        ? CircularProgressIndicator()
        : Text("$temp °C", style: TextStyle(fontSize: 22));
  }
}
