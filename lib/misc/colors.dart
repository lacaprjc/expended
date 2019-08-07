import 'dart:ui';

import 'package:flutter/material.dart';

class AppColors {
  // standard colors
  static const Color whisper = Color(0xFFEBE8F1); // light purple
  static const Color seance = Color(0xFF6C18A4); // purple
  static const Color redViolet = Color(0xFFE51EAD); // pink
  static const Color govBay = Color(0xFF3827B4); // blue
  static const Color green = Color(0xFF3fada8);
  static const Color accountCard1 = Color(0xFF9D50BB);
  static const Color accountCard2 = Color(0xFF6E48AA);

  static const Color rainyAshville1 = Color(0xfffbc2eb);
  static const Color rainyAshville2 = Color(0xffa6c1ee);

  static const Color nearMoon1 = Color(0xff5ee7df);
  static const Color nearMoon2 = Color(0xffb490ca);

  static const Color morpheusDen1 = Color(0xff30cfd0);
  static const Color morpheusDen2 = Color(0xff330867);

  static const Color newYork1 = Color(0xfffff1eb);
  static const Color newYork2 = Color(0xfface0f9);

  static const Color aquaSplash1 = Color(0xff13547a);
  static const Color aquaSplash2 = Color(0xff80d0c7);

  static const Color midnightBloom1 = Color(0xff2b5876);
  static const Color midnightBloom2 = Color(0xff4e4376);
}

class AppGradients {
  // dark purple to light purple
  static const LinearGradient accountCard =
      LinearGradient(colors: [AppColors.accountCard1, AppColors.accountCard2]);

  // blue to purple
  static const LinearGradient rainyAshville = LinearGradient(
      colors: [AppColors.rainyAshville1, AppColors.rainyAshville2]);

  // purple to green
  static const LinearGradient nearMoon = LinearGradient(
    colors: [AppColors.nearMoon1, AppColors.nearMoon2],
    begin: Alignment.bottomCenter,
    end: Alignment.topCenter,
  );

  static const LinearGradient morpheusDen = LinearGradient(
    colors: [AppColors.morpheusDen1, AppColors.morpheusDen2],
    begin: Alignment.bottomCenter,
    end: Alignment.topCenter,
  );

  static const LinearGradient newYork = LinearGradient(
    colors: [AppColors.newYork1, AppColors.newYork2],
    begin: Alignment.bottomCenter,
    end: Alignment.topCenter,
  );

  static const LinearGradient aquaSplash = LinearGradient(
    colors: [AppColors.aquaSplash1, AppColors.aquaSplash2],
    begin: Alignment.bottomCenter,
    end: Alignment.topCenter,
  );

  static const LinearGradient midnightBloom = LinearGradient(
    colors: [AppColors.midnightBloom1, AppColors.midnightBloom2],
    begin: Alignment.bottomCenter,
    end: Alignment.topCenter,
  );
}

class AppThemes {
  static final ThemeData mainTheme = ThemeData(
    fontFamily: 'Montserrat',
    scaffoldBackgroundColor: AppColors.whisper,
    accentColor: AppColors.seance,
    primaryColor: AppColors.seance,
    cursorColor: AppColors.seance,
    iconTheme: IconThemeData(color: AppColors.govBay),
    focusColor: AppColors.seance,
  );

  static final ThemeData theme2 = mainTheme.copyWith();
}
