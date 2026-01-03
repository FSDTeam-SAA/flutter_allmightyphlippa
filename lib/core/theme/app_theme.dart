import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData get dark => ThemeData(
    scaffoldBackgroundColor: AppColors.primaryBackground,
    primaryColor: AppColors.primaryBackground,
    colorScheme: ColorScheme.dark(primary: AppColors.primaryBackground),

    textTheme: GoogleFonts.manropeTextTheme(),
    // appBarTheme: AppBarTheme(
    //   titleTextStyle: TextStyle(
    //     color: AppColors.,
    //     fontSize: 16,
    //     fontWeight: FontWeight.w600,
    //   ),
    // ),
  );
}
