import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:intl/intl.dart';
import 'package:ministry_of_minority_affairs/app/core/mixin/popup_mixin.dart';
import 'package:ministry_of_minority_affairs/app/core/mixin/snackbar_mixin.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectDetails/data/repo/project_repository.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectList/data/model/project_details.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectList/data/model/user_project.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectList/domain/repo/project_list_repo.dart';
import 'package:ministry_of_minority_affairs/app/routes/app_routes.dart';
import 'package:ministry_of_minority_affairs/app/services/auth_service.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class CalendarProjectController extends GetxController
    with SnackBarMixin, PopupMixin {
  final ProjectListRepo repo;
  final AuthService authService;
  ProjectRepository dbRepo;
  CalendarProjectController(this.repo, this.authService, this.dbRepo);
  // Loading state
  final isLoading = false.obs;
  final RxList<UserProject> projects = <UserProject>[].obs;

  RxString selectedDate = ''.obs;
  RxString dateCount = ''.obs;
  RxString range = ''.obs;
  RxString rangeCount = ''.obs;
  RxString startDate = ''.obs;
  RxString endDate = ''.obs;

  @override
  void onInit() {
    super.onInit();

    // loadProjects();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   if (!isClosed) {

    //     loadProjects();
    //   }
    // });
  }

  void validateDate() {
    if (startDate.value == "" || endDate.value == "") {
      showErrorDialog(Get.context!, message: "Please select date range");
      return;
    }
    loadProjects();
  }

  void loadProjects() async {
    try {
      isLoading(true);

      final modelData = await repo.getProjectList(
        status: "All",
        paramName: "status",
        sectorId: "",
        year: "",
        startDate: startDate.value,
        endDate: endDate.value,
      );
      isLoading(false);
      if (modelData?.statusCode == "200") {
        if (modelData?.data != null && modelData?.data?.projects != null) {
          projects.value = modelData!.data?.projects ?? [];
        }
      } else {
        Get.snackbar("Error", "Failed to fetch dashboard data");
      }
    } catch (e) {
      throw Exception(e);
    } finally {
      isLoading(false);
    }
  }

  void onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    if (args.value is PickerDateRange) {
      range.value =
          '${DateFormat('dd/MM/yyyy').format(args.value.startDate)} -'
          ' ${DateFormat('dd/MM/yyyy').format(args.value.endDate ?? args.value.startDate)}';

      startDate(DateFormat('dd/MM/yyyy').format(args.value.startDate));
      endDate(
        DateFormat(
          'dd/MM/yyyy',
        ).format(args.value.endDate ?? args.value.startDate),
      );
    } else if (args.value is DateTime) {
      selectedDate.value = args.value.toString();
    } else if (args.value is List<DateTime>) {
      dateCount.value = args.value.length.toString();
    } else {
      rangeCount.value = args.value.length.toString();
    }
  }

  void onUpdateProgress(ProjectDetails project) {
    Get.toNamed(AppRoutes.workDetail, arguments: {"project": project});
  }
}
