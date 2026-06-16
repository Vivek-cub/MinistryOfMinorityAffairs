import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ministry_of_minority_affairs/app/services/geofence_service.dart';
import 'package:ministry_of_minority_affairs/app/services/location_permission_service.dart';
import 'package:ministry_of_minority_affairs/app/services/location_service.dart';

mixin GeofenceMixin on GetxController {
  RxDouble get userLat;
  RxDouble get userLng;
  RxBool get isInsideFence;
  Future<bool> checkGeoFence(double lat, double lng) async {
    final granted = await LocationPermissionService.request();
    if (!granted) return false;

    final position = await LocationService.getAccurateLocation();
    userLat(position.latitude);
    userLng(position.longitude);

    if (lat == 0.0 && lng == 0.0) return true;

    isInsideFence.value = GeoFenceService.isInside(
      user: position,
      targetLat: lat,
      targetLng: lng,
      radius: 200,
    );

    debugPrint(
      "${position.latitude.toString()} ${position.longitude.toString()} ${position.altitude.toString()}",
    );
    debugPrint("Inside geo fence loaction  ${isInsideFence.value}");
    return isInsideFence.value;
  }
}
