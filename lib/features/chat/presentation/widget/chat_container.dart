import 'package:dating_user/core/constant/app_color.dart';
import 'package:dating_user/core/constant/app_text_style.dart';
import 'package:dating_user/features/chat/presentation/controller/chat_controller.dart';
import 'package:dating_user/features/chat/presentation/controller/main_chat_controoler.dart';
import 'package:flutter/material.dart';


class ChatContainer extends StatelessWidget {
  const ChatContainer({
    super.key,
    required this.chatData,
    required this.ownMessage,
    required this.receiver,
  });

  final ConversationUserModel receiver;
  final ChatMessageModel chatData;
  final bool ownMessage;

  @override
  Widget build(BuildContext context) {
    var noMessage = false;
    var messageTime = "12:10 AM";
    if (noMessage) return SizedBox.shrink();
    if (ownMessage) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          IntrinsicWidth(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "You",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      messageTime,
                      style: TextStyle(
                        color: Colors.white,
                        // color: AppColor.chatTimeColor,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),

                // if (chatData.chatDetails.image.isNotEmpty)
                //   SizedBox(
                //     width: 200,
                //     height: 200,
                //     child: ClipRRect(
                //       borderRadius: BorderRadius.circular(6),
                //       child: CachedNetworkImage(
                //         fit: BoxFit.cover,
                //         imageUrl:
                //         "${ChatController.instance.baseUrl}/${chatData.chatDetails.image}",
                //         placeholder: (context, url) {
                //           return Image(
                //             image: AssetImage(AppImage.backgroundImage),
                //             fit: BoxFit.cover,
                //           );
                //         },
                //         errorWidget: (context, url, error) {
                //           return Image(
                //             image: AssetImage(AppImage.backgroundImage),
                //             fit: BoxFit.cover,
                //           );
                //         },
                //       ),
                //     ),
                //   ),
                if (chatData.message.isNotEmpty)
                  Container(
                    padding: EdgeInsets.only(
                      left: 12,
                      top: 12,
                      bottom: 12,
                      right: 24,
                    ),
                    decoration: BoxDecoration(
                      color: AppColor.primaryColor,
                      // color: AppColor.chatBoxBackground,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12),
                        bottomLeft: Radius.circular(12),
                        topRight: Radius.zero,
                        bottomRight: Radius.circular(12),
                      ),
                    ),
                    child: Text(
                      chatData.message,
                      style: AppTextStyle.normalPoppins.copyWith(
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      );
    } else {
      return Container(
        margin: EdgeInsets.only(right: 36),
        child: IntrinsicWidth(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisSize: .min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    receiver.firstName,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    messageTime,
                    style: TextStyle(
                      color: Colors.white,
                      // color: AppColor.chatTimeColor,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              // if (chatData.chatDetails.image.isNotEmpty)
              //   SizedBox(
              //     width: 200,
              //     height: 200,
              //     child: ClipRRect(
              //       borderRadius: BorderRadius.circular(6),
              //       child: CachedNetworkImage(
              //         fit: BoxFit.cover,
              //         imageUrl:
              //         "${ChatController.instance.baseUrl}/${chatData.chatDetails.image}",
              //         placeholder: (context, url) {
              //           return Image(
              //             image: AssetImage(AppImage.backgroundImage),
              //             fit: BoxFit.cover,
              //           );
              //         },
              //         errorWidget: (context, url, error) {
              //           return Image(
              //             image: AssetImage(AppImage.backgroundImage),
              //             fit: BoxFit.cover,
              //           );
              //         },
              //       ),
              //     ),
              //   ),
              if (chatData.message.isNotEmpty)
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColor.primaryColor,
                    // color: AppColor.chatBoxBackground,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                      bottomRight: Radius.circular(12),
                    ),
                  ),
                  child: Text(
                    chatData.message,
                    style: AppTextStyle.normalPoppins.copyWith(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
            ],
          ),
        ),
      );
    }
  }
}
