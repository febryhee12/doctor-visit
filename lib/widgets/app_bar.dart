import 'package:flutter/material.dart';

class HVBar {
  appbar({
    bool automaticallyImplyLeading = false,
    Color? backgroundColor,
    Widget? title,
    Widget? leading,
    List<Widget>? action,
    double? elevation,
    PreferredSizeWidget? bottom,
  }) {
    return AppBar(
      automaticallyImplyLeading: automaticallyImplyLeading,
      backgroundColor: backgroundColor,
      title: title,
      leading: leading,
      actions: action,
      elevation: elevation,
      bottom: bottom,
    );
  }
}
