import 'package:weather_app/animations/set_rise.dart';
import 'temperature.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_app/animations/sunny.dart';
import 'package:weather_app/grid.dart';
import 'animations/nighty.dart';
import 'location.dart';

String weatherCondition = "Clear"; // default
bool isLoading=true;
Widget getAnimation() {
  var hour = DateTime.now().hour;
  bool isNight = hour > 19 || hour < 7;

  if (isNight) {
    return Column(children: [NightView()]);
  }

  if (weatherCondition == "Clear") {
    return Column(children: [SunnyAnimation()]);
  }
  else {
    return Column(children: [SunnyAnimation()]);
  }
}

class Home extends StatefulWidget {
  State<Home> createState() => _myState();
}

class _myState extends State<Home> {
  Text? str;
  var city = "Location";
  double? temp;
  //late String time = DateFormat('hh:mm a').format(now);

  Future<void> refresh()async{
    await Temp();
    setState(() {

    });
  }

  Future<void> Temp()async{
    setState(() {
      isLoading=true;
    });
    Position position = await getCurrentLocation();
    double t = await fetchTempByCoordinates(position.latitude, position.longitude);
    temp = t;
    setState(() {
      isLoading=false;
    });
  }

  @override
  void initState() {
    super.initState();
    findCity() async {
      try {
        Position position = await getCurrentLocation();

        city = await getCityName(position.latitude, position.longitude);
        // 👇 IMPORTANT:
        // Replace this with your real API weather value
        setState(() {});
      } catch (e) {
        print(e);
      }
    }

    findCity();
    Temp();
  }


  // ✅ Animation Selector

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 270),
            child: Row(
              children: [
                Icon(Icons.location_on),
                Text(" $city", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,)),
              ],
            ),
          ),
        ],
      ),
      body: isLoading? Center(child: CircularProgressIndicator()):RefreshIndicator(onRefresh: refresh, child: Stack(
        children: [
          Positioned.fill(child: getAnimation()),
          SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: 40,top: 170),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text("📍 $city", style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold,)),

                        SizedBox(height: 10,),
                        Text("$temp °C",style: TextStyle(fontSize: 35),),
                        Text("$weatherCondition",style: TextStyle(fontSize: 20),),
                        SizedBox(height: 50,)
                      ],
                    ),
                  ),
                ),
                Positioned(
                    top: 350,
                    left: 17,
                    child: GridWidget()
                ),
                SunPath(),
                SizedBox(height: 30,),
                Text("Weather app created by Flutter with API support"),
                SizedBox(height: 80,)
              ],
            ),
          ),
          if (isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              ),
            ),
        ],
      ))
    );
  }
}
