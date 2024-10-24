import 'package:flutter/material.dart';

class TextBtn {
  button({
    final Function()? onPressed,
    String? label = "",
    Color? backgroundColor,
    TextStyle? textStyle,
    BoxBorder? border,
    double? width,
    EdgeInsetsGeometry? padding =
        const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
    BorderRadiusGeometry? borderRadius =
        const BorderRadius.all(Radius.circular(5)),
    Widget icon = const SizedBox(
      height: 0,
    ),
  }) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          border: border,
          borderRadius: borderRadius,
        ),
        width: width,
        padding: padding,
        child: Center(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              icon,
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  '$label',
                  style: textStyle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
