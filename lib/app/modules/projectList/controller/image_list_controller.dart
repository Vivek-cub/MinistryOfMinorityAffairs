import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:intl/intl.dart';
import 'package:ministry_of_minority_affairs/app/core/mixin/popup_mixin.dart';
import 'package:ministry_of_minority_affairs/app/core/mixin/snackbar_mixin.dart';
import 'package:ministry_of_minority_affairs/app/core/theme/theme_constants.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectDetails/widget/photo_viewer.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectList/data/model/image_attachment.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectList/data/model/unit_details.dart';

class ImageListController extends GetxController
    with SnackBarMixin, PopupMixin {
  Rx<UnitDetails> data = UnitDetails().obs;

  @override
  void onInit() {
    super.onInit();
    _initializeProjectData();
  }

  void _initializeProjectData() {
    final args = Get.arguments;
    if (args is Map<String, dynamic>) {
      data.value = args['unitDetails'] ?? UnitDetails();
    }
  }

  Map<String, Map<String, List<ImageAttachment>>> groupImages(
    List<ImageAttachment> attachments,
  ) {
    final Map<String, Map<String, List<ImageAttachment>>> grouped = {};

    for (final item in attachments) {
      if (item.date == null) continue;

      final dateKey = DateFormat('dd MMM yyyy').format(item.date!);

      final roleKey = item.uploadedBy ?? ' Officer';
      //final roleKey = 'Field Officer';
      debugPrint("$roleKey  ${item.uploadedBy}");

      grouped.putIfAbsent(dateKey, () => {});
      grouped[dateKey]!.putIfAbsent(roleKey, () => []);
      grouped[dateKey]![roleKey]!.add(item);
    }

    return grouped;
  }

  void openImageViewer(BuildContext context, List<String> images, int index) {
    showDialog(
      context: context,
      barrierColor: AppColors.transparent,
      builder: (_) {
        return PhotoViewer(images: images, index: index);
      },
    );
  }
}
