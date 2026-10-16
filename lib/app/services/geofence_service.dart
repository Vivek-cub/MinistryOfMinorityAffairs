import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

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

  static Future<Placemark?> getPlacemarkFromPosition(Position user) async {
    try {
      final geocoding = Geocoding();
      final placemarks = await geocoding.placemarkFromCoordinates(
        user.latitude,
        user.longitude,
      );

      if (placemarks.isEmpty) return null;

      return placemarks.first;
    } catch (e) {
      debugPrint('Failed to reverse geocode position: $e');
      return null;
    }
  }

  static Future<String?> getStateFromPosition(Position user) async {
    final placemark = await getPlacemarkFromPosition(user);
    return placemark?.administrativeArea;
  }

  static Future<String?> getBlockFromPosition(Position user) async {
    final placemark = await getPlacemarkFromPosition(user);
    return placemark?.subAdministrativeArea;
  }

  static bool isInsideState({
    required String detectedState,
    required String stateName,
  }) {
    return normalizeName(detectedState) == normalizeName(stateName);
  }

  static bool isInsideBlock({
    required String detectedBlock,
    required String blockName,
  }) {
    final detected = normalizeName(detectedBlock);
    final expected = normalizeName(blockName);

    debugPrint('Detected Block: $detected');
    debugPrint('Expected Block: $expected');

    if (detected.isEmpty || expected.isEmpty) {
      return false;
    }

    return detected == expected ||
        detected.startsWith('$expected ') ||
        expected.startsWith('$detected ');
  }

  static String normalizeName(String value) {
    return value.trim().toLowerCase().replaceAll(RegExp(r'\s+'), ' ');
  }
}
