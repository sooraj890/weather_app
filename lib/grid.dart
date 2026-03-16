import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/location.dart';
import 'package:weather_app/animations/slideAnimation.dart';
import 'package:weather_app/temperature.dart';

class GridWidget extends StatefulWidget {
  @override
  State<GridWidget> createState() => _GridWidgetState();
}

class _GridWidgetState extends State<GridWidget> {
  double? rainAmount;
  int? humidityC;
  double? wind_speed;
  int? press;

  @override
  void initState() {
    super.initState();
    fetchWeather(city);
  }

  Future<void> fetchWeather(String city) async {
    final apiKey = "f45a2a4f43004e214d102071eca8f9bd";
    final url = Uri.parse(
      "https://api.openweathermap.org/data/2.5/weather?q=$city&units=metric&appid=$apiKey",
    );

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      double rain = 0;
      if (data['rain'] != null && data['rain']['1h'] != null) {
        rain = (data['rain']['1h'] as num).toDouble();
      }
      rainAmount = rain;

      humidityC = data['main']['humidity'];
      wind_speed = (data['wind']['speed'] as num).toDouble();
      press = data['main']['pressure'];
    } else {
      print("Error fetching weather");
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    List list = [
      "🌧️\nRain\n${rainAmount ?? '--'}%",
      "💧\nHumidity\n${humidityC ?? '--'}%",
      "🌬️\nWind Speed\n${wind_speed ?? '--'} km/h",
      "🌀\nAir Pressure\n${press ?? '--'} hpa"
    ];

    return SlideInWidget(
      child: Container(
        padding: EdgeInsets.all(8),
        child: GridView.builder(
          shrinkWrap: true, // important to let it work inside scrollable parent
          physics:
          NeverScrollableScrollPhysics(), // important if parent scrolls
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 8,
            childAspectRatio: 1,
          ),
          itemCount: list.length,
          itemBuilder: (context, index) {
            return Card(
              color: Colors.blue.withOpacity(0.1),
              child: Center(
                child: Text(
                  list[index],
                  style: TextStyle(color: Colors.white, fontSize: 18),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}