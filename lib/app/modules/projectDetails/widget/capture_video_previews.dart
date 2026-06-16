import 'dart:io';
import 'package:flutter/material.dart';
import 'package:ministry_of_minority_affairs/app/core/theme/theme_constants.dart';
import 'package:ministry_of_minority_affairs/app/core/widgets/title_text.dart';
import 'package:video_player/video_player.dart';

class CapturedVideoPreview extends StatefulWidget {
  final String? videoPath;
  final VoidCallback onCaptureTap;
  final VoidCallback onRemoveTap;
  final bool showRemoveButton;

  const CapturedVideoPreview({
    super.key,
    required this.videoPath,
    required this.onCaptureTap,
    required this.onRemoveTap,
    this.showRemoveButton = true,
  });

  @override
  State<CapturedVideoPreview> createState() => _CapturedVideoPreviewState();
}

class _CapturedVideoPreviewState extends State<CapturedVideoPreview> {
  VideoPlayerController? _controller;
  int _loadId = 0;
  Object? _loadError;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  @override
  void didUpdateWidget(covariant CapturedVideoPreview oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.videoPath != widget.videoPath) {
      _initializePlayer();
    }
  }

  Future<void> _initializePlayer() async {
    final currentLoad = ++_loadId;

    _controller?.dispose();
    _controller = null;
    _loadError = null;

    if (widget.videoPath == null || widget.videoPath!.isEmpty) return;

    final path = widget.videoPath!;
    final isRemote = path.startsWith('http://') || path.startsWith('https://');

    try {
      final controller =
          isRemote
              ? VideoPlayerController.networkUrl(Uri.parse(path))
              : VideoPlayerController.file(File(path));

      await controller.initialize();

      if (!mounted || currentLoad != _loadId) {
        controller.dispose();
        return;
      }

      setState(() {
        _controller = controller;
      });
    } catch (error) {
      if (!mounted || currentLoad != _loadId) {
        return;
      }

      setState(() {
        _loadError = error;
      });
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ---------- No video ----------
    if (widget.videoPath == null || widget.videoPath!.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const TitleText(
            text: 'Project Completion Video',
            fontWeight: FontWeight.w600,
          ),
          const SizedBox(height: AppDimensions.sm),
          GestureDetector(
            onTap: widget.onCaptureTap,
            child: Container(
              height: 180,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.grey.shade200,
                border: Border.all(color: Colors.grey.shade400),
              ),
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.videocam_outlined, size: 40),
                    SizedBox(height: 8),
                    Text('Tap to capture video'),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
    }

    // ---------- Loading ----------
    if (_loadError != null) {
      return Container(
        height: 180,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.grey.shade200,
          border: Border.all(color: Colors.grey.shade400),
        ),
        child: const Center(child: Text('Unable to load video')),
      );
    }

    if (_controller == null || !_controller!.value.isInitialized) {
      return const SizedBox(
        height: 180,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    return Stack(
      children: [
        SizedBox(
          height: 200,
          width: double.infinity,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: AspectRatio(
              aspectRatio: _controller!.value.aspectRatio,
              child: VideoPlayer(_controller!),
            ),
          ),
        ),

        // Play / Pause
        Positioned(
          bottom: 50,
          top: 50,
          left: 100,
          right: 100,
          child: IconButton(
            iconSize: 56,
            color: Colors.white,
            icon: Icon(
              _controller!.value.isPlaying
                  ? Icons.pause_circle
                  : Icons.play_circle,
            ),
            onPressed: () {
              setState(() {
                _controller!.value.isPlaying
                    ? _controller!.pause()
                    : _controller!.play();
              });
            },
          ),
        ),

        // Remove button
        if (widget.showRemoveButton)
          Positioned(
            top: 8,
            right: 8,
            child: InkWell(
              onTap: widget.onRemoveTap,
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black54,
                ),
                child: const Icon(Icons.close, size: 18, color: Colors.white),
              ),
            ),
          ),
      ],
    );
  }
}
