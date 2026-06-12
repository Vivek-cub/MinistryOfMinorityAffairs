import 'dart:io';

// mixin class CaptureImageMixin {
//   File takePhoto() async {
//     final ImagePicker picker = ImagePicker();
//     final XFile? image = await picker.pickImage(
//       source: ImageSource.camera,
//       imageQuality: 100, // capture full quality
//     );

//     if (image == null) return;

//     // 🔑 Convert XFile → File
//     final File originalFile = File(image.path);

//     final File finalFile = await compressIfNeeded(originalFile);
//     return finalFile;
//   }
// }
