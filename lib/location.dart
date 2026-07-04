import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

Future<Position> getCurrentLocation() async {
  bool serviceEnabled;
  LocationPermission permission;
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    throw Exception('Location services are disabled');
  }
  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      throw Exception('Location permission denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    throw Exception('Location permission permanently denied');
  }
  return await Geolocator.getCurrentPosition(
    desiredAccuracy: LocationAccuracy.high,
  );
}

Future<String> getCityName(double lat, double lon) async {
  List<Placemark> placemarks = await placemarkFromCoordinates(lat, lon);

  return placemarks.first.locality ?? "Unknown";
}
