import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:home_visit/styles/color.dart';

class CustomFormField {
  TextFormField field(
      {required String question,
      //
      required bool canBeNull,
      //
      Function? onSavedCallback,
      //
      GlobalKey<FormState>? formKey,
      //
      double? fieldTextFontSize,
      //
      String? initialValue,
      //
      double? verticalTextPadding,
      double? horizontalTextPadding,
      //
      Widget? icon,
      Widget? suffixIcon,
      Widget? prefixIcon,
      String? prefixText,
      TextStyle? prefixStyle,
      //
      double? borderRadius,
      //
      TextStyle? labelTextStyle,
      TextOverflow? overflow,
      TextCapitalization? textCapitalization,
      //
      bool? obscureText,
      String? obsecuringCharacter,
      //
      TextInputType? keyboardType,
      int? maxline = 1,
      int? maxlength,
      FocusNode? focusNode,
      bool? enableInteractiveSelection,
      //
      List<TextInputFormatter>? inputFormatters,
      //
      final String? Function(String?)? validator,
      TextEditingController? controller,
      bool readonly = false,
      bool autofocus = false,
      bool? enabled,
      //
      void Function(String)? onChanged,
      void Function()? onEditingComplete,
      void Function()? onTap,
      void Function(dynamic)? onSaved}) {
    BorderRadius borderRadius_;
    borderRadius != null
        ? borderRadius_ = BorderRadius.circular(borderRadius)
        : borderRadius_ = BorderRadius.circular(50.0);
    //
    return TextFormField(
      textCapitalization: TextCapitalization.none,
      focusNode: focusNode,
      enableInteractiveSelection: enableInteractiveSelection,
      onTap: onTap,
      enabled: enabled,
      onEditingComplete: onEditingComplete,
      autofocus: autofocus,
      obscuringCharacter: '*',
      readOnly: readonly,
      controller: controller,
      onChanged: onChanged,
      maxLines: maxline,
      maxLength: maxlength,
      initialValue: initialValue,
      textAlign: TextAlign.left,
      cursorColor: Colors.black,
      obscureText: obscureText!,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      style: GoogleFonts.ptSans(
        textStyle: TextStyle(
          fontSize: fieldTextFontSize,
        ),
      ),
      decoration: InputDecoration(
        alignLabelWithHint: true,
        errorMaxLines: 2,
        labelText: question,
        contentPadding: EdgeInsets.symmetric(
            vertical: verticalTextPadding ?? 10,
            horizontal: horizontalTextPadding ?? 20),
        errorBorder: OutlineInputBorder(
          borderRadius: borderRadius_,
          borderSide: const BorderSide(color: Colors.red),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: borderRadius_,
          borderSide: const BorderSide(color: HVColors.primary),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: borderRadius_,
          borderSide: const BorderSide(color: Colors.grey),
        ),
        border: OutlineInputBorder(
          borderRadius: borderRadius_,
          borderSide: const BorderSide(color: Colors.white),
        ),
        labelStyle: labelTextStyle ??
            TextStyle(
              overflow: overflow,
              fontSize: fieldTextFontSize,
              color: Colors.grey[700],
            ),
        // suffixIcon: icon != null ? icon : null,
        suffixIcon: suffixIcon,
        prefixIcon: prefixIcon,
        prefixText: prefixText,
        prefixStyle: prefixStyle,
        suffixIconColor: HVColors.primary,
        filled: true,
        fillColor: Colors.white,
      ),
      validator: validator,
      onSaved: onSaved,
    );
  }
}
