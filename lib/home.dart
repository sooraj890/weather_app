import 'dart:async';
import 'package:weather_app/getTime.dart';
import 'package:weather_app/containers/moonSun.dart';
import 'package:weather_app/containers/sun_rotation.dart';
import 'package:weather_app/weather_cond/nighty.dart';
import 'package:weather_app/weather_cond/rainy.dart';
import 'package:weather_app/weather_cond/sunny.dart';
import 'package:weather_app/containers/weeklyForecast.dart';
import 'main.dart';
import 'temperature.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_app/containers/grid.dart';
import 'location.dart';
import 'package:url_launcher/url_launcher.dart';


// the error is in links where chelhar is renamed with city edit them otherwise avaibale in p1 also not works in chrome (links not working in apk version )
// links also not working in usb version
// totally change the links
String weatherCondition = "Clear"; // default
bool isLoading = true;

class Screen {
  static late double w;
  static late double h;

  static void init(BuildContext context) {
    w = MediaQuery.of(context).size.width;
    h = MediaQuery.of(context).size.height;
  }

  static bool get isTablet => w >= 600 && w < 1100;
  static bool get isDesktop => w >= 1100;
  static bool get isMobile => w < 600;
}

Widget getAnimation() {
  if (isNight) {
    return Column(children: [NightView()]);
  }

  if (weatherCondition == "Clear") {
    return Column(children: [SunnyAnimation()]);
  } else if (weatherCondition == "Rain") {
    return Column(children: [RainScreen()]);
  } else {
    return Column(children: [SunnyAnimation()]);
  }
}

class Home extends StatefulWidget {
  State<Home> createState() => _myState();
}

class _myState extends State<Home> {
  Text? str;
  var city = "Loading";
  double? temp;

  // void openLink(String url) async {
  //   final Uri uri = Uri.parse(url);
  //   if (await canLaunchUrl(uri)) {
  //     final success = await launchUrl(
  //       uri,
  //       mode: LaunchMode.externalApplication,
  //     );
  //     debugPrint(success.toString());
  //   } else {
  //     throw 'Could not launch $url';
  //   }
  // }
  Future<void> openLink(String url) async {
    final Uri uri = Uri.parse(url);

    if (!await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    )) {
      debugPrint("Could not launch: $url");
    }
  }

  Future<void> refresh() async {
    await Temp();
    setState(() {});
  }

  Future<void> Temp() async {
    setState(() {
      isLoading = true;
    });
    Position position = await getCurrentLocation();
    double t = await fetchTempByCoordinates(
      position.latitude,
      position.longitude,
    );
    if (!mounted) return;
    setState(() {
      temp = t;
      isLoading = false;
    });
  }

  Timer? timer;
  @override
  void initState() {
    super.initState();
    findCity() async {
      try {
        Position position = await getCurrentLocation();

        city = await getCityName(position.latitude, position.longitude);
        if (!mounted) return;
        setState(() {
          city=city;
        });
      } catch (e) {
        print(e);
      }
      timer = Timer.periodic(
        const Duration(seconds: 2),
            (_) {
          if (!mounted) return;
          setState(() {});
        },
      );
    }

    findCity();
    Temp();
  }

  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Screen.init(context);
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        backgroundColor: Colors.transparent,
        title: isLoading
            ? Text("")
            : Screen.isDesktop?Text(""):Screen.isTablet?Text(""):Padding(
          padding: EdgeInsets.only(right: 250),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Icon(
                Icons.location_on,
                size: Screen.isDesktop ? 40 : 20,
              ),
              Text(
                " $city",
                style: TextStyle(
                  fontSize: Screen.isDesktop ? 24 : 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: refresh,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Padding(
                      padding: EdgeInsets.only(
                        right: Screen.isMobile ? 0 : 150,
                      ),
                      child: getAnimation(),
                    ),
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding: EdgeInsets.only(
                              left: Screen.isMobile ? 30 : 200,
                              top: 120,
                            ),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.location_on,
                                      size: Screen.isDesktop ? 40 : 30,
                                    ),
                                    Text(
                                      " $city",
                                      style: TextStyle(
                                        fontSize: 26,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Column(
                                    children: [
                                      SizedBox(height: 10),
                                      Text(
                                        "$temp °C",
                                        style: TextStyle(fontSize: 35),
                                      ),
                                      Text(
                                        "Cond : $weatherCondition",
                                        style: TextStyle(fontSize: 20),
                                      ),
                                      Screen.isDesktop
                                          ? SizedBox(height: 50)
                                          : SizedBox(height: 20),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Screen.isDesktop
                            ? Wrap(
                                spacing: 100,
                                runSpacing: 50,
                                alignment: WrapAlignment.center,
                                children: [
                                  SizedBox(
                                    width: Screen.isDesktop
                                        ? 430
                                        : double.infinity,
                                    child: InkWell(
                                      onTap: () {
                                        openLink(
                                          "https://www.bing.com/search?EID=MBHSC&form=BGGCMF&pc=W011&DPC=BG00&q=$city+weather+update&PC=U316&FORM=CHROMN",
                                        );
                                      },
                                      child: GridWidget(),
                                    ),
                                  ),

                                  SizedBox(
                                    width: Screen.isDesktop
                                        ? 410
                                        : double.infinity,
                                    child: InkWell(
                                      onTap: () {
                                        openLink(
                                          "https://www.bing.com/search?go=Search&q=$city+sun+timings&qs=n&form=QBRE&sp=-1&lq=0&pq=$city+sun+&sc=11-12&sk=&cvid=D64755445CF14496A39D7F7DA469F40E",
                                        );
                                      },
                                      child: Column(
                                        children: [
                                          SizedBox(height: 200, child: SunSR()),
                                          SizedBox(height: 20),
                                          SizedBox(
                                            height: 200,
                                            child: MoonSR(),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),

                                  SizedBox(
                                    width: Screen.isDesktop
                                        ? 420
                                        : double.infinity,
                                    child: Container(
                                      height: 420,
                                      decoration: BoxDecoration(
                                        color: color,
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                      child: InkWell(
                                        onTap: () {
                                          openLink(
                                            "https://www.bing.com/search?q=$city%20rain%20forecast&qs=n&form=QBRE&sp=-1&lq=0&pq=$city%20rain%20forecast&sc=9-21&sk=&cvid=74457C5B04E0418DACBE9129C68F37F6",
                                          );
                                        },
                                        child: WeeklyForecastScreen(),
                                      ),
                                    ),
                                  ),

                                  SizedBox(
                                    width: Screen.isDesktop
                                        ? 410
                                        : double.infinity,
                                    child: InkWell(
                                      onTap: () {
                                        openLink(
                                          "https://www.bing.com/search?go=Search&q=$city+sun+timings&qs=n&form=QBRE&sp=-1&lq=0&pq=$city+sun+&sc=11-12&sk=&cvid=D64755445CF14496A39D7F7DA469F40E",
                                        );
                                      },
                                      child: SunPath(),
                                    ),
                                  ),
                                ],
                              ):Screen.isTablet?Wrap(
                          spacing: Screen.isDesktop ? 100 : (Screen.isTablet ? 40 : 20),
                          runSpacing: Screen.isDesktop ? 50 : 30,
                          alignment: WrapAlignment.center,
                          children: [
                            SizedBox(
                              width: Screen.isDesktop
                                  ? 430
                                  : Screen.isTablet
                                  ? 340
                                  : double.infinity,
                              child: InkWell(
                                onTap: () {
                                  openLink(
                                    "https://www.bing.com/search?EID=MBHSC&form=BGGCMF&pc=W011&DPC=BG00&q=$city+weather+update&PC=U316&FORM=CHROMN",
                                  );
                                },
                                child: GridWidget(),
                              ),
                            ),

                            SizedBox(
                              width: Screen.isDesktop
                                  ? 410
                                  : Screen.isTablet
                                  ? 340
                                  : double.infinity,
                              child: InkWell(
                                onTap: () {
                                  openLink(
                                    "https://www.bing.com/search?go=Search&q=$city+sun+timings&qs=n&form=QBRE&sp=-1&lq=0&pq=$city+sun+&sc=11-12&sk=&cvid=D64755445CF14496A39D7F7DA469F40E",
                                  );
                                },
                                child: Column(
                                  children: [
                                    SizedBox(height: 200, child: SunSR()),
                                    SizedBox(height: 20),
                                    SizedBox(height: 200, child: MoonSR()),
                                  ],
                                ),
                              ),
                            ),

                            SizedBox(
                              width: Screen.isDesktop
                                  ? 420
                                  : Screen.isTablet
                                  ? 340
                                  : double.infinity,
                              child: Container(
                                height: 420,
                                decoration: BoxDecoration(
                                  color: color,
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: InkWell(
                                  onTap: () {
                                    openLink(
                                      "https://www.bing.com/search?q=$city%20rain%20forecast&qs=n&form=QBRE&sp=-1&lq=0&pq=$city%20rain%20forecast&sc=9-21&sk=&cvid=74457C5B04E0418DACBE9129C68F37F6",
                                    );
                                  },
                                  child: WeeklyForecastScreen(),
                                ),
                              ),
                            ),

                            SizedBox(
                              width: Screen.isDesktop
                                  ? 410
                                  : Screen.isTablet
                                  ? 340
                                  : double.infinity,
                              child: InkWell(
                                onTap: () {
                                  openLink(
                                    "https://www.bing.com/search?go=Search&q=$city+sun+timings&qs=n&form=QBRE&sp=-1&lq=0&pq=$city+sun+&sc=11-12&sk=&cvid=D64755445CF14496A39D7F7DA469F40E",
                                  );
                                },
                                child: SunPath(),
                              ),
                            ),
                          ],
                        )
                            : Column(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      openLink(
                                        "https://www.bing.com/search?EID=MBHSC&form=BGGCMF&pc=W011&DPC=BG00&q=$city+weather+update&PC=U316&FORM=CHROMN",
                                      );
                                    },
                                    child: GridWidget(),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      openLink(
                                        "https://www.bing.com/search?go=Search&q=chelhar+sun+timings&qs=n&form=QBRE&sp=-1&lq=0&pq=$city+sun+&sc=11-12&sk=&cvid=D64755445CF14496A39D7F7DA469F40E",
                                      );
                                    },
                                    child: SunPath(),
                                  ),
                                  SizedBox(height: 20),
                                  InkWell(
                                    onTap: () {
                                      openLink(
                                        "https://www.bing.com/search?go=Search&q=$city+sun+timings&qs=n&form=QBRE&sp=-1&lq=0&pq=$city+sun+&sc=11-12&sk=&cvid=D64755445CF14496A39D7F7DA469F40E",
                                      );
                                    },
                                    child: Container(
                                      height: 200,
                                      width: Screen.isDesktop ? 410 : 360,
                                      child: SunSR(),
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  InkWell(
                                    onTap: () {
                                      openLink(
                                        "https://www.bing.com/search?go=Search&q=$city+moon+timings&qs=n&form=QBRE&sp=-1&lq=0&pq=$city+mo+timings&sc=6-18&sk=&cvid=763E46564FE7490EA9B82F4449C6F182",
                                      );
                                    },
                                    child: Container(
                                      height: 200,
                                      width: Screen.isDesktop ? 410 : 360,
                                      child: MoonSR(),
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                  //SizedBox(height: 50,),
                                  Container(
                                    height: 420,
                                    width: Screen.isDesktop ? 420 : 360,
                                    decoration: BoxDecoration(
                                      color: color,
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                    child: InkWell(
                                      onTap: () {
                                        openLink(
                                          "https://www.bing.com/search?q=$city%20rain%20forecast&qs=n&form=QBRE&sp=-1&lq=0&pq=$city%20rain%20forecast&sc=9-21&sk=&cvid=74457C5B04E0418DACBE9129C68F37F6",
                                        );
                                      },
                                      child: WeeklyForecastScreen(),
                                    ),
                                  ),
                                ],
                              ),

                        SizedBox(height: 20),
                        Divider(color: Colors.blueGrey),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Column(
                                children: [
                                  Text(
                                    "Date",
                                    style: TextStyle(
                                      fontSize: Screen.isDesktop ? 20 : 15,
                                    ),
                                  ),
                                  Text("${apiTime?.day}-${apiTime?.month}-${apiTime?.year}"),
                                ],
                              ),
                              ClipOval(
                                child: InkWell(
                                    onTap: () {
                                      openLink("https://myportfolio-42c25.web.app");
                                    },
                                    child: Image.asset("assets/profile.jpeg",height: Screen.isMobile?50:100,width: Screen.isMobile?50:100,)
                                ),
                              ),
                              InkWell(
                                  onTap: () {
                                    openLink("https://weatherapp-b286a.web.app");
                                  },
                                  child: Text("Web view",style: TextStyle(fontSize: Screen.isDesktop ? 20 : 15, color: Colors.red,fontWeight: FontWeight.bold),)
                              ),
                            ],
                          ),
                        ),
                        Screen.isDesktop
                            ? SizedBox(height: 10)
                            : SizedBox(height: 50),
                      ],
                    ),
                  ),
                  if (isLoading)
                    Container(
                      color: Colors.black.withOpacity(0.5),
                      child: Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      ),
                    ),
                ],
              ),
            ),
    );
  }
}
