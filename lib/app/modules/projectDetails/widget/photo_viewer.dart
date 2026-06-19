import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ministry_of_minority_affairs/app/core/theme/theme_constants.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class PhotoViewer extends StatefulWidget {
  List<String>? images;
  int? index;
  PhotoViewer({super.key, required this.images, this.index});

  @override
  State<PhotoViewer> createState() => _PhotoViewerState();
}

class _PhotoViewerState extends State<PhotoViewer> {
  late PageController controller;
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.index ?? 0;
    controller = PageController(initialPage: currentIndex);
  }

  void prev() {
    if (currentIndex > 0) {
      controller.previousPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    }
  }

  void next() {
    if (currentIndex < widget.images!.length - 1) {
      controller.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.only(top: 48, bottom: 48),
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      child: Stack(
        children: [
          SizedBox.expand(
            child: PhotoViewGallery.builder(
              itemCount: widget.images!.length,
              pageController: controller,
              onPageChanged: (index) {
                setState(() => currentIndex = index);
              },
              builder: (context, index) {
                final imagePath = widget.images![index];
                final isLocalFile = imagePath.startsWith('/');
                final ImageProvider imageProvider =
                    isLocalFile
                        ? FileImage(File(imagePath))
                        : NetworkImage(imagePath);

                return PhotoViewGalleryPageOptions(
                  imageProvider: imageProvider,
                  minScale: PhotoViewComputedScale.contained,
                  maxScale: PhotoViewComputedScale.contained,
                  initialScale: PhotoViewComputedScale.contained,
                  // minScale: PhotoViewComputedScale.covered,
                  // maxScale: PhotoViewComputedScale.covered * 3,
                  // initialScale: PhotoViewComputedScale.covered,
                );
              },
              backgroundDecoration: const BoxDecoration(color: Colors.black),
            ),
          ),

          Positioned(
            top: 40,
            right: 16,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),

          Positioned(
            left: 10,
            top: 0,
            bottom: 0,
            child: Center(
              child: IconButton(
                onPressed: prev,
                icon: const Icon(Icons.arrow_back, color: Colors.white),
              ),
            ),
          ),

          Positioned(
            right: 10,
            top: 0,
            bottom: 0,
            child: Center(
              child: IconButton(
                onPressed: next,
                icon: const Icon(Icons.arrow_forward, color: Colors.white),
              ),
            ),
          ),

          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                "${currentIndex + 1} / ${widget.images!.length}",
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
