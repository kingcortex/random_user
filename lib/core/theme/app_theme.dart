import 'package:flutter/material.dart';

import 'package:random_user/core/theme/app_colors.dart';
import 'package:random_user/core/theme/app_font.dart';
import 'package:random_user/core/theme/sizes.dart';
import 'package:random_user/core/theme/spacing.dart';
import 'package:random_user/core/theme/text_theme.dart';

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    fontFamily: AppFont.textFont,
    primaryColor: AppColors.primaryBase,
    appBarTheme: const AppBarTheme(
      titleTextStyle: TextStyle(
        fontFamily: AppFont.titleFont,
        color: AppColors.neutral950,
        fontSize: 18,
        fontWeight: FontWeight.w500,
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      height: kBottomNavigationBarHeight,
      indicatorColor: Colors.transparent,
      overlayColor: WidgetStatePropertyAll(
        AppColors.primaryBase.withValues(alpha: .2),
      ),
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return TextStyle(
            fontFamily: AppFont.titleFont,
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: AppColors.primaryBase,
            height: .7,
          );
        }
        return const TextStyle(
          color: AppColors.textColorPrimary,
          fontWeight: FontWeight.w600,
          fontSize: 11,
          height: .7,
          fontFamily: AppFont.titleFont,
        );
      }),
    ),
    colorScheme: const ColorScheme.light(
      primary: AppColors.primaryBase,
      surface: AppColors.neutralWhite,
      onPrimary: AppColors.neutralWhite,
      onSecondary: AppColors.neutralWhite,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.accentOrange,
      extendedTextStyle: TextStyle(fontFamily: AppFont.textFont),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        textStyle: const TextStyle(
          color: AppColors.accentOrange,
          fontFamily: AppFont.textFont,
          fontSize: 14,
        ),
      ),
    ),
    textTheme: MyTextTheme.lightTextTheme,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryBase,
        foregroundColor: AppColors.neutralWhite,
        padding: Spacing.buttonPadding,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Sizes.buttonRadius),
        ),
      ),
    ),
  );
}
