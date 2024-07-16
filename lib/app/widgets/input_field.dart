import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../const/style.dart';

class InputField extends StatelessWidget {
  final String? title;
  final String hintText;
  final Color fillColor;
  final Color titleColor;
  final bool obscureText;
  final double? height;
  final bool? readOnly;
  final Widget? suffixIcon;
  final EdgeInsetsGeometry? contentPadding;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final TextEditingController? controller;
  final String? Function(String?)? validator; // Validator function
  final void Function(String?)? onSaved; // onSaved callback

  const   InputField({super.key,
    this.title,
    this.suffixIcon,
    this.keyboardType,
    this.inputFormatters,
    this.readOnly,
     this.hintText = "",
    this.contentPadding,
     this.controller,
    this.height,
    this.validator,
    this.onSaved,
    this.obscureText = false,
    this.fillColor = Colors.white,
    this.titleColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if(title!=null)
        Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.only(top: 16,bottom: 8),
          child: Text(title!, style: Style.fonts.w400s16.copyWith(color: titleColor),),
        )
        else
          const SizedBox(height: 16),
        Container(alignment: Alignment.center,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(5),
              // color: fillColor
          ),

          height: height,
          child: TextFormField(
            keyboardType: keyboardType,
            inputFormatters: inputFormatters,
            cursorColor: Colors.black,
            obscureText: obscureText,
            style:  Style.fonts.w400s14.copyWith(color: Style.colors.secondary),
            controller: controller,
            validator: validator, // Assign the validator function
            onSaved: onSaved, // Assign the onSaved callback
            readOnly: readOnly??false,
            decoration: InputDecoration(
              fillColor: fillColor,
              filled: true,
              hintText: hintText,
              isCollapsed: true,
              suffixIcon: suffixIcon,
              isDense: true,
              contentPadding: contentPadding ?? const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
              hintStyle: Style.fonts.w400s14.copyWith(color:  const Color(0xFFBDBDBD)),
                border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(5))),
          ),
        ),
      ],
    );
  }
}
