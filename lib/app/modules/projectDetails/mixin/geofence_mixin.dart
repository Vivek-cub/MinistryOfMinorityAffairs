import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ministry_of_minority_affairs/app/services/geofence_service.dart';
import 'package:ministry_of_minority_affairs/app/services/location_permission_service.dart';
import 'package:ministry_of_minority_affairs/app/services/location_service.dart';

mixin GeofenceMixin on GetxController {
  RxDouble get userLat;
  RxDouble get userLng;
  RxBool get isInsideFence;
  Future<bool> checkGeoFence(double lat, double lng, String stateName) async {
    debugPrint("1. before Gepfence");
    final granted = await LocationPermissionService.request();
    if (!granted) return false;
    debugPrint("1. After permission");
    final position = await LocationService.getAccurateLocation();
    userLat(position.latitude);
    userLng(position.longitude);
    debugPrint("1. After location");
    if (lat == 0.0 && lng == 0.0) {
      String? state = await GeoFenceService.getStateFromPosition(position);
      isInsideFence.value = GeoFenceService.isInsideState(
        detectedState: state ?? "",
        stateName: stateName,
      );
      debugPrint(state);
    } else {
      isInsideFence.value = GeoFenceService.isInside(
        user: position,
        targetLat: lat,
        targetLng: lng,
        radius: 200,
      );
    }

    debugPrint(
      "${position.latitude.toString()} ${position.longitude.toString()} ${position.altitude.toString()}",
    );
    debugPrint("Inside geo fence loaction  ${isInsideFence.value}");
    return isInsideFence.value;
  }
}
