import 'package:cached_network_image/cached_network_image.dart';
import 'package:dating_user/core/common_model/user_model.dart';
import 'package:dating_user/core/constant/api_endpoints.dart';
import 'package:dating_user/core/constant/app_text_style.dart';
import 'package:dating_user/core/helper/scoket_helper.dart';
import 'package:dating_user/features/authentication/presentation/profile_setup/profile_upload_screen.dart';
import 'package:dating_user/features/video_call/presentation/video_call.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/video_call_controller.dart';

class NewCallScreen extends StatefulWidget {
  const NewCallScreen({super.key, required this.caller, required this.roomId});

  final UserModel caller;
  final String roomId;

  @override
  State<NewCallScreen> createState() => _NewCallScreenState();
}

class _NewCallScreenState extends State<NewCallScreen> {
  @override
  void initState() {
    SocketHelper.instance.socket.on("callDrop", (data) {
      Get.back();
    });
    super.initState();
  }

  @override
  void dispose() {
    SocketHelper.instance.socket.off("callDrop");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ImageBackgroundContainer(
      child: Scaffold(
        body: Column(
          mainAxisAlignment: .spaceEvenly,
          children: [
            Column(
              children: [
                Center(
                  child: ClipRRect(
                    borderRadius: .circular(1000),
                    child: CachedNetworkImage(
                      height: 100,
                      width: 100,
                      imageUrl:
                          "${ApiEndpoints.baseUrl}/${widget.caller.profilePicture}",
                    ),
                  ),
                ),
                Text(
                  widget.caller.fullName,
                  style: AppTextStyle.mediumPoppins.copyWith(fontSize: 18),
                ),
                Text(
                  "Calling....",
                  style: AppTextStyle.normalPoppins.copyWith(fontSize: 16),
                ),
              ],
            ),

            Padding(
              padding: .symmetric(horizontal: 54),
              child: Row(
                mainAxisAlignment: .spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      Get.off(
                        () => VideoCall(),
                        binding: BindingsBuilder.put(
                          () => VideoCallController(
                            callerDetail: widget.caller,
                            roomId: widget.roomId,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      padding: .all(12),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.call, size: 36),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      SocketHelper.instance.rejectCall(
                        callerId: widget.caller.id,
                        roomId: widget.roomId,
                      );
                      Get.back();
                    },
                    child: Container(
                      padding: .all(12),
                      decoration: BoxDecoration(
                        color: Colors.red.shade400,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.call_end, size: 36),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
