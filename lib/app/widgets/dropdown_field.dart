import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../const/style.dart';

class DropdownInputField extends StatelessWidget {
  final String? title;
  final String hintText;
  final Color fillColor;
  final Color titleColor;
  final double? height;
  final bool? readOnly;
  final Widget? suffixIcon;
  final EdgeInsetsGeometry? contentPadding;
  final List<String> items; // List of String values
  final String? value;
  final void Function(String?)? onChanged;
  final String? Function(String?)? validator; // Validator function
  final void Function(String?)? onSaved; // onSaved callback

  const DropdownInputField({
    Key? key,
    this.title,
    required this.items,
    this.value,
    this.onChanged,
    this.suffixIcon,
    this.readOnly,
    this.hintText = "",
    this.contentPadding,
    this.height,
    this.validator,
    this.onSaved,
    this.fillColor = Colors.white,
    this.titleColor = Colors.white,
  }) : super(key: key);

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
          const SizedBox(height: 15),
        Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(5),
              // color: fillColor
          ),
          height: height,
          child: DropdownButtonFormField<String>(
            icon: SvgPicture.asset("assets/icons/arrow_down.svg"),
            isExpanded: true,
            value: value,
            items: items.map((String item) {
              return DropdownMenuItem<String>(
                value: item,
                child: Text(item),
              );
            }).toList(),
            onChanged: onChanged,
            validator: validator,
            onSaved: onSaved,
            style: Style.fonts.w400s14.copyWith(color: Style.colors.secondary),
            decoration: InputDecoration(
              hintText: hintText,
              isCollapsed: true,
              suffixIcon: suffixIcon,
              isDense: true,
              filled: true,
              fillColor: fillColor,
              contentPadding: contentPadding ?? const EdgeInsets.symmetric(horizontal: 18, vertical: 13),
              hintStyle: Style.fonts.w400s14.copyWith(color: const Color(0xFFBDBDBD)),
                border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(5))
            ),
          ),
        ),
      ],
    );
  }
}
