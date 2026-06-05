import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:ministry_of_minority_affairs/app/core/mixin/popup_mixin.dart';
import 'package:ministry_of_minority_affairs/app/core/mixin/snackbar_mixin.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectList/data/model/project_details.dart';
import 'package:ministry_of_minority_affairs/app/modules/proposals/domain/repo/update_proposal_latlng_repo.dart';
import 'package:ministry_of_minority_affairs/app/routes/app_routes.dart';
import 'package:ministry_of_minority_affairs/app/services/auth_service.dart';

class UpdateProposalLatlngController extends GetxController
    with SnackBarMixin, PopupMixin {
  final UpdateProposalLatlngRepo repo;
  final AuthService authService;
  Rx<ProjectDetails> data = ProjectDetails().obs;

  UpdateProposalLatlngController(this.repo, this.authService);

  final isLoading = false.obs;
  RxString projectStatus = "".obs;
  RxDouble currentLat = 0.0.obs;
  RxDouble currentLng = 0.0.obs;
  Rx<LatLng?> currentLocation = Rx<LatLng?>(null);

  @override
  void onInit() {
    super.onInit();
    _initializeProject();
    getCurrentLocation();
  }

  void _initializeProject() {
    final args = Get.arguments;
    if (args is Map<String, dynamic>) {
      data.value = args['project'] ?? ProjectDetails();
      projectStatus.value = args['status'];
    }
  }

  Future<void> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      return;
    }

    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      return;
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    print(position.latitude);
    print(position.longitude);

    // VERY IMPORTANT
    if (position.latitude.isFinite && position.longitude.isFinite) {
      currentLocation.value = LatLng(position.latitude, position.longitude);
      currentLat.value = position.latitude;
      currentLng.value = position.longitude;
    }
  }

  Future<void> submitLocation() async {
    try {
      showAlertCustom(backBtnDisable: true, title: "Updating Location");
      final modelData = await repo.updateProposalLatlng(
        projectId: data.value.id ?? "",
        lat: currentLat.value.toString(),
        lng: currentLng.value.toString(),
      );

      if (modelData?.statusCode == "200") {
        if (Get.isDialogOpen == true) {
          Get.back();
        }
        await Get.offAllNamed(AppRoutes.home);
      }
    } catch (e) {
      if (Get.isDialogOpen == true) {
        Get.back();
      }
    } finally {}
  }
}
