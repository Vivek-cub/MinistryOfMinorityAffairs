import 'dart:io';
import 'package:flutter/material.dart';
import 'package:ministry_of_minority_affairs/app/core/values/app_colors.dart';

/// Reusable photo upload widget
/// Displays a dashed border box with camera icon for photo upload
class PhotoUploadWidget extends StatelessWidget {
  final String? imagePath;
  final VoidCallback? onTap;
  final String? label;

  const PhotoUploadWidget({
    super.key,
    this.imagePath,
    this.onTap,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    final isFile = imagePath != null && imagePath!.startsWith('/');
    
    return GestureDetector(
      onTap: onTap,
      child: AspectRatio(
        aspectRatio: 1,
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Stack(
            children: [
              // Content
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: imagePath != null
                    ? (isFile
                        ? Image.file(
                            File(imagePath!),
                            fit: BoxFit.cover,
                          )
                        : Image.asset(
                            imagePath!,
                            fit: BoxFit.cover,
                          ))
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.camera_alt_outlined,
                            size: 40,
                            color: AppColors.textHint,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            label ?? 'Tap to take a photo',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.textHint,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
              ),
              // Dashed border
              CustomPaint(
                painter: DashedBorderPainter(
                  color: AppColors.border,
                  strokeWidth: 1.5,
                  dashWidth: 6,
                  dashSpace: 4,
                  borderRadius: 12,
                ),
                child: Container(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Custom painter for dashed border
class DashedBorderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double dashWidth;
  final double dashSpace;
  final double borderRadius;

  DashedBorderPainter({
    required this.color,
    required this.strokeWidth,
    required this.dashWidth,
    required this.dashSpace,
    required this.borderRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(0, 0, size.width, size.height),
          Radius.circular(borderRadius),
        ),
      );

    final dashPath = _createDashPath(path, dashWidth, dashSpace);
    canvas.drawPath(dashPath, paint);
  }

  Path _createDashPath(Path sourcePath, double dashWidth, double dashSpace) {
    final dashPath = Path();
    final pathMetrics = sourcePath.computeMetrics();

    for (final pathMetric in pathMetrics) {
      double distance = 0;
      while (distance < pathMetric.length) {
        final length = (distance + dashWidth < pathMetric.length)
            ? dashWidth
            : pathMetric.length - distance;
        dashPath.addPath(
          pathMetric.extractPath(distance, distance + length),
          Offset.zero,
        );
        distance += length + dashSpace;
      }
    }
    return dashPath;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
