import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:ministry_of_minority_affairs/app/services/geofence_service.dart';

mixin GeofenceMixin on GetxController {
  RxDouble get userLat;
  RxDouble get userLng;
  RxBool get isInsideFence;
  Future<bool> checkGeoFence({
    required double? lat,
    required double? lng,
    required String? blockName,
    required String? stateName,
    required Position position,
  }) async {
    userLat.value = position.latitude;
    userLng.value = position.longitude;

    final hasLatLng = lat != null && lng != null && lat != 0.0 && lng != 0.0;

    final hasBlock = blockName != null && blockName.trim().isNotEmpty;

    // ============================================================
    // CASE 1: LAT/LNG AVAILABLE
    // Check 200 meter radius
    // ============================================================
    if (hasLatLng) {
      debugPrint("GeoFence: Lat/Lng available -> checking 200m radius");

      isInsideFence.value = GeoFenceService.isInside(
        user: position,
        targetLat: lat,
        targetLng: lng,
        radius: 200,
      );

      debugPrint("GeoFence 200m result: ${isInsideFence.value}");

      return isInsideFence.value;
    }

    // ============================================================
    // CASE 2: NO LAT/LNG BUT BLOCK AVAILABLE
    // Check block
    // ============================================================
    if (hasBlock) {
      debugPrint('GeoFence: Checking state and block');

      final placemark = await GeoFenceService.getPlacemarkFromPosition(
        position,
      );

      if (placemark == null) {
        debugPrint('GeoFence: Could not detect location details');
        isInsideFence.value = false;
        return false;
      }

      final detectedState = placemark.administrativeArea;
      final detectedBlock = placemark.subAdministrativeArea;

      debugPrint('Detected State: $detectedState');
      debugPrint('Expected State: $stateName');
      debugPrint('Detected Block: $detectedBlock');
      debugPrint('Expected Block: $blockName');

      // Validate state first.
      if (stateName == null ||
          stateName.trim().isEmpty ||
          detectedState == null ||
          !GeoFenceService.isInsideState(
            detectedState: detectedState,
            stateName: stateName,
          )) {
        debugPrint('GeoFence: State validation failed');
        isInsideFence.value = false;
        return false;
      }

      // Validate block only after state matches.
      if (detectedBlock == null ||
          detectedBlock.trim().isEmpty ||
          !GeoFenceService.isInsideBlock(
            detectedBlock: detectedBlock,
            blockName: blockName!,
          )) {
        debugPrint('GeoFence: Block validation failed');
        isInsideFence.value = false;
        return false;
      }

      isInsideFence.value = true;
      debugPrint('GeoFence: State and block validation passed');

      return true;
    }

    // ============================================================
    // CASE 3: NO LAT/LNG AND NO BLOCK
    // ============================================================
    debugPrint("GeoFence: No Lat/Lng and no Block available");

    isInsideFence.value = false;

    return false;
  }
}
