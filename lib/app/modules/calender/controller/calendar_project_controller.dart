import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:ministry_of_minority_affairs/app/core/mixin/popup_mixin.dart';
import 'package:ministry_of_minority_affairs/app/core/mixin/snackbar_mixin.dart';
import 'package:ministry_of_minority_affairs/app/modules/calender/views/image_gallary_sheet.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectDetails/data/repo/project_repository.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectList/data/model/image_attachment.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectList/data/model/unit_details.dart';
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
  Rx<UnitDetails> data = UnitDetails().obs;
  RxString projectStatus = "".obs;
  // final RxList<DateTime> imageAttachmentDates = <DateTime>[].obs;
  RxList<String> imageList = <String>[].obs;
  final Set<String> _imageAttachmentDateKeys = <String>{};

  final RxMap<DateTime, List<ImageAttachment>> attachmentMap =
      <DateTime, List<ImageAttachment>>{}.obs;

  Set<DateTime> get imageAttachmentDates => attachmentMap.keys.toSet();
  final DateRangePickerController pickerController =
      DateRangePickerController();

  @override
  void onInit() {
    super.onInit();
    _initializeProjectData();
    // loadProjects();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   if (!isClosed) {

    //     loadProjects();
    //   }
    // });
  }

  void _initializeProjectData() {
    final args = Get.arguments;
    if (args is Map<String, dynamic>) {
      data.value = args['project'] ?? UnitDetails();
      projectStatus.value = args['status'];
    }
    _loadImageAttachmentDates();
  }

  // void _loadImageAttachmentDates() {
  //   final dates = <DateTime>[];
  //   _imageAttachmentDateKeys.clear();

  // for (final milestone in data.value.milestones ?? []) {
  //   for (final attachment in milestone.imageAtt ?? []) {
  //     if (attachment.images == null || attachment.images!.isEmpty) {
  //       continue;
  //     }

  //     final date = Helpers().parseAttachmentDate(attachment.date);
  //     if (date == null) continue;

  //     final normalized = Helpers().dateOnly(date);
  //     final key = Helpers().dateKey(normalized);
  //     if (_imageAttachmentDateKeys.add(key)) {
  //       dates.add(normalized);
  //     }
  //   }
  // }

  //   dates.sort((a, b) => a.compareTo(b));
  //   imageAttachmentDates.assignAll(dates);
  // }

  // bool hasImageAttachmentOnDate(DateTime date) {
  //   return _imageAttachmentDateKeys.contains(Helpers().dateKey(date));
  // }

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

  // void onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
  //   if (args.value is! DateTime) return;

  //   final selectedDate = Helpers().dateOnly(args.value as DateTime);

  //   // for (final milestone in data.value.milestones ?? []) {
  //   //   for (final attachment in milestone.imageAtt ?? []) {
  //   //     final attachmentDate = Helpers().parseAttachmentDate(attachment.date);

  //   //     if (attachmentDate == null) continue;

  //   //     if (Helpers().dateOnly(attachmentDate) == selectedDate) {
  //   //       // imageList.value = attachment.image ?? [];
  //   //       Get.bottomSheet(
  //   //         ImageGallerySheet(images: attachment.images ?? []),
  //   //         isScrollControlled: true,
  //   //       );
  //   //       return;
  //   //     }
  //   //   }
  //   // }

  //   // if (args.value is PickerDateRange) {
  //   //   final selectedRange = args.value as PickerDateRange;
  //   //   final start = selectedRange.startDate;
  //   //   final end = selectedRange.endDate ?? start;
  //   //   if (start == null) return;

  //   //   range.value =
  //   //       '${DateFormat('dd/MM/yyyy').format(start)} -'
  //   //       ' ${DateFormat('dd/MM/yyyy').format(end)}';

  //   //   startDate(DateFormat('dd/MM/yyyy').format(start));
  //   //   endDate(DateFormat('dd/MM/yyyy').format(end));
  //   // } else if (args.value is DateTime) {
  //   //   selectedDate.value = args.value.toString();
  //   // } else if (args.value is List<DateTime>) {
  //   //   dateCount.value = args.value.length.toString();
  //   // } else {
  //   //   rangeCount.value = args.value.length.toString();
  //   // }
  // }

  void onUpdateProgress(UnitDetails project) {
    Get.toNamed(AppRoutes.workDetail, arguments: {"project": project});
  }

  bool hasImageAttachmentOnDate(DateTime date) {
    final normalized = DateTime(date.year, date.month, date.day);

    return attachmentMap.containsKey(normalized);
  }

  void onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    if (args.value is! DateTime) return;

    final selectedDate = DateTime(
      args.value.year,
      args.value.month,
      args.value.day,
    );

    final attachments = attachmentMap[selectedDate];

    if (attachments == null || attachments.isEmpty) return;
    Get.bottomSheet(
      ImageGallerySheet(
        images:
            attachments
                .map((e) => e.images ?? '')
                .where((e) => e.isNotEmpty)
                .toList(),
      ),
      isScrollControlled: true,
    ).whenComplete(() {
      pickerController.selectedDate = null;
    });
  }

  void _loadImageAttachmentDates() {
    attachmentMap.clear();

    for (final attachment in data.value.imageAtt ?? []) {
      if (attachment.date == null) continue;

      final date = DateTime(
        attachment.date!.year,
        attachment.date!.month,
        attachment.date!.day,
      );

      attachmentMap.putIfAbsent(date, () => []);
      attachmentMap[date]!.add(attachment);
    }
  }
}
