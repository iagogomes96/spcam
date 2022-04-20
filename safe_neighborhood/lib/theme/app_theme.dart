import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTheme {
  AppTheme(this.context);

  final BuildContext context;

  ThemeData get defaultTheme => ThemeData(
        primaryColor: AppColors.primary,
        backgroundColor: AppColors.background,
        textTheme: GoogleFonts.robotoTextTheme(Theme.of(context).textTheme),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        scaffoldBackgroundColor: AppColors.background,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            primary: AppColors.primary,
            onPrimary: Colors.white,
            textStyle:
                const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            minimumSize: const Size(double.infinity, 45),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(45),
            ),
          ),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          hintStyle: TextStyle(
            color: AppColors.textTitle,
            fontSize: 18,
            fontStyle: FontStyle.normal,
            fontWeight: FontWeight.w500,
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: AppColors.textTitle, width: 1),
          ),
        ),
        colorScheme: const ColorScheme(
            brightness: Brightness.dark,
            primary: AppColors.textTitle,
            onPrimary: AppColors.secondaryText,
            secondary: Colors.yellow,
            onSecondary: Colors.yellow,
            error: Colors.red,
            onError: Colors.red,
            background: AppColors.background,
            onBackground: AppColors.background,
            surface: AppColors.textTitle,
            onSurface: AppColors.textTitle),
        snackBarTheme: const SnackBarThemeData(
          backgroundColor: AppColors.primary,
          contentTextStyle: TextStyle(
              color: AppColors.textTitle,
              fontSize: 18,
              fontWeight: FontWeight.bold),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
        ),
        popupMenuTheme: PopupMenuThemeData(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            textStyle: const TextStyle(
                color: AppColors.textTitle, fontWeight: FontWeight.bold),
            color: AppColors.background),
      );
}
