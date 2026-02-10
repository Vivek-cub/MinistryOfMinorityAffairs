
import 'package:get/get_state_manager/src/rx_flutter/rx_disposable.dart';
import 'package:ministry_of_minority_affairs/app/data/repository/submission_repository.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectDetails/domain/repo/project_detail_repo.dart';
import 'package:ministry_of_minority_affairs/app/services/network_service.dart';

class SyncService extends GetxService {
  final SubmissionRepository repository;
  final ProjectDetailRepo repo;

  SyncService(this.repository, this.repo);

  Future<void> _syncPendingSubmissions() async {
  final hasInternet = await NetworkService.hasInternet();
  if (!hasInternet) return;

  final pendingList = await repository.getPending();

  for (final item in pendingList) {
    try {
      final response = await repo.uploadMilestoneFiles(
        projectId: item.submission.projectId,
        milestoneId: item.submission.milestoneId,
        imagePaths: item.images.map((e) => e.filePath).toList(),
        audioPath: item.audio?.filePath,
        videoPath: item.video?.filePath,
      );

      if (response.statusCode == '200') {
        await repository.markAsSynced(item.submission.projectId);
      }
    } catch (_) {
      
    }
  }
}

}
