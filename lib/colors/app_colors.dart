import 'package:flutter/material.dart';

class AppColors {
  static LinearGradient get splashGradient => LinearGradient(
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
    colors: [
      mainColor,
      mainColor2,
    ],
  );

  static LinearGradient get backgroundGradient => LinearGradient(
    begin: Alignment.bottomLeft,
    end: Alignment.topRight,
    stops: const [0, 0.5],
    colors: [
      mainColor,
      mainColor2,
    ],
  );

  static LinearGradient get buttonGradient => const LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    stops: [0, 1],
    colors: [
      Color(0xff73470f),
      Color(0xffa99070)
    ],
  );

  static Color get mainColor => const Color(0xff1f1304);

  static Color get mainColor2 => const Color(0xffa99070);

  static Color get textButtonColor => mainColor;

  static Color shadowColor = const Color(0xff000000).withOpacity(.1);

  static Color textColor = Colors.white;

  static Color inputIconColor = const Color(0xffC3CFDA);

  static Color textFieldColor = const Color(0xff4B4B4B);

}
