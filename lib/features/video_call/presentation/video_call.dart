import 'package:dating_user/core/common_widget/custom_elevated_button.dart';
import 'package:dating_user/core/constant/app_text_style.dart';
import 'package:dating_user/features/video_call/controller/video_call_controller.dart';
import 'package:floating_draggable_widget/floating_draggable_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:logger/logger.dart';
import 'package:videosdk/videosdk.dart';

import '../../authentication/presentation/login/login_screen.dart';
import '../../authentication/presentation/profile_setup/profile_upload_screen.dart';

class VideoCall extends GetView<VideoCallController> {
  const VideoCall({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        controller.disConnectCall();
      },
      child: ImageBackgroundContainer(
        child: Scaffold(
          appBar: AppBar(
            forceMaterialTransparency: true,
            title: const Text("Video Call"),
            leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: Icon(Icons.arrow_back_ios_new, color: Colors.white),
            ),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
          floatingActionButton: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(1000),
                  color: Colors.grey.shade100,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Iconsax.message),
                      onPressed: () {},
                    ),
                    const SizedBox(width: 24),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Iconsax.repeat),
                    ),
                    const SizedBox(width: 24),
                    IconButton(
                      onPressed: () {
                        Get.to(
                          () => const RequestGiftScreen(),
                          transition: Transition.downToUp,
                        );
                      },
                      icon: const Icon(Iconsax.gift),
                    ),
                  ],
                ),
              ),
            ],
          ),
          body: FloatingDraggableWidget(
            // ─── Local preview (draggable pip) ──────────────────────────────
            floatingWidget: Container(
              decoration: BoxDecoration(
                color: Colors.black,
                border: Border.all(color: Colors.grey.shade200),
              ),
              // child: SizedBox(),
              child: Obx(
                () => controller.localVideoStream.value != null
                    ? RTCVideoView(
                        controller.localVideoStream.value!.renderer
                            as RTCVideoRenderer,
                        mirror: false,
                        objectFit:
                            RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
                      )
                    : const CustomCircularLoader(),
              ),
            ),
            floatingWidgetWidth: 150,
            floatingWidgetHeight: 200,
            dx: Get.size.width - 150,
            dy: Get.size.height - 400,
            autoAlign: true,
            disableBounceAnimation: true,
            isDraggable: true,
            // ─── Remote video (full screen) ──────────────────────────────────
            mainScreenWidget: SafeArea(
              top: true,
              child: Obx(
                () => controller.participantVideoStream.value == null
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CustomCircularLoader(),
                            SizedBox(height: 16),
                            Text(
                              "Connecting...",
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      )
                    : RTCVideoView(
                        controller.participantVideoStream.value!.renderer
                            as RTCVideoRenderer,
                        objectFit:
                            RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Gift Model ──────────────────────────────────────────────────────────────

class GiftItem {
  final String name;
  final IconData icon;

  const GiftItem({required this.name, required this.icon});
}

// ─── Request Gift Screen ─────────────────────────────────────────────────────

class RequestGiftScreen extends StatelessWidget {
  const RequestGiftScreen({super.key});

  static final List<GiftItem> _gifts = const [
    GiftItem(name: 'Home', icon: Icons.home),
    GiftItem(name: 'Love', icon: Icons.favorite),
    GiftItem(name: 'Star', icon: Icons.star),
    GiftItem(name: 'Settings', icon: Icons.settings),
    GiftItem(name: 'Profile', icon: Icons.person),
    GiftItem(name: 'Camera', icon: Icons.camera_alt),
    GiftItem(name: 'Alerts', icon: Icons.notifications),
    GiftItem(name: 'Cart', icon: Icons.shopping_cart),
    GiftItem(name: 'Search', icon: Icons.search),
    GiftItem(name: 'Phone', icon: Icons.phone),
    GiftItem(name: 'Map', icon: Icons.map),
    GiftItem(name: 'Lock', icon: Icons.lock),
    GiftItem(name: 'Mail', icon: Icons.email),
    GiftItem(name: 'Music', icon: Icons.music_note),
    GiftItem(name: 'Flight', icon: Icons.flight),
    GiftItem(name: 'Car', icon: Icons.directions_car),
    GiftItem(name: 'WiFi', icon: Icons.wifi),
    GiftItem(name: 'Like', icon: Icons.thumb_up),
    GiftItem(name: 'Print', icon: Icons.print),
    GiftItem(name: 'Alarm', icon: Icons.alarm),
  ];

  @override
  Widget build(BuildContext context) {
    final selectedGiftName = ''.obs;

    return ImageBackgroundContainer(
      child: Scaffold(
        appBar: AppBar(
          forceMaterialTransparency: true,
          title: Text(
            "Request Gift",
            style: AppTextStyle.mediumPoppins.copyWith(fontSize: 18),
          ),
          leading: IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          ),
        ),
        floatingActionButton: Obx(
          () => selectedGiftName.value.isNotEmpty
              ? CustomElevatedButton(
                  child: const Text("Send Gift"),
                  onPressed: () {},
                )
              : const SizedBox.shrink(),
        ),
        body: GridView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          itemCount: _gifts.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1,
          ),
          itemBuilder: (context, index) {
            final gift = _gifts[index];
            return Obx(
              () => InkWell(
                onTap: () {
                  selectedGiftName.value = selectedGiftName.value == gift.name
                      ? ''
                      : gift.name;
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: selectedGiftName.value == gift.name
                          ? Colors.white
                          : Colors.transparent,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(gift.icon, color: Colors.white, size: 36),
                      const SizedBox(height: 6),
                      Text(
                        gift.name,
                        style: AppTextStyle.normalPoppins.copyWith(
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
