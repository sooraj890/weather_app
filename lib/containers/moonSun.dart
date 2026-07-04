import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/main.dart';
import '../home.dart';
import '../location.dart';

class MoonSR extends StatefulWidget {
  const MoonSR({super.key});

  @override
  State<MoonSR> createState() => _MoonSRState();
}

class _MoonSRState extends State<MoonSR> {
  String moonRise = "...";
  String moonSet = "...";

  Future<void> findMoonSR(double lat, double long) async {
    try {
      final apiKey = "bd91b801325346f3aae15855262206";

      final url = Uri.parse(
        "https://api.weatherapi.com/v1/astronomy.json"
        "?key=$apiKey"
        "&q=$lat,$long",
      );

      final response = await http.get(url);

      print("Status: ${response.statusCode}");
      print("Body: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        final astro = data['astronomy']['astro'];

        setState(() {
          moonRise = astro['moonrise'];
          moonSet = astro['moonset'];
        });
      } else {
        print("API Error: ${response.body}");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<void> loadMoonSR() async {
    try {
      Position position = await getCurrentLocation();
      await findMoonSR(position.latitude, position.longitude);
    } catch (e) {
      print("Location error: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    loadMoonSR();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        height: 200,
        width: Screen.isDesktop ? 450 : 360,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(50),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Image.asset("assets/images/moon.png", height: 80),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Moon rise", style: TextStyle(fontSize: 20)),
                Text(
                  moonRise.isEmpty ? "..." : moonRise,
                  style: TextStyle(fontSize: 15),
                ),
                SizedBox(height: 20),
                Text("Moon set", style: TextStyle(fontSize: 20)),
                Text(
                  moonSet.isEmpty ? "..." : moonSet,
                  style: TextStyle(fontSize: 15),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

String sunRise = "...";
String sunSet = "...";
DateTime riseTime = DateFormat("hh:mm a").parse(sunRise);
int sunRiseInt = riseTime.hour;

DateTime setTime = DateFormat("hh:mm a").parse(sunSet);
int sunSetInt = riseTime.hour;

class SunSR extends StatefulWidget {
  const SunSR({super.key});
  @override
  State<SunSR> createState() => _SunSRState();
}

class _SunSRState extends State<SunSR> {
  Future<void> findSunSR(double lat, double long) async {
    try {
      final apiKey = "bd91b801325346f3aae15855262206";

      final url = Uri.parse(
        "https://api.weatherapi.com/v1/astronomy.json"
        "?key=$apiKey"
        "&q=$lat,$long",
      );

      final response = await http.get(url);

      print("Status: ${response.statusCode}");
      print("Body: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        final astro = data['astronomy']['astro'];

        setState(() {
          sunRise = astro['sunrise'];
          sunSet = astro['sunset'];
        });
      } else {
        print("API Error: ${response.body}");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<void> loadSunSR() async {
    try {
      Position position = await getCurrentLocation();
      await findSunSR(position.latitude, position.longitude);
    } catch (e) {
      print("Location error: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    loadSunSR();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        width: Screen.isDesktop ? 450 : 360,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(50),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 25),
              child: Image.asset("assets/images/sun.png", height: 95),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Sun rise", style: TextStyle(fontSize: 20)),
                Text(
                  sunRise.isEmpty ? "..." : sunRise,
                  style: TextStyle(fontSize: 15),
                ),
                SizedBox(height: 20),
                Text("Sun set", style: TextStyle(fontSize: 20)),
                Text(
                  sunSet.isEmpty ? "..." : sunSet,
                  style: TextStyle(fontSize: 15),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
