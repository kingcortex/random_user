import 'package:flutter/material.dart';
import 'package:random_user/core/theme/text_theme.dart';
import '/core/theme/app_font.dart';
import 'app_colors.dart';

class AppTheme {
  /// Thème clair (par défaut)
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    fontFamily: AppFont.textFont,
    primaryColor: AppColors.primaryBase,
    // scaffoldBackgroundColor: AppColors.secondaryAlbescent50,
    appBarTheme: const AppBarTheme(
      // backgroundColor: AppColors.secondaryAlbescent50,
      titleTextStyle: TextStyle(
        fontFamily: AppFont.titleFont,
        color: AppColors.neutral950,
        fontSize: 18,
        fontWeight: FontWeight.w500,
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      height: kBottomNavigationBarHeight,
      // backgroundColor: AppColors.secondaryAlbescent50,
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
          ); // Couleur quand sélectionné
        }
        return const TextStyle(
          color: AppColors.textColorPrimary,
          fontWeight: FontWeight.w600,
          fontSize: 11,
          height: .7,
          fontFamily: AppFont.titleFont,
        ); // Couleur par défaut
      }),
    ),
    colorScheme: const ColorScheme.light(
      primary: AppColors.primaryBase,
      // secondary: AppColors.blueDianne600,
      surface: AppColors.neutralWhite,
      onPrimary: AppColors.neutralWhite,
      onSecondary: AppColors.neutralWhite,
      // onSurface: AppColors.neutral900,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.primarySun950,
      extendedTextStyle: TextStyle(fontFamily: AppFont.textFont),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        textStyle: const TextStyle(
          color: AppColors.primarySun950,
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
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
  );

 
}
