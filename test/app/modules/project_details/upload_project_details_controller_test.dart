import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:ministry_of_minority_affairs/app/core/model/common_response_model.dart';
import 'package:ministry_of_minority_affairs/app/data/repository/submission_repository.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectDetails/controller/upload_project_details_controller.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectDetails/data/repo/project_repository.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectDetails/domain/repo/project_detail_repo.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectList/data/model/unit_details.dart';
import 'package:ministry_of_minority_affairs/app/services/auth_service.dart';
import 'package:ministry_of_minority_affairs/app/services/storage/s_storage_service.dart';

import '../../../helpers/functional_test_fakes.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    Get.testMode = true;
  });

  tearDown(() {
    Get.reset();
  });

  group('UploadProjectDetailsController', () {
    test('returns only selected non-null image paths in slot order', () {
      final controller = _buildController();
      controller.photos[0] = '/tmp/first.jpg';
      controller.photos[2] = '/tmp/third.jpg';

      expect(controller.selectedImages, ['/tmp/first.jpg', '/tmp/third.jpg']);
    });

    test('maps Not Started progress to zero and locks progress input', () {
      final controller = _buildController();
      controller.statusProgressValue.value = 55;

      controller.selectProgress('Not Started');

      expect(controller.selectedProgress.value, 'Not Started');
      expect(controller.statusProgressValue.value, 0);
      expect(controller.isLocked.value, isTrue);
    });

    test('maps Completed progress to one hundred and locks progress input', () {
      final controller = _buildController();

      controller.selectProgress('Completed');

      expect(controller.selectedProgress.value, 'Completed');
      expect(controller.statusProgressValue.value, 100);
      expect(controller.isLocked.value, isTrue);
    });

    test('unlocks custom progress statuses without overwriting progress', () {
      final controller = _buildController();
      controller.statusProgressValue.value = 65;

      controller.selectProgress('In Progress');

      expect(controller.selectedProgress.value, 'In Progress');
      expect(controller.statusProgressValue.value, 65);
      expect(controller.isLocked.value, isFalse);
    });

    test(
      'persists the current project locally for an authenticated user',
      () async {
        final storage = InMemoryStorageService();
        await storage.writeKey(key: SStorageKeys.token, value: 'user-123');
        final projectRepository = RecordingProjectRepository();
        final controller = _buildController(
          authService: AuthService(storage),
          projectRepository: projectRepository,
        );
        final project = UnitDetails(
          id: 'project-9',
          projectName: 'Community Hall',
        );
        controller.data.value = project;

      controller.saveToLocalDb();
      await Future<void>.delayed(Duration.zero);

        expect(projectRepository.savedProjects, [project]);
        expect(projectRepository.savedUserIds, ['user-123']);
      },
    );

    test(
      'does not persist locally when no authenticated user is available',
      () async {
        final projectRepository = RecordingProjectRepository();
        final controller = _buildController(
          projectRepository: projectRepository,
        );
        controller.data.value = UnitDetails(id: 'project-9');

      controller.saveToLocalDb();
      await Future<void>.delayed(Duration.zero);

        expect(projectRepository.savedProjects, isEmpty);
        expect(projectRepository.savedUserIds, isEmpty);
      },
    );
  });
}

UploadProjectDetailsController _buildController({
  AuthService? authService,
  RecordingProjectRepository? projectRepository,
}) {
  return UploadProjectDetailsController(
    FakeSubmissionRepository(),
    UnusedProjectDetailRepo(),
    authService ?? TestAuthService(),
    projectRepository ?? RecordingProjectRepository(),
    FakeCaptureProjectVideo(),
  );
}

class UnusedProjectDetailRepo implements ProjectDetailRepo {
  @override
  Future<CommonResponseModel> uploadMilestoneFiles({
    required String projectId,
    required List<String> imagePaths,
    String? videoPath,
    String? audioPath,
    required String userLat,
    required String userLng,
    required String progress,
    required String projectStatus,
    required String remarks,
  }) async {
    throw UnimplementedError();
  }
}

class RecordingProjectRepository extends Fake implements ProjectRepository {
  final savedProjects = <UnitDetails>[];
  final savedUserIds = <String>[];

  @override
  Future<void> saveProject(UnitDetails project, String userId) async {
    savedProjects.add(project);
    savedUserIds.add(userId);
  }
}
