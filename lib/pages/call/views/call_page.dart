import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../colors/app_colors.dart';
import '../controllers/call_controller.dart';

class CallView extends GetView<CallController> {
  const CallView({super.key});

  @override
  Widget build(BuildContext context) {
    final data = Get.arguments as Map<String, String?>;
    final title = data["name"] ?? "";
    final description = data["description"] ?? "";
    final imageAddress = data["imageAddress"] ?? "";

    controller.initCallController();
    return PopScope(
      onPopInvoked: (e) {
        controller.onPopInvoked();
      },
      child: Scaffold(
        body: Stack(
          children: [
            SizedBox.expand(
              child: Image(
                fit: BoxFit.fill,
                image: NetworkImage(imageAddress),
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                  padding: const EdgeInsets.only(top: 100),
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                    ),
                  )),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CallButton(
                      color: AppColors.acceptCallButtonColor,
                      icon: Icons.call,
                      onTap: () async {
                        await controller.onCallAccept(description);
                      },
                    ),
                    CallButton(
                      color: AppColors.declineCallButtonColor,
                      icon: Icons.call_end,
                      onTap: () async {
                        await controller.onCallDecline();
                      },
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class CallButton extends StatelessWidget {
  final Color color;
  final IconData icon;
  final VoidCallback onTap;

  const CallButton({
    super.key,
    required this.color,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          size: 70,
        ),
      ),
    );
  }
}
