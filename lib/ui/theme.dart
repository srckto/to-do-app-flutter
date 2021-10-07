import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

const Color k_primaryClr = Color(0xFF4e5ae8);
const Color k_orangeClr = Color(0xCFFF8746);
const Color k_pinkClr = Color(0xFFff4667);
const Color k_white = Colors.white;
const Color k_darkGreyClr = Color(0xFF121212);
const Color k_darkHeaderClr = Color(0xFF424242);

class Themes {
  static final lightTheme = ThemeData(
    primaryColor: k_primaryClr,
    backgroundColor: Colors.white,
    brightness: Brightness.light,
  );
  static final darkTheme = ThemeData(
    primaryColor: k_darkGreyClr,
    backgroundColor: k_darkGreyClr,
    brightness: Brightness.dark,
  );
}

TextStyle get k_headingStyle {
  return GoogleFonts.lato(
    textStyle: TextStyle(
      color: Get.isDarkMode ? Colors.white : Colors.black,
      fontSize: 25,
      fontWeight: FontWeight.bold,
    ),
  );
}

TextStyle get k_subHeadingStyle {
  return GoogleFonts.lato(
    textStyle: TextStyle(
      color: Get.isDarkMode ? Colors.white : Colors.black,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
  );
}

TextStyle get k_titleStyle {
  return GoogleFonts.lato(
    textStyle: TextStyle(
      color: Get.isDarkMode ? Colors.white : Colors.black,
      fontSize: 18,
      fontWeight: FontWeight.w600,
    ),
  );
}

TextStyle get k_subTitleStyle {
  return GoogleFonts.lato(
    textStyle: TextStyle(
      color: Get.isDarkMode ? Colors.white : Colors.black,
      fontSize: 16,
      fontWeight: FontWeight.normal,
    ),
  );
}

TextStyle get k_bodyStyle {
  return GoogleFonts.lato(
    textStyle: TextStyle(
      color: Get.isDarkMode ? Colors.white : Colors.black,
      fontSize: 14,
      fontWeight: FontWeight.normal,
    ),
  );
}

TextStyle get k_body2Style {
  return GoogleFonts.lato(
    textStyle: TextStyle(
      color: Get.isDarkMode ? Colors.grey[200] : Colors.black,
      fontSize: 25,
      fontWeight: FontWeight.w600,
    ),
  );
}
