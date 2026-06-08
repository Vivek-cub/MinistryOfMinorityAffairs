import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:ministry_of_minority_affairs/app/modules/calender/views/full_screen_image_page.dart';
import 'package:ministry_of_minority_affairs/app/utils/network_constants.dart';

class ImageGallerySheet extends StatelessWidget {
  final List<String> images;

  const ImageGallerySheet({super.key, required this.images});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Container(
            width: 50,
            height: 5,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(height: 16),

          const Text(
            "Visit Images",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 16),

          Expanded(
            child: GridView.builder(
              itemCount: images.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemBuilder: (context, index) {
                final imageUrl = _resolveImageUrl(images[index]);

                return GestureDetector(
                  onTap: () {
                    Get.to(() => FullScreenImagePage(imageUrl: imageUrl));
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(imageUrl, fit: BoxFit.cover),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

String _resolveImageUrl(String path) {
  final cleanedPath = path.replaceAll('\\', '/').trim();
  if (cleanedPath.startsWith('http://') || cleanedPath.startsWith('https://')) {
    return cleanedPath;
  }

  final rawBaseUrl =
      NetworkConstants.baseUrl.replaceFirst('baseUrl=', '').trim();
  return Uri.parse(rawBaseUrl).resolve(cleanedPath).toString();
}
