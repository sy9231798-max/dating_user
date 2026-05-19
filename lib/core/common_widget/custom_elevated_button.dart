import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  const CustomElevatedButton({super.key, required this.child, this.onPressed, this.padding, this.style});

  final Widget child;
  final void Function()? onPressed;
  final EdgeInsetsGeometry? padding;
  final ButtonStyle? style;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: style,

      onPressed: onPressed,
      child: child,
    );
  }
}
