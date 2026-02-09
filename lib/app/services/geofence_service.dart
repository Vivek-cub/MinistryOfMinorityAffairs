
import 'package:geolocator/geolocator.dart';

class GeoFenceService {
  static bool isInside({
    required Position user,
    required double targetLat,
    required double targetLng,
    double radius = 120,
  }) {
    final distance = Geolocator.distanceBetween(
      user.latitude,
      user.longitude,
      targetLat,
      targetLng,
    );

    return distance <= radius;
  }
}
