import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ministry_of_minority_affairs/app/modules/home/controllers/home_controller.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectList/data/model/project_milestone.dart';
import 'package:ministry_of_minority_affairs/app/routes/app_routes.dart';
import 'package:ministry_of_minority_affairs/app/services/auth_service.dart';
import 'package:ministry_of_minority_affairs/app/utils/network_constants.dart';
import 'package:path_provider/path_provider.dart';

/// Utility helper functions
class Helpers {
  static const MethodChannel _exifChannel = MethodChannel('app.exif');

  // ==================== Date & Time ====================

  /// Format date to dd/MM/yyyy
  static String formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  /// Format date to dd MMM yyyy (e.g., 15 Jan 2024)
  static String formatDateMedium(DateTime date) {
    return DateFormat('dd MMM yyyy').format(date);
  }

  /// Format date to full format (e.g., 15 January 2024)
  static String formatDateFull(DateTime date) {
    return DateFormat('dd MMMM yyyy').format(date);
  }

  /// Format time to HH:mm (e.g., 14:30)
  static String formatTime(DateTime time) {
    return DateFormat('HH:mm').format(time);
  }

  /// Format date and time
  static String formatDateTime(DateTime dateTime) {
    return DateFormat('dd/MM/yyyy HH:mm').format(dateTime);
  }

  /// Get relative time (e.g., 2 hours ago)
  static String getRelativeTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inSeconds < 60) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return '$weeks week${weeks > 1 ? 's' : ''} ago';
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return '$months month${months > 1 ? 's' : ''} ago';
    } else {
      final years = (difference.inDays / 365).floor();
      return '$years year${years > 1 ? 's' : ''} ago';
    }
  }

  // ==================== Validation ====================

  /// Validate email
  static bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  /// Validate phone number (Indian)
  static bool isValidIndianPhone(String phone) {
    return RegExp(r'^[6-9]\d{9}$').hasMatch(phone);
  }

  /// Validate Aadhaar number
  static bool isValidAadhaar(String aadhaar) {
    return RegExp(r'^\d{12}$').hasMatch(aadhaar.replaceAll(' ', ''));
  }

  /// Validate PAN number
  static bool isValidPAN(String pan) {
    return RegExp(r'^[A-Z]{5}[0-9]{4}[A-Z]{1}$').hasMatch(pan.toUpperCase());
  }

  // ==================== Snackbars & Dialogs ====================

  /// Show success snackbar
  static void showSuccess(String message) {
    Get.snackbar(
      'Success',
      message,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.all(16),
      borderRadius: 8,
    );
  }

  /// Show error snackbar
  static void showError(String message) {
    Get.snackbar(
      'Error',
      message,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 4),
      margin: const EdgeInsets.all(16),
      borderRadius: 8,
    );
  }

  /// Show info snackbar
  static void showInfo(String message) {
    Get.snackbar(
      'Info',
      message,
      backgroundColor: Colors.blue,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.all(16),
      borderRadius: 8,
    );
  }

  /// Show warning snackbar
  static void showWarning(String message) {
    Get.snackbar(
      'Warning',
      message,
      backgroundColor: Colors.orange,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.all(16),
      borderRadius: 8,
    );
  }

  /// Show confirmation dialog
  static Future<bool> showConfirmDialog({
    required String title,
    required String message,
    String confirmText = 'Yes',
    String cancelText = 'No',
  }) async {
    return await Get.dialog<bool>(
          AlertDialog(
            title: Text(title),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () => Get.back(result: false),
                child: Text(cancelText),
              ),
              ElevatedButton(
                onPressed: () => Get.back(result: true),
                child: Text(confirmText),
              ),
            ],
          ),
        ) ??
        false;
  }

  /// Show loading dialog
  static void showLoading([String? message]) {
    Get.dialog(
      AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            if (message != null) ...[const SizedBox(height: 16), Text(message)],
          ],
        ),
      ),
      barrierDismissible: false,
    );
  }

  /// Hide loading dialog
  static void hideLoading() {
    if (Get.isDialogOpen ?? false) {
      Get.back();
    }
  }

  DateTime dateOnly(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  String dateKey(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(dateOnly(date));
  }

  Object? getAttachmentForDate(
    DateTime date,
    List<ProjectMilestone>? milestones,
  ) {
    final normalizedDate = dateOnly(date);

    for (final milestone in milestones ?? []) {
      for (final attachment in milestone.imageAtt ?? []) {
        final attachmentDate = parseAttachmentDate(attachment.date);

        if (attachmentDate != null &&
            dateOnly(attachmentDate) == normalizedDate) {
          return attachment;
        }
      }
    }

    return null;
  }

  DateTime? parseAttachmentDate(String? value) {
    final rawDate = value?.trim();
    if (rawDate == null || rawDate.isEmpty) return null;

    final parsedIso = DateTime.tryParse(rawDate);
    if (parsedIso != null) return parsedIso;

    for (final pattern in ['dd-MM-yyyy', 'dd/MM/yyyy', 'yyyy-MM-dd']) {
      try {
        return DateFormat(pattern).parseStrict(rawDate);
      } catch (_) {}
    }

    return null;
  }

  Future<Directory> offlineMediaDir() async {
    final dir = await getApplicationDocumentsDirectory();
    final mediaDir = Directory('${dir.path}/offline_media');
    if (!await mediaDir.exists()) {
      await mediaDir.create(recursive: true);
    }
    return mediaDir;
  }

  Future<void> addExifData(
    String path, {
    double? lat,
    double? lng,
    double? accuracy,
    double? altitude,
    double? speed,
    double? heading,
    String? time,
  }) async {
    if (path.trim().isEmpty) return;
    if (!Platform.isAndroid) return;
    final exifPath =
        path.startsWith('file://') ? Uri.parse(path).toFilePath() : path;

    AuthService authService = Get.find<AuthService>();
    String userId = await authService.getUserId() ?? "";

    String formatDate(String? input) {
      if (input == null || input.isEmpty) return "";
      final date = DateTime.tryParse(input);
      if (date == null) return "";
      return "${date.year}:${date.month.toString().padLeft(2, '0')}:${date.day.toString().padLeft(2, '0')} "
          "${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}:${date.second.toString().padLeft(2, '0')}";
    }

    debugPrint(
      "Adding EXIF to $exifPath | exists: ${File(exifPath).existsSync()}",
    );

    await _exifChannel.invokeMethod<void>('addExifData', {
      'path': exifPath,
      'lat': lat,
      'lng': lng,
      'accuracy': accuracy,
      'altitude': altitude,
      'speed': speed,
      'heading': heading,
      'time': formatDate(time),
      'userId': userId,
    });

    // accuracy
    //altitude
    //speed
    //heading
    try {
      await readExif(path);
    } catch (e) {
      debugPrint("Failed to read image EXIF data: $e");
    }
  }

  Future<void> readExif(String path) async {
    if (path.trim().isEmpty) return;
    if (!Platform.isAndroid) return;
    final exifPath =
        path.startsWith('file://') ? Uri.parse(path).toFilePath() : path;

    final attributes = await _exifChannel.invokeMapMethod<String, dynamic>(
      'readExifData',
      {'path': exifPath},
    );
    attributes?.forEach((key, value) {
      debugPrint("print $key : ${value ?? ''}");
    });
  }

  void refreshHomeIfAvailable() {
    if (Get.isRegistered<HomeController>()) {
      final homeController = Get.find<HomeController>();
      homeController.checkInternet();
    }
  }

  // Logout Section
  void onLogoutTap() {
    AuthService authService = Get.find<AuthService>();
    Get.defaultDialog(
      title: 'Logout',
      middleText: 'Are you sure you want to logout?',
      textConfirm: 'Yes',
      textCancel: 'No',
      onConfirm: () async {
        Get.back();
        // Perform logout
        await authService.onLogout();
        Get.snackbar(
          'Logged Out',
          'You have been logged out successfully',
          snackPosition: SnackPosition.BOTTOM,
        );
        Get.offNamed(AppRoutes.splash);
      },
    );
  }

  String resolveImageUrl(String path) {
    final cleanedPath = path.replaceAll('\\', '/').trim();
    if (cleanedPath.startsWith('http://') ||
        cleanedPath.startsWith('https://')) {
      return cleanedPath;
    }

    final rawBaseUrl =
        NetworkConstants.baseUrl.replaceFirst('baseUrl=', '').trim();
    return Uri.parse(rawBaseUrl).resolve(cleanedPath).toString();
  }
}
