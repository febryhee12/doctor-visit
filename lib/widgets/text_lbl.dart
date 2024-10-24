import 'package:flutter/material.dart';

class TextLbl {
  label({
    required String data,
    TextStyle? textStyle,
    TextAlign? textAlign,
    TextOverflow? overflow,
  }) {
    return Text(
      data,
      overflow: overflow,
      textAlign: textAlign,
      style: textStyle,
    );
  }
}
