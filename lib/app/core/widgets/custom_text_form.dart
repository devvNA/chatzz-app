import 'package:chatzz/app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextForm extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final String? Function(String?)? validator;
  final Widget? prefixIcon;
  final TextInputType? keyboardType;
  final bool? obscureText;
  final int? maxLines;
  final Widget? suffixIcon;
  final bool? enabled;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;
  final Function()? onTap;
  final Function()? onEditingComplete;
  final Function()? onTapOutside;
  final String? prefixText;
  final String? suffixText;
  final String? initialValue;
  final String? helperText;
  final bool? readOnly;
  final List<TextInputFormatter>? inputFormatters;

  const CustomTextForm({
    super.key,
    this.controller,
    required this.hintText,
    this.validator,
    this.prefixIcon,
    this.keyboardType,
    this.obscureText,
    this.maxLines,
    this.suffixIcon,
    this.enabled,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.onEditingComplete,
    this.onTapOutside,
    this.prefixText,
    this.suffixText,
    this.initialValue,
    this.helperText,
    this.readOnly,
    this.inputFormatters,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: enabled ?? true,
      readOnly: readOnly ?? false,
      onTap: onTap,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: controller,
      maxLines: maxLines ?? 1,
      obscureText: obscureText ?? false,
      scrollPadding: EdgeInsets.only(bottom: MediaQuery.sizeOf(context).height),
      cursorColor: AppColors.primary,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 14),
        isDense: true,
        suffixIcon: suffixIcon,
        prefixIconColor: AppColors.primary,
        suffixIconColor: Colors.grey[400],
        fillColor: Colors.grey[200],
        filled: true,
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(color: AppColors.primary),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.primary),
        ),
        hintText: hintText,
        prefixIcon: prefixIcon != null
            ? Padding(
                padding: EdgeInsets.symmetric(horizontal: 14.0, vertical: 10),
                child: prefixIcon,
              )
            : null,
      ),
      validator: validator,
    );
  }
}

class CustomTextFormSimple extends StatelessWidget {
  final TextEditingController? controller;
  final String label;
  final String? hintText;
  final int? maxLines;
  final String? prefixText;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final String? suffixText;
  final void Function()? onTap;
  final Function(String)? onChanged;
  final bool? readOnly;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final List<TextInputFormatter>? inputFormatters;
  final String? initialValue;
  final int? maxLength;

  // Property baru untuk font sizing
  final double? fontSize; // Ukuran font untuk input text
  final double? hintFontSize; // Ukuran font untuk hint text
  final double? labelFontSize; // Ukuran font untuk label
  final TextStyle?
  textStyle; // Custom text style (override fontSize jika diset)
  final TextStyle?
  hintStyle; // Custom hint style (override hintFontSize jika diset)
  final TextStyle?
  labelStyle; // Custom label style (override labelFontSize jika diset)
  final TextStyle? floatingLabelStyle; // Custom floating label style

  const CustomTextFormSimple({
    super.key,
    this.controller,
    required this.label,
    this.hintText,
    this.maxLines,
    this.prefixText,
    this.keyboardType,
    this.validator,
    this.suffixText,
    this.onTap,
    this.readOnly,
    this.suffixIcon,
    this.prefixIcon,
    this.inputFormatters,
    this.initialValue,
    this.onChanged,
    this.maxLength,
    // Font properties
    this.fontSize = 14.0, // Default font size untuk input
    this.hintFontSize, // Default akan mengikuti fontSize
    this.labelFontSize, // Default akan mengikuti fontSize
    this.textStyle,
    this.hintStyle,
    this.labelStyle,
    this.floatingLabelStyle,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLength: maxLength ?? 100,
      controller: controller,
      maxLengthEnforcement: MaxLengthEnforcement.enforced,
      initialValue: initialValue,
      inputFormatters: inputFormatters,
      readOnly: readOnly ?? false,
      onTap: onTap,
      onChanged: onChanged,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      maxLines: maxLines,
      keyboardType: keyboardType,
      // Custom text style dengan fontSize
      style:
          textStyle ??
          TextStyle(
            fontSize: fontSize,
            color: Colors.black87,
            // color: readOnly == true ? Colors.grey[600] : Colors.black87,
          ),
      validator: validator,
      decoration: InputDecoration(
        counter: const SizedBox.shrink(),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 10,
        ),
        labelText: label,
        hintText: hintText,
        prefixText: prefixText,

        // Custom label style
        labelStyle:
            labelStyle ??
            TextStyle(color: Colors.grey, fontSize: labelFontSize ?? fontSize),

        // Custom floating label style
        floatingLabelStyle:
            floatingLabelStyle ??
            TextStyle(
              color: Colors.blue,
              fontSize:
                  (labelFontSize ?? fontSize ?? 14.0) *
                  0.85, // Sedikit lebih kecil
            ),

        // Custom hint style
        hintStyle:
            hintStyle ??
            TextStyle(
              color: Colors.grey[400],
              fontSize: hintFontSize ?? fontSize,
            ),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.blue),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.blue),
        ),
        fillColor: Colors.white,
        // fillColor: readOnly == true ? Colors.grey[100] : Colors.white,
        filled: true, // Tambahkan ini untuk fillColor bekerja
        suffixText: suffixText,
        suffixIcon: suffixIcon,
        isDense: true,
        prefixIcon: prefixIcon,
      ),
    );
  }
}
