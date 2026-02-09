
import 'package:geolocator/geolocator.dart';

class LocationService {
  static Future<Position> getAccurateLocation() async {
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
      timeLimit: const Duration(seconds: 10),
    );
  }
}
