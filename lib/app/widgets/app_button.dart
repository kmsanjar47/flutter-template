import 'package:flutter/material.dart';
import 'package:m_expense/app/const/style.dart';

class AppButton extends MaterialButton {
  final String text;
  final Color textColor;
  final Color buttonColor; // Added button color parameter

  AppButton({
     this.text = "Title",
     this.textColor = const Color(0xffFCFCFC),
     this.buttonColor = const Color(0xff0DA7E0), // Added button color parameter
    VoidCallback? onPressed,
  }) : super(
    onPressed: onPressed,
    color: buttonColor, // Use the provided button color
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(5),
    ),
    child: Text(
      text,
      style: TextStyle(
        color: textColor,
        fontWeight: FontWeight.w500,
        fontSize: 18,
      ),
    ),
  );
}
