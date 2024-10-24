import 'package:flutter/material.dart';
import 'package:home_visit/styles/color.dart';

class CustomDropDownFormField {
  DropdownButtonFormField dropDown({
    Widget? labelText,
    //
    double? verticalTextPadding,
    double? horizontalTextPadding,
    //
    double? borderRadius,
    //
    List<DropdownMenuItem<dynamic>>? items,
    //
    Widget? hint,
    //
    dynamic value,
    //
    //
    void Function(dynamic)? onChanged,
    void Function(dynamic)? onSaved,
    String? Function(dynamic)? validator,
    //
  }) {
    BorderRadius borderRadius_;
    borderRadius != null
        ? borderRadius_ = BorderRadius.circular(borderRadius)
        : borderRadius_ = BorderRadius.circular(5.0);

    return DropdownButtonFormField(
        isExpanded: true,
        validator: validator,
        value: value,
        decoration: InputDecoration(
          label: labelText,
          contentPadding: EdgeInsets.symmetric(
              vertical: verticalTextPadding ?? 10,
              horizontal: horizontalTextPadding ?? 20),
          enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
            borderSide: BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: borderRadius_,
            borderSide: const BorderSide(color: HVColors.primary),
          ),
          border: OutlineInputBorder(
            borderRadius: borderRadius_,
            borderSide: const BorderSide(color: Colors.white),
          ),
        ),
        items: items,
        hint: hint,
        onChanged: onChanged,
        onSaved: onSaved);
  }
}
