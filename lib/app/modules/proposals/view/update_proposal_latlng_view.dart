import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:ministry_of_minority_affairs/app/core/theme/theme_constants.dart';
import 'package:ministry_of_minority_affairs/app/core/widgets/build_project_card.dart';
import 'package:ministry_of_minority_affairs/app/core/widgets/search_bar_widget.dart';
import 'package:ministry_of_minority_affairs/app/core/widgets/work_detail_info_widget.dart';
import 'package:ministry_of_minority_affairs/app/core/widgets/work_progress_header.dart';
import 'package:ministry_of_minority_affairs/app/modules/auth/views/widgets/auth_submit_button.dart';
import 'package:ministry_of_minority_affairs/app/modules/proposals/controller/update_proposal_latlng_controller.dart';
import 'package:ministry_of_minority_affairs/app/utils/assets.dart';

class UpdateProposalLatlngView extends GetView<UpdateProposalLatlngController> {
  const UpdateProposalLatlngView({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: AppColors.background,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          top: false,
          bottom: true,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                WorkProgressHeader(
                  //title: controller.screenTitle,
                  title: "Proposal",
                  subtitle: 'Track Progress of works in real-time',
                  avatarAssetPath: ImageAssets.emblemImage,
                  backIcon: Icons.arrow_back,

                  // widget: WorkDetailInfoWidget(
                  //   project: controller.data.value,
                  //   status: controller.projectStatus.value,
                  // ),
                ),

                Obx(() {
                  final location = controller.currentLocation.value;

                  if (location == null) {
                    return Positioned.fill(
                      child: IgnorePointer(
                        child: Container(
                          // color: Colors.black.withValues(alpha: 0.08),
                          child: Center(
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                // color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: CircularProgressIndicator(
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }

                  return Column(
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height * 0.60,
                        margin: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.lightGrey),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: FlutterMap(
                          options: MapOptions(
                            initialCenter: location,
                            initialZoom: 15,
                          ),
                          children: [
                            TileLayer(
                              urlTemplate:
                                  'https://a.basemaps.cartocdn.com/light_all/{z}/{x}/{y}.png',
                              userAgentPackageName:
                                  'com.minorityaffairs.ministry_of_minority_affairs',
                            ),

                            MarkerLayer(
                              markers: [
                                Marker(
                                  point: location,
                                  width: 80,
                                  height: 80,
                                  child: const Icon(
                                    Icons.location_pin,
                                    size: 40,
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),
                        child: AuthSubmitButton(
                          title: "Update Location",
                          onPressed: () {
                            controller.submitLocation();
                          },
                        ),
                      ),
                    ],
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
