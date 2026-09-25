import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:video_player/video_player.dart';

class CaptureVideoFormField extends StatefulWidget {
  const CaptureVideoFormField({
    super.key,
    required this.name,
    required this.label,
    this.initialValue,
    this.required = false,
    this.enabled = true,
    this.validator,
    this.onChanged,
    required this.onCapture,
  });

  final String name;
  final String label;

  /// Existing video path.
  ///
  /// Can be:
  /// - Local file path
  /// - HTTP URL
  /// - HTTPS URL
  final String? initialValue;

  final bool required;
  final bool enabled;

  final String? Function(String?)? validator;

  final ValueChanged<String?>? onChanged;

  /// Called when user taps Capture / Retake.
  ///
  /// Should return the final video path.
  final Future<String?> Function()? onCapture;

  @override
  State<CaptureVideoFormField> createState() => _CaptureVideoFormFieldState();
}

class _CaptureVideoFormFieldState extends State<CaptureVideoFormField> {
  String? _videoPath;

  VideoPlayerController? _videoController;

  bool _isCapturing = false;
  bool _isInitializing = false;

  @override
  void initState() {
    super.initState();

    _videoPath = widget.initialValue;

    if (_videoPath != null && _videoPath!.isNotEmpty) {
      _initializeVideo(_videoPath!);
    }
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  // ===========================================================================
  // BUILD
  // ===========================================================================

  @override
  Widget build(BuildContext context) {
    return FormBuilderField<String>(
      name: widget.name,
      initialValue: _videoPath,
      enabled: widget.enabled,
      validator: widget.validator,

      builder: (field) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLabel(),

            const SizedBox(height: 8),

            if (_videoPath == null || _videoPath!.isEmpty)
              _buildCaptureButton(field)
            else
              _buildVideoPreview(field),

            if (field.errorText != null) _buildError(field.errorText!),
          ],
        );
      },
    );
  }

  // ===========================================================================
  // LABEL
  // ===========================================================================

  Widget _buildLabel() {
    return RichText(
      text: TextSpan(
        text: widget.label,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        ),
        children: [
          if (widget.required)
            const TextSpan(text: ' *', style: TextStyle(color: Colors.red)),
        ],
      ),
    );
  }

  // ===========================================================================
  // CAPTURE BUTTON
  // ===========================================================================

  Widget _buildCaptureButton(FormFieldState<String> field) {
    return InkWell(
      onTap:
          widget.enabled && !_isCapturing ? () => _captureVideo(field) : null,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade400),
          borderRadius: BorderRadius.circular(8),
        ),
        child:
            _isCapturing
                ? const Center(
                  child: SizedBox(
                    height: 22,
                    width: 22,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                )
                : const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.videocam_outlined),
                    SizedBox(width: 8),
                    Text('Capture Video'),
                  ],
                ),
      ),
    );
  }

  // ===========================================================================
  // VIDEO PREVIEW
  // ===========================================================================

  Widget _buildVideoPreview(FormFieldState<String> field) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildVideoPlayer(),

        const SizedBox(height: 10),

        Row(
          children: [
            OutlinedButton.icon(
              onPressed:
                  widget.enabled && !_isCapturing
                      ? () => _captureVideo(field)
                      : null,
              icon: const Icon(Icons.videocam_outlined),
              label: const Text('Retake'),
            ),

            const SizedBox(width: 10),

            OutlinedButton.icon(
              onPressed: _isCapturing ? null : () => _removeVideo(field),
              icon: const Icon(Icons.delete_outline),
              label: const Text('Remove'),
            ),
          ],
        ),
      ],
    );
  }

  // ===========================================================================
  // VIDEO PLAYER
  // ===========================================================================

  Widget _buildVideoPlayer() {
    if (_isInitializing) {
      return Container(
        height: 200,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.black12,
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_videoController == null || !_videoController!.value.isInitialized) {
      return Container(
        height: 200,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.black12,
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Center(
          child: Icon(
            Icons.video_library_outlined,
            size: 50,
            color: Colors.grey,
          ),
        ),
      );
    }

    final controller = _videoController!;

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: AspectRatio(
        aspectRatio: controller.value.aspectRatio,
        child: Stack(
          alignment: Alignment.center,
          children: [
            VideoPlayer(controller),

            GestureDetector(
              onTap: () {
                setState(() {
                  if (controller.value.isPlaying) {
                    controller.pause();
                  } else {
                    controller.play();
                  }
                });
              },
              child: Container(
                width: 55,
                height: 55,
                decoration: const BoxDecoration(
                  color: Colors.black54,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
                  color: Colors.white,
                  size: 32,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ===========================================================================
  // CAPTURE VIDEO
  // ===========================================================================

  Future<void> _captureVideo(FormFieldState<String> field) async {
    if (_isCapturing) {
      return;
    }

    try {
      setState(() {
        _isCapturing = true;
      });

      final String? videoPath = await widget.onCapture!();

      if (videoPath == null || videoPath.trim().isEmpty) {
        return;
      }

      await _disposeVideoController();

      setState(() {
        _videoPath = videoPath;
      });

      field.didChange(videoPath);

      widget.onChanged?.call(videoPath);

      await _initializeVideo(videoPath);
    } catch (e, stackTrace) {
      debugPrint('Capture video error: $e');

      debugPrintStack(stackTrace: stackTrace);
    } finally {
      if (mounted) {
        setState(() {
          _isCapturing = false;
        });
      }
    }
  }

  // ===========================================================================
  // INITIALIZE VIDEO
  // ===========================================================================

  Future<void> _initializeVideo(String path) async {
    try {
      setState(() {
        _isInitializing = true;
      });

      VideoPlayerController controller;

      if (path.startsWith('http://') || path.startsWith('https://')) {
        controller = VideoPlayerController.networkUrl(Uri.parse(path));
      } else {
        controller = VideoPlayerController.file(File(path));
      }

      await controller.initialize();

      controller.setLooping(true);

      if (!mounted) {
        await controller.dispose();
        return;
      }

      setState(() {
        _videoController = controller;
        _isInitializing = false;
      });
    } catch (e) {
      debugPrint('Video initialization error: $e');

      if (mounted) {
        setState(() {
          _isInitializing = false;
        });
      }
    }
  }

  // ===========================================================================
  // REMOVE VIDEO
  // ===========================================================================

  Future<void> _removeVideo(FormFieldState<String> field) async {
    await _disposeVideoController();

    setState(() {
      _videoPath = null;
    });

    field.didChange(null);

    widget.onChanged?.call(null);
  }

  // ===========================================================================
  // DISPOSE VIDEO CONTROLLER
  // ===========================================================================

  Future<void> _disposeVideoController() async {
    final controller = _videoController;

    if (controller != null) {
      await controller.dispose();
      _videoController = null;
    }
  }

  // ===========================================================================
  // ERROR
  // ===========================================================================

  Widget _buildError(String error) {
    return Padding(
      padding: const EdgeInsets.only(top: 5, left: 4),
      child: Text(
        error,
        style: TextStyle(
          color: Theme.of(context).colorScheme.error,
          fontSize: 12,
        ),
      ),
    );
  }
}
