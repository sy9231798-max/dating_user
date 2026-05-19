import 'package:dating_user/core/constant/app_text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    this.label = "",
    this.prefixIcon,
    this.suffixIcon,
    this.keyboardType,
    this.hint,
    this.readOnly = false,
    this.onTap,
    this.controller,
    this.onChanged,
    this.inputFormatters,
  });

  final String label;
  final Widget? prefixIcon, suffixIcon;
  final TextInputType? keyboardType;
  final String? hint;
  final bool readOnly;
  final Function()? onTap;
  final Function(String value)? onChanged;
  final TextEditingController? controller;
  final List<TextInputFormatter>? inputFormatters;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: .start,
      spacing: 6,
      children: [
        if (label.isNotEmpty)
          Text(
            label,
            style: AppTextStyle.normalPoppins.copyWith(
              fontSize: 14,
              color: Colors.white,
            ),
          ),
        TextFormField(
          onTap: onTap,
          onTapOutside: (event) {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          onChanged: onChanged,
          controller: controller,
          inputFormatters: inputFormatters,
          readOnly: readOnly,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            filled: true,
            fillColor: Color(0xffF3EEFF),

            prefixIcon: prefixIcon,
            hintText: hint ?? label,

            // hintStyle: TextStyle(fontSize: 14, color: Colors.grey),
            hintStyle: AppTextStyle.normalPoppins.copyWith(
              fontSize: 14,
              color: Colors.grey,
            ),
            contentPadding: .symmetric(horizontal: 6, vertical: 0),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.transparent),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.transparent),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.transparent),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.transparent),
            ),
          ),
        ),
      ],
    );
  }
}
