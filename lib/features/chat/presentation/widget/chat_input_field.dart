import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class ChatInputField extends StatelessWidget {
  const ChatInputField({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Color(0xff438E96))),
      ),
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: SizedBox(
        height: 45,
        child: Row(
          children: [
            Expanded(
              child: Container(
                height: double.infinity,
                decoration: BoxDecoration(
                  color: Color(0xffDDEFF0),
                  border: Border.all(color: Color(0xff438E96)),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: TextField(
                  expands: true,
                  maxLines: null,
                  minLines: null,
                  controller: TextEditingController(),
                  style: TextStyle(color: Color(0xff438E96)),
                  decoration: InputDecoration(
                    hintText: "Enter Message",
                    hintStyle: TextStyle(color: Color(0xff438E96)),
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    prefixIcon: IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.emoji_emotions),
                    ),
                    suffixIcon: IconButton(
                      onPressed: () async {
                        // final image = await ImagePicker().pickImage(
                        //   source: ImageSource.gallery,
                        // );
                        // if (image != null) {
                        //   FullScreenLoader.imageSendConfirmation(
                        //     onConfirm: () {
                        //       FullScreenLoader.stopLoader();
                        //       chatController.sendChat(false, image);
                        //     },
                        //   );
                        // }
                      },
                      icon: Icon(Iconsax.gallery),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 12),
            SizedBox(
              height: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(padding: EdgeInsets.zero),
                onPressed: () {
                
                },
                child: Icon(Iconsax.send)
              ),
            ),
          ],
        ),
      ),
    );
  }
}
