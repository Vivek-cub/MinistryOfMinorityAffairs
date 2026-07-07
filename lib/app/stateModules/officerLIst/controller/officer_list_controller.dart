import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/state_manager.dart';
import 'package:ministry_of_minority_affairs/app/core/mixin/popup_mixin.dart';
import 'package:ministry_of_minority_affairs/app/core/mixin/snackbar_mixin.dart';
import 'package:ministry_of_minority_affairs/app/services/auth_service.dart';
import 'package:ministry_of_minority_affairs/app/stateModules/officerLIst/data/officer_list_response_model.dart';
import 'package:ministry_of_minority_affairs/app/stateModules/officerLIst/domain/officer_list_repo.dart';

class OfficerListController extends GetxController
    with SnackBarMixin, PopupMixin {
  final OfficerListRepo officerListRepo;
  final AuthService authService;
  OfficerListController(this.officerListRepo, this.authService);
  final isLoading = true.obs;
  final RxList<FieldOfficers> fieldOfficers = <FieldOfficers>[].obs;
  final RxList<FieldOfficers> allFieldOfficers = <FieldOfficers>[].obs;
  final searchQuery = ''.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    loadProjects();
  }

  void loadProjects() async {
    try {
      isLoading(true);

      final modelData = await officerListRepo.getOfficerList(
        field: "Field Officers",
      );
      // isLoading(false);
      if (modelData?.statusCode == "200") {
        if (modelData?.data != null && modelData?.data?.fieldOfficers != null) {
          fieldOfficers.value = modelData!.data?.fieldOfficers ?? [];
          allFieldOfficers.value = List.from(
            modelData.data?.fieldOfficers ?? [],
          );
        }
      } else {
        Get.snackbar("Error", "Failed to fetch dashboard data");
      }
    } catch (e) {
      throw Exception(e);
    } finally {
      isLoading(false);
    }
  }

  void onSearchChanged(String query) {
    searchQuery.value = query;
    if (query.length < 4) {
      fieldOfficers.value = List.from(allFieldOfficers);
      return;
    }
    _applyFilters();
  }

  void _applyFilters() {
    final query = searchQuery.value.toLowerCase();

    final filtered =
        allFieldOfficers.where((project) {
          final name = project.name ?? '';
          final email = project.email ?? '';
          final phone = project.phoneNumber ?? '';

          return name.contains(query) ||
              email.contains(query) ||
              phone.contains(query);
        }).toList();

    fieldOfficers.value = filtered;
  }
}
