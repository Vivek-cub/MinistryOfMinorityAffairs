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

  List<ImageAttachmentGroup> groupImages(
    List<ImageAttachment> attachments,
  ) {
    final groups = <ImageAttachmentGroup>[];

    for (final item in attachments) {
      if (item.date == null) continue;

      final dateKey = DateFormat('dd MMM yyyy').format(item.date!);
      final progressKey = _cleanText(item.progress);
      final statusKey = _cleanText(item.status);
      final roleKey = _cleanText(item.uploadedBy) ?? 'Officer';

      final group = groups.firstWhere(
        (group) =>
            group.date == dateKey &&
            group.progress == progressKey &&
            group.status == statusKey,
        orElse: () {
          final newGroup = ImageAttachmentGroup(
            date: dateKey,
            progress: progressKey,
            status: statusKey,
          );
          groups.add(newGroup);
          return newGroup;
        },
      );

      group.roleGroups.putIfAbsent(roleKey, () => []);
      group.roleGroups[roleKey]!.add(item);
    }

    return groups;
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

  String? _cleanText(String? value) {
    final text = value?.trim();
    if (text == null || text.isEmpty) return null;
    return text;
  }
}

class ImageAttachmentGroup {
  final String date;
  final String? progress;
  final String? status;
  final Map<String, List<ImageAttachment>> roleGroups = {};

  ImageAttachmentGroup({
    required this.date,
    required this.progress,
    required this.status,
  });
}
