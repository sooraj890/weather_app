import 'package:ntp/ntp.dart';
import 'package:flutter/material.dart';

class TimeService {
  Future<DateTime> getTime() async {
    try {
      DateTime time = await NTP.now();
      return time;
    } catch (e) {
      print("NTP Error: $e");
      return DateTime.now();
    }
  }
}

class TimeScreen extends StatefulWidget {
  @override
  State<TimeScreen> createState() => _TimeScreenState();
}

DateTime? apiTime;
final service = TimeService();

class _TimeScreenState extends State<TimeScreen> {
  bool loading = true;
  @override
  void initState() {
    super.initState();
    loadTime();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("NTP Time")),
      body: Text("$apiTime"),
    );
  }
}
