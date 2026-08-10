import 'package:flutter/material.dart';

class AppColors {
  static const Color primaryBase = Color(0xff27783B);
  static const Color primaryTint = Color(0xffD8F0E1);
  static const Color accentOrange = Color(0xFF451605);
  static const Color accentBlue = Color(0xFF0A71EB);
  static const Color slate100 = Color(0xffF1F5F9);
  static const Color errorBase = Color(0xffEB5757);
  static const Color neutral950 = Color(0xFF292929);
  static const Color neutralWhite = Color(0xFFFFFFFF);
  static const Color textColorPrimary = Color(0xff1A1A1A);
}

extension ColorExtensions on BuildContext {
  Color get primary => AppColors.primaryBase;
  Color get primaryTint => AppColors.primaryTint;
  Color get accentOrange => AppColors.accentOrange;
  Color get accentBlue => AppColors.accentBlue;
  Color get slate100 => AppColors.slate100;
  Color get errorBase => AppColors.errorBase;
  Color get neutral950 => AppColors.neutral950;
  Color get neutralWhite => AppColors.neutralWhite;
  Color get textColorPrimary => AppColors.textColorPrimary;
}
