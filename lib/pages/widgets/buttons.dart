import 'package:flutter/material.dart';

class CustomFilledButton extends StatelessWidget {
  final void Function()? onPressed;
  final double fontSize;
  final FontWeight fontWeight;
  final Widget child;
  const CustomFilledButton({
    Key? key,
    this.onPressed,
    required this.fontSize,
    this.fontWeight = FontWeight.normal,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      style: FilledButton.styleFrom(
        backgroundColor: Colors.white,
        textStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: fontWeight,
        ),
        padding: const EdgeInsets.symmetric(
          vertical: 10.0,
        ),
      ),
      onPressed: onPressed,
      child: child,
    );
  }
}

class CustomTextButton extends StatelessWidget {
  final void Function()? onPressed;
  final Color? foregroundColor;
  final double fontSize;
  final FontWeight fontWeight;
  final Widget child;
  const CustomTextButton({
    Key? key,
    this.onPressed,
    this.foregroundColor,
    required this.fontSize,
    this.fontWeight = FontWeight.normal,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: foregroundColor,
        textStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: fontWeight,
        ),
        minimumSize: Size.zero,
        padding: EdgeInsets.zero,
      ),
      child: child,
    );
  }
}
