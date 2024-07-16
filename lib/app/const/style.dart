
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Style{
  static final colors = AppColors();
  static final fonts = AppFontStyle();
  static const profilePhoto = "https://iidamidamerica.org/wp-content/uploads/2020/12/male-placeholder-image-768x768.jpeg";

}

class AppFontStyle{
  final TextStyle w700s32 = GoogleFonts.inter(color: AppColors().offWhite, fontSize: 32, fontWeight: FontWeight.w700);
  final TextStyle w600s48 = GoogleFonts.inter(color: AppColors().primary, fontSize: 48, fontWeight: FontWeight.w600);
  final TextStyle w600s28 = GoogleFonts.inter(color: AppColors().secondary, fontSize: 28, fontWeight: FontWeight.w600);
  final TextStyle w500s18 = GoogleFonts.inter(color: AppColors().primary, fontSize: 18, fontWeight: FontWeight.w500);
  final TextStyle w500s24 = GoogleFonts.inter(color: AppColors().white, fontSize: 24, fontWeight: FontWeight.w500);
  final TextStyle w500s22 = GoogleFonts.inter(color: AppColors().white, fontSize: 22, fontWeight: FontWeight.w500);
  final TextStyle w500s16 = GoogleFonts.inter(color: AppColors().white, fontSize: 16, fontWeight: FontWeight.w500);
  final TextStyle w500s14 = GoogleFonts.inter(color: AppColors().white, fontSize: 14, fontWeight: FontWeight.w500);
  final TextStyle w400s16 = GoogleFonts.inter(color: AppColors().white, fontSize: 16, fontWeight: FontWeight.w400);
  final TextStyle w400s14 = GoogleFonts.inter(color: AppColors().offWhite, fontSize: 14, fontWeight: FontWeight.w400);
  final TextStyle w400s12 = GoogleFonts.inter(color: AppColors().secondary, fontSize: 12, fontWeight: FontWeight.w400);
  final TextStyle w300s12 = GoogleFonts.inter(color: AppColors().secondary, fontSize: 12, fontWeight: FontWeight.w300);


}

class AppColors{
  final Color primary = const Color(0xff0DA7E0);
  final Color primaryLight = const Color(0xff32BCE8);
  final Color secondary = const Color(0xff49536A);
  final Color white = const Color(0xffFCFCFC);
  final Color offWhite = const Color(0xffF5F5F5);
}