import 'package:geolocator/geolocator.dart';

import 'package:geolocator/geolocator.dart';

class LocationService {
  static Future<Position> getAccurateLocation() async {
    // 1. Check whether location services are enabled
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      throw Exception(
        'Location services are disabled. Please enable GPS and try again.',
      );
    }

    // 2. Check existing permission
    LocationPermission permission = await Geolocator.checkPermission();

    // 3. Request permission if not already granted
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    // 4. Handle denied permission
    if (permission == LocationPermission.denied) {
      throw Exception(
        'Location permission denied. Please allow location access.',
      );
    }

    // 5. Handle permanently denied permission
    if (permission == LocationPermission.deniedForever) {
      await Geolocator.openAppSettings();

      throw Exception(
        'Location permission is permanently denied. '
        'Please enable it in App Settings.',
      );
    }

    // 6. Get the current position
    return await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.bestForNavigation,
        timeLimit: Duration(seconds: 30),
      ),
    );
  }
}
