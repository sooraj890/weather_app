import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../location.dart';

class WeeklyForecastScreen extends StatefulWidget {
  const WeeklyForecastScreen({super.key});

  @override
  State<WeeklyForecastScreen> createState() => _WeeklyForecastScreenState();
}

class _WeeklyForecastScreenState extends State<WeeklyForecastScreen> {
  bool isLoading = true;

  List<String> dates = [];
  List<double> maxTemp = [];
  List<double> minTemp = [];
  List<int> rainChance = [];

  @override
  void initState() {
    super.initState();
    fetchForecast();
  }

  Future<void> fetchForecast() async {
    try {
      Position position = await getCurrentLocation();

      final url = Uri.parse(
        "https://api.open-meteo.com/v1/forecast"
        "?latitude=${position.latitude}"
        "&longitude=${position.longitude}"
        "&daily=temperature_2m_max,temperature_2m_min,precipitation_probability_max"
        "&timezone=auto",
      );

      final response = await http.get(url);

      print(response.body);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        setState(() {
          dates = List<String>.from(data["daily"]["time"]);
          maxTemp = List<double>.from(
            data["daily"]["temperature_2m_max"].map((e) => e.toDouble()),
          );
          minTemp = List<double>.from(
            data["daily"]["temperature_2m_min"].map((e) => e.toDouble()),
          );
          rainChance = List<int>.from(
            data["daily"]["precipitation_probability_max"],
          );

          isLoading = false;
        });
      } else {
        setState(() => isLoading = false);
      }
    } catch (e) {
      print("Error: $e");
      setState(() => isLoading = false);
    }
  }

  String formatDay(String date) {
    final dt = DateTime.parse(date);
    return DateFormat("EEE").format(dt);
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : DataTable(
            columnSpacing: 25,

            columns: const [
              DataColumn(
                label: Text(
                  "Day",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              DataColumn(
                label: Text(
                  "Max Tmp",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              DataColumn(
                label: Text(
                  "Min Tmp",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              DataColumn(
                label: Text(
                  "Rain",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],

            rows: List.generate(dates.length, (index) {
              return DataRow(
                cells: [
                  DataCell(Text(formatDay(dates[index]))),
                  DataCell(Text("${maxTemp[index].round()}°C")),
                  DataCell(Text("${minTemp[index].round()}°C")),
                  DataCell(Text("${rainChance[index]}%")),
                ],
              );
            }),
          );
  }
}
