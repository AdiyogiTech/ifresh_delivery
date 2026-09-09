import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ifresh_delivery/colors/colors.dart';

class AuthTextField extends StatelessWidget {
  final String? hintText;
  final TextInputType? keyboardType;
  final TextEditingController? controller;
  final TextInputAction? textInputAction;
  final String? Function(String?)? validator;
  final TextCapitalization textCapitalization;
  final List<TextInputFormatter>? inputFormatters;
  final bool obscure;
  final int? length;
  final String? IconImage;
  final double? Imagescale;
  final double? Imageheight;
  final Widget? suffixIcon;
  final Color? hoverColor;
  final Color? iconColor;

  // ADD THESE MISSING PARAMETERS
  final Color? borderColor;
  final Color? fillColor;
  final double? borderRadius;
  final double? elevation;

  const AuthTextField({
    super.key,
    this.hintText,
    this.controller,
    this.textInputAction,
    this.validator,
    this.length,
    this.obscure = false,
    this.inputFormatters,
    this.textCapitalization = TextCapitalization.none,
    this.keyboardType,
    this.IconImage,
    this.Imagescale = 4,
    this.Imageheight = 30,
    this.suffixIcon,
    this.hoverColor,
    this.iconColor,

    // Initialize missing parameters
    this.borderColor,
    this.fillColor,
    this.borderRadius,
    this.elevation,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          color: fillColor ?? Colors.white,
          borderRadius: BorderRadius.circular(borderRadius ?? 10),
          boxShadow: elevation != null && elevation! > 0
              ? [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: elevation! * 2,
              offset: const Offset(0, 2),
            ),
          ]
              : null,
        ),
        child: TextFormField(
          keyboardType: keyboardType,
          controller: controller,
          validator: validator,
          textCapitalization: textCapitalization,
          textInputAction: textInputAction,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          obscureText: obscure,
          inputFormatters: inputFormatters,
          maxLength: length,
          maxLines: 1,
          cursorColor: primary,
          cursorWidth: 1.5,
          cursorRadius: const Radius.circular(2),
          style: const TextStyle(
            fontSize: 15,
            color: Colors.black87,
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            fillColor: fillColor ?? Colors.transparent,
            filled: fillColor != null,

            // Use borderColor if provided, otherwise use default styling
            border: borderColor != null
                ? OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius ?? 10),
              borderSide: BorderSide(color: borderColor!, width: 1),
            )
                : OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius ?? 10),
              borderSide: BorderSide(color: Colors.grey.shade400, width: 1),
            ),

            focusedBorder: borderColor != null
                ? OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius ?? 10),
              borderSide: BorderSide(color: borderColor!, width: 1.5),
            )
                : OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius ?? 10),
              borderSide: BorderSide(color: primary, width: 1.5),
            ),

            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius ?? 10),
              borderSide: const BorderSide(color: Colors.red, width: 1),
            ),

            enabledBorder: borderColor != null
                ? OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius ?? 10),
              borderSide: BorderSide(color: borderColor!, width: 1),
            )
                : OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius ?? 10),
              borderSide: BorderSide(color: Colors.grey.shade400, width: 1),
            ),

            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius ?? 10),
              borderSide: const BorderSide(color: Colors.red, width: 1.5),
            ),

            disabledBorder: borderColor != null
                ? OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius ?? 10),
              borderSide: BorderSide(color: borderColor!.withOpacity(0.5), width: 1),
            )
                : OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius ?? 10),
              borderSide: BorderSide(color: Colors.grey.shade400, width: 1),
            ),

            isDense: true,
            hintText: hintText,
            hintStyle: TextStyle(
              color: Colors.grey[400],
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
            counterText: "",
            contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),

            prefixIconConstraints: const BoxConstraints(maxWidth: 65),
            prefixIcon: IconImage != null
                ? Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Image.asset(
                    IconImage!,
                    scale: Imagescale ?? 3,
                    height: Imageheight ?? 22,
                    width: 22,
                    color: iconColor,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(
                        Icons.person_outline,
                        color: primary,
                        size: 18,
                      );
                    },
                  ),
                ),
              ),
            )
                : null,

            suffixIcon: suffixIcon != null
                ? Padding(
              padding: const EdgeInsets.only(right: 8),
              child: suffixIcon,
            )
                : null,

            suffixIconConstraints: const BoxConstraints(
              minWidth: 40,
              minHeight: 40,
            ),

            hoverColor: hoverColor,
          ),
        ),
      ),
    );
  }
}

OutlineInputBorder _OutlineInputBorder(Color borderColor) {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: BorderSide(color: borderColor, width: 1),
  );
}