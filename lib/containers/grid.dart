import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:weather_app/home.dart';
import 'package:weather_app/main.dart';
import 'package:weather_app/slideAnimation.dart';
import 'package:weather_app/temperature.dart';

double sunriseDouble = 0.0;
double sunsetDouble = 0.0;
String sunrise = '';
String sunset = '';

class GridWidget extends StatefulWidget {
  @override
  State<GridWidget> createState() => _GridWidgetState();
}

class _GridWidgetState extends State<GridWidget> {
  double? rainAmount;
  int? humidityC;
  double? wind_speed;
  int? press;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    fetchWeather(city);
  }

  final apiKey = "f45a2a4f43004e214d102071eca8f9bd";

  Future<void> fetchWeather(String city) async {
    final url = Uri.parse(
      "https://api.openweathermap.org/data/2.5/weather?q=$city&units=metric&appid=$apiKey",
    );
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      DateTime sunriseTime = DateTime.fromMillisecondsSinceEpoch(
        data['sys']['sunrise'] * 1000,
        isUtc: true,
      ).toLocal();
      DateTime sunsetTime = DateTime.fromMillisecondsSinceEpoch(
        data['sys']['sunset'] * 1000,
        isUtc: true,
      ).toLocal();
      sunriseDouble = sunriseTime.hour.toDouble();
      sunsetDouble = sunsetTime.hour.toDouble();
      sunrise = DateFormat('h:mm a').format(sunriseTime);
      sunset = DateFormat('h:mm a').format(sunsetTime);

      double rain = 0;
      if (data['rain'] != null && data['rain']['1h'] != null) {
        rain = (data['rain']['1h'] as num).toDouble();
      }
      rainAmount = rain;

      humidityC = data['main']['humidity'];
      wind_speed = (data['wind']['speed'] as num).toDouble();
      press = data['main']['pressure'];
      setState(() {});
    } else {
      print("Error fetching weather");
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Screen.init(context);
    List list = [
      "🌧️\nRain\n${rainAmount ?? '--'}%",
      "💧\nHumidity\n${humidityC ?? '--'}%",
      "🌬️\nWind Speed\n${wind_speed ?? '--'} km/h",
      "🌀\nAir Pressure\n${press ?? '--'} hpa",
    ];

    return SlideInWidget(
      child: Container(
        width: Screen.isDesktop ? 420 : 380,
        padding: EdgeInsets.all(10),
        child: GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 8,
            childAspectRatio: 1,
          ),
          itemCount: list.length,
          itemBuilder: (context, index) {
            return Card(
              color: color,
              child: Center(
                child: Text(
                  list[index],
                  style: TextStyle(fontSize: 18),
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
