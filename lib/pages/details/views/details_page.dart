import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:voices_of_turkey/pages/details/controllers/details_controller.dart';
import 'package:voices_of_turkey/shared/custom_widgets/app_bar.dart';

import '../../../colors/app_colors.dart';

class DetailsView extends GetView<DetailsController> {
  const DetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    final data = Get.arguments as Map<String, String?>;
    final title = data["name"] ?? "";
    final description = data["description"] ?? "";
    final imageAddress = data["imageAddress"] ?? "";
    controller.initDetailsController();
    return PopScope(
      onPopInvoked: (e) {
        controller.onPopInvoked();
      },
      child: Scaffold(
        appBar: CustomAppBar(
          isBackButtonVisible: true,
          titleWidget: Text(
            "detailsPage".tr,
            style: TextStyle(color: AppColors.textColor),
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SelectableText(title),
                const SizedBox(
                  width: 6,
                ),
                GestureDetector(
                  child: const Icon(Icons.volume_up),
                  onTap: () async {
                    controller.onAudioButtonClick(description);
                  },
                )
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            imageAddress.isNotEmpty
                ? Image.network(imageAddress)
                : Image.asset("assets/images/restaurant_placeholder_image.jpg"),
            const SizedBox(
              height: 12,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child:
                    SingleChildScrollView(child: SelectableText(description)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

enum AudioState {
  playing,
  stopped,
}
