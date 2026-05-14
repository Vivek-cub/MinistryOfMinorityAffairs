import 'package:ministry_of_minority_affairs/app/modules/projectList/data/model/audio_attachment.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectList/data/model/image_attachment.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectList/data/model/project_milestone.dart';

class MilestoneAttachmentMapper {
  static List<ImageAttachment> imageGroups(ProjectMilestone milestone) {
    return (milestone.imageAtt ?? const <ImageAttachment>[])
        .where(
          (group) => (group.images ?? const <String>[])
              .any((path) => path.trim().isNotEmpty),
        )
        .toList();
  }

  static List<String> imagePaths(ProjectMilestone milestone) {
    return imageGroups(milestone)
        .expand((group) => group.images ?? const <String>[])
        .where((path) => path.trim().isNotEmpty)
        .toList();
  }

  static List<String> audioPaths(ProjectMilestone milestone) {
    return (milestone.audioAtt ?? const <AudioAttachment>[])
        .expand((group) => group.audios ?? const <String>[])
        .where((path) => path.trim().isNotEmpty)
        .toList();
  }

  static int imageCount(ProjectMilestone milestone) {
    return imagePaths(milestone).length;
  }

  static bool hasImages(ProjectMilestone milestone) {
    return imagePaths(milestone).isNotEmpty;
  }

  static bool hasAudio(ProjectMilestone milestone) {
    return audioPaths(milestone).isNotEmpty;
  }

  static List<ImageAttachment>? toImageAttachments(List<String>? paths) {
    if (paths == null || paths.isEmpty) return null;

    final filtered = paths.where((e) => e.trim().isNotEmpty).toList();
    if (filtered.isEmpty) return null;

    return [
      ImageAttachment(
        date: null,
        images: filtered,
      ),
    ];
  }

  static List<AudioAttachment>? toAudioAttachments(List<String>? paths) {
    if (paths == null || paths.isEmpty) return null;

    final filtered = paths.where((e) => e.trim().isNotEmpty).toList();
    if (filtered.isEmpty) return null;

    return [
      AudioAttachment(
        date: null,
        audios: filtered,
      ),
    ];
  }

  static List<AudioAttachment>? toAudioAttachmentsFromSingle(String? path) {
    if (path == null || path.trim().isEmpty) return null;

    return [
      AudioAttachment(
        date: null,
        audios: [path],
      ),
    ];
  }
}
