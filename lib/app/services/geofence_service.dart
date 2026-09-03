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

  static bool isInsideState({
    required String detectedState,
    required String stateName,
  }) {
    return detectedState.trim().toLowerCase() == stateName.trim().toLowerCase();
  }

  static Future<String?> getStateFromPosition(Position user) async {
    try {
      final geocoding = Geocoding();

      final placemarks = await geocoding.placemarkFromCoordinates(
        user.latitude,
        user.longitude,
      );

      if (placemarks.isEmpty) {
        return null;
      }

      return placemarks.first.administrativeArea;
    } catch (e) {
      debugPrint('Failed to get state: $e');
      return null;
    }
  }
}
