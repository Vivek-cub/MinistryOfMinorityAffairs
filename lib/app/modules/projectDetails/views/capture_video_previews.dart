
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class CapturedVideoPreview extends StatefulWidget {
  final String? videoPath;
  final VoidCallback onCaptureTap;
  final VoidCallback onRemoveTap;

  const CapturedVideoPreview({
    super.key,
    required this.videoPath,
    required this.onCaptureTap,
    required this.onRemoveTap,
  });

  @override
  State<CapturedVideoPreview> createState() => _CapturedVideoPreviewState();
}

class _CapturedVideoPreviewState extends State<CapturedVideoPreview> {
  VideoPlayerController? _controller;

  @override
  void didUpdateWidget(covariant CapturedVideoPreview oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.videoPath != widget.videoPath) {
      _initializePlayer();
    }
  }

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    _controller?.dispose();
    _controller = null;

    if (widget.videoPath == null || widget.videoPath=="") return;

    final controller =
        VideoPlayerController.file(File(widget.videoPath!));

    await controller.initialize();

    setState(() {
      _controller = controller;
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ---------- No video ----------
    if (widget.videoPath == null || widget.videoPath=="") {
      return GestureDetector(
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
      );
    }

    // ---------- Video loaded ----------
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
        Center(
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
              child: const Icon(
                Icons.close,
                size: 18,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
