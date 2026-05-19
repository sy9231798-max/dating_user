import 'package:another_flushbar/flushbar.dart';
import 'package:dating_user/core/constant/app_text_style.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

void successSnackBar(BuildContext context, String message) {
  Flushbar(
    flushbarStyle: FlushbarStyle.FLOATING,
    backgroundColor: Colors.transparent,
    duration: Duration(seconds: 2),
    flushbarPosition: FlushbarPosition.TOP,
    messageText: Container(
      margin: EdgeInsets.only(bottom: 4),
      width: double.infinity,
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xff1E8933), width: 3)),
      ),
      child: Row(
        spacing: 12,
        children: [
          Icon(Iconsax.tick_circle,color: Colors.green,),
          Expanded(
            child: Text(
              message,
              style: AppTextStyle.mediumPoppins.copyWith(
                fontSize: 14,
                height: 1.2,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    ),
  ).show(context);
}

Future<void> errorSnackBar(BuildContext context, String message) async {
  await Flushbar(
    flushbarStyle: FlushbarStyle.FLOATING,
    backgroundColor: Colors.transparent,
    duration: Duration(seconds: 2),
    flushbarPosition: FlushbarPosition.TOP,
    messageText: Container(
      margin: EdgeInsets.only(bottom: 4),
      width: double.infinity,
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xffA80000), width: 3)),
      ),
      child: Row(
        spacing: 12,
        children: [
          Icon(Icons.error,color: Colors.red,),
          Expanded(
            child: Text(
              message,
              style: AppTextStyle.mediumPoppins.copyWith(
                fontSize: 14,
                height: 1.2,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    ),
  ).show(context);
}
