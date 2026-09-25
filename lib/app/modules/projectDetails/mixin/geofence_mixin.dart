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
        targetLat: lat!,
        targetLng: lng!,
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
      debugPrint("GeoFence: Lat/Lng unavailable -> checking block");

      final detectedBlock = await GeoFenceService.getBlockFromPosition(
        position,
      );

      debugPrint("Detected Block : $detectedBlock");
      debugPrint("Expected Block : $blockName");

      if (detectedBlock == null || detectedBlock.trim().isEmpty) {
        debugPrint("GeoFence: Could not detect current block");

        isInsideFence.value = false;
        return false;
      }

      isInsideFence.value = GeoFenceService.isInsideBlock(
        detectedBlock: detectedBlock,
        blockName: blockName!,
      );

      debugPrint("Block geofence result: ${isInsideFence.value}");

      return isInsideFence.value;
    }

    // ============================================================
    // CASE 3: NO LAT/LNG AND NO BLOCK
    // ============================================================
    debugPrint("GeoFence: No Lat/Lng and no Block available");

    isInsideFence.value = false;

    return false;
  }
}
