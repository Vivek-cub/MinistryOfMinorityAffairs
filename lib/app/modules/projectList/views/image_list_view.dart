import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/state_manager.dart';
import 'package:ministry_of_minority_affairs/app/core/theme/theme_constants.dart';
import 'package:ministry_of_minority_affairs/app/core/widgets/custom_text.dart';
import 'package:ministry_of_minority_affairs/app/core/widgets/title_text.dart';
import 'package:ministry_of_minority_affairs/app/core/widgets/work_progress_header.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectList/controller/image_list_controller.dart';
import 'package:ministry_of_minority_affairs/app/utils/assets.dart';
import 'package:ministry_of_minority_affairs/app/utils/helpers.dart';
import 'package:photo_view/photo_view.dart';

class ImageListView extends GetView<ImageListController> {
  const ImageListView({super.key});

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
          child: Column(
            children: [
              WorkProgressHeader(
                //title: controller.screenTitle,
                title: "Images",
                subtitle: 'Track Progress of works in real-time',
                avatarAssetPath: ImageAssets.emblemImage,
                backIcon: Icons.arrow_back,
                // widget: WorkDetailInfoWidget(
                //   project: controller.data.value,
                //   status: controller.projectStatus.value,
                // ),
              ),

              Obx(() {
                final groupedData = controller.groupImages(
                  controller.data.value.imageAtt ?? [],
                );

                return Expanded(
                  child: ListView.builder(
                    itemCount: groupedData.length,
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, dateIndex) {
                      final date = groupedData.keys.elementAt(dateIndex);
                      final roleGroups = groupedData[date]!;

                      return Card(
                        margin: const EdgeInsets.all(8),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TitleText(text: date),

                              // const SizedBox(height: 12),
                              ...roleGroups.entries.map((roleEntry) {
                                final role = roleEntry.key;
                                final images = roleEntry.value;

                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CustomText(text: "Uploaded By :- $role"),

                                    const SizedBox(height: 8),
                                    GridView.builder(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount: images.length,
                                      padding: EdgeInsets.zero,
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 3,
                                            crossAxisSpacing: 8,
                                            mainAxisSpacing: 8,
                                          ),
                                      itemBuilder: (context, imageIndex) {
                                        final image = Helpers().resolveImageUrl(
                                          images[imageIndex].images ?? "",
                                        );

                                        return InkWell(
                                          onTap: () {
                                            final imageUrls =
                                                images
                                                    .map(
                                                      (e) => Helpers()
                                                          .resolveImageUrl(
                                                            e.images ?? '',
                                                          ),
                                                    )
                                                    .toList();
                                            controller.openImageViewer(
                                              context,
                                              imageUrls,
                                              imageIndex,
                                            );
                                          },
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                            child: Image.network(
                                              image,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        );
                                      },
                                    ),

                                    const SizedBox(height: 16),
                                  ],
                                );
                              }),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
